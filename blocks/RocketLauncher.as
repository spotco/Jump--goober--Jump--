package blocks {
		import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class RocketLauncher extends FalldownBlock {
		
		public var launcherContainer:Sprite = new Sprite;
		public var chargeDot:Sprite = new Sprite;
		
		public var reattack:Number = 125;
		public var range:Number = 450;
		public var hitbox:Sprite = new Sprite;
		
		
		public function RocketLauncher(x:Number,y:Number) {
			super(0,0,0,0);
			this.x = x;
			this.y = y;
			baseimg.x = -75/2;
			baseimg.y = -68/2;
			this.addChild(baseimg);
			this.w = 20;
			this.h = 20;
			
			//this.graphics.beginFill(0x00FF00,0.5);
			//this.graphics.drawCircle(0,0,400);
			//this.graphics.endFill();
			
			launcherContainer.addChild(launcher1img);
			var xoff:Number =  -.5*launcherContainer.width;
			var yoff:Number =  -.5*launcherContainer.height;
			chargeDot.x = (19-75/2+18.5);
			chargeDot.y = (32-68/2-9);
			chargeDot.alpha = 0;
			chargeDot.graphics.beginFill(0xFF0000);
			chargeDot.graphics.drawCircle(0,0,3);
			
			launcherContainer.addChild(chargeDot);
			
			launcher1img.x = xoff;
			launcher1img.y = yoff;
			
			this.addChild(launcherContainer);
			
			hitbox.graphics.beginFill(0x0000FF,0);
			hitbox.graphics.drawCircle(0,0,30);
			this.addChild(hitbox);
		}
		
		public override function update(g:GameEngine):Boolean {
			if (g.testguy.hitTestObject(this.hitbox)) {
				return guyhit(g);
			}
			var tarAngle:Number = getTarAngle(this.x,this.y,g);
			if (Math.sqrt(Math.pow(this.x-g.testguy.x+13,2)+Math.pow(this.y-g.testguy.y+12,2)) < range) {
				 for (var i = 0; i < 4; i++) {
					 launcherContainer.rotation+=rotDir(launcherContainer.rotation,tarAngle);
				 }
				if (launcherContainer.rotation < -180) {
					launcherContainer.rotation = -180
				}
				chargeDot.alpha+=(1/reattack);
				
				if (chargeDot.alpha >= 1) {
					chargeDot.alpha = 0;			
					var dy:Number = +Math.cos(launcherContainer.rotation*(Math.PI/180))*40;
					var dx:Number = -Math.sin(launcherContainer.rotation*(Math.PI/180))*40;
					for (var i = 0; i < 24; i++) {
						var particle:RocketParticle;
						
						if (g.rocketparticlesreuse.length == 0) {
							particle = new RocketParticle;
						} else {
							particle = g.rocketparticlesreuse.pop();
						}
						
						
						var randSpd = Math.random()*10;
						particle.graphics.beginFill(0xcc6666);
						particle.graphics.drawCircle(0,0,5*Math.random());
						particle.alphaspd = 0.05;
						particle.x = this.x+dx; particle.y = this.y+dy;
						particle.vx = Math.sin(i*(Math.PI/12))*randSpd;
						particle.vy = Math.cos(i*(Math.PI/12))*randSpd;
						//particle.ay = 0.5;
						g.particles.push(particle);
						g.main.addChild(particle);
					}
					var newrocket:Rocket = new Rocket(this.x+(dx),this.y+(dy),launcherContainer.rotation);
					g.deathwall.push(newrocket);
					g.main.addChild(newrocket);
				}

			} else {
				chargeDot.alpha = 0;
				if (launcherContainer.rotation > 0) {
					launcherContainer.rotation--;
				} else if (launcherContainer.rotation < 0) {
					launcherContainer.rotation++;
				}
			}
			

			
		}
		
		public static function getTarAngle(x:Number,y:Number,g:GameEngine) {
			var tarAngle:Number = Math.round(FlowerBoss.getangle(x,y,g.testguy.x+13,g.testguy.y+12)-90);
			if (tarAngle < -180) {
				tarAngle = 360-Math.abs(tarAngle);
			}
			return tarAngle;
		}
		
		public static function rotDir(cur:Number,tar:Number):Number {
			var cwtestcount:Number = 0;
			var testcur:Number = cur;
			while (testcur != tar) {
				testcur++;
				cwtestcount++;
				if (testcur > 180) {
					testcur = -180;
				}
			}
			var ccwtestcount:Number = 0;
			testcur = cur;
			while (testcur != tar) {
				testcur--;
				ccwtestcount++;
				if (testcur < -180) {
					testcur = 180;
				}
			}
			if (cur == tar) {
				return 0;
			} else if (cwtestcount > ccwtestcount) {
				return -1;
			} else {
				return 1;
			}
		}
		
		
		public override function type():String {
			return "rocketlauncher";
		}
		
		[Embed(source='..//img//block//red//launcherbase.png')]
		private var lbdata:Class;
		private var baseimg:Bitmap = (new lbdata) as Bitmap;
		
		[Embed(source='..//img//block//red//launcher1.png')]
		private var l1data:Class;
		private var launcher1img:Bitmap = (new l1data) as Bitmap;
		
		
	}
	
}
