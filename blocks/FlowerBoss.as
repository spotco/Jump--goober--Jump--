package blocks {
		import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class FlowerBoss extends FalldownBlock {
		var hitboxbody:Sprite = new Sprite;
		var hitboxhead:Sprite = new Sprite;
		var hitboxstem:Sprite = new Sprite;
		
		var headwrapper:Sprite = new Sprite;
		
		var bulletcounter:Number = -50;
		var bulletspeed:Number = 60;
		
		var particlefield:Sprite = new Sprite;
		var particlesarray:Array = new Array;
		
		public function FlowerBoss(y:Number) {
			super(0,y,500,300);			
			addparticles();
			this.addChild(particlefield);
			flowerstem.x = 231; flowerstem.y = -34;
			this.addChild(flowerstem);
			
			headwrapper.addChild(flowerhead1);
			var xoff:Number =  -.5*headwrapper.width;
			var yoff:Number =  -.5*headwrapper.height;
			headwrapper.addChild(flowerhead2);
			headwrapper.addChild(flowerhead3);
			flowerhead1.x = xoff;
			flowerhead1.y = yoff;
			flowerhead2.x = xoff;
			flowerhead2.y = yoff;
			flowerhead3.x = xoff;
			flowerhead3.y = yoff;
			flowerhead1.visible = false;
			flowerhead2.visible = false;
			
			headwrapper.x = 253; headwrapper.y = -48;
			this.addChild(headwrapper);
			
			hitboxhelper();
			/*particlefield.graphics.beginFill(0xFF00FF);
			particlefield.graphics.drawRect(0,0,500,-150);*/
		}
		
		private var headanimatetimer:Number = 0;
		
		public override function update(g:GameEngine):Boolean {
			updateparticles();
			headwrapper.rotation = getangle(this.x+260,this.y - 40,g.testguy.x + g.testguy.width, g.testguy.y + g.testguy.height) + 90;
			
			bulletcounter++;
			if (bulletcounter%5 == 0) {
				animatehead();
			}
			
			if (bulletcounter > bulletspeed) {
				bulletcounter = 0;
				if (bulletspeed > 30) {
					bulletspeed-=2;
				}
				var angle:Number = -(headwrapper.rotation+90);
				g.main.playsfx(JumpDieCreateMain.shootsound);
				var newbullet:Bullet;
				if (g.bulletsreuse.length == 0) {
					newbullet = new Bullet(this.x + 253,this.y - 48,-Math.cos(angle*(Math.PI/180))*7,-Math.sin(angle*(Math.PI/180))*7);
				} else {
					newbullet = g.bulletsreuse.pop();
					newbullet.x = this.x + 253;
					newbullet.y = this.y - 48;
					newbullet.vx = -Math.cos(angle*(Math.PI/180))*7;
					newbullet.vy = -Math.sin(angle*(Math.PI/180))*7;
				}
				g.deathwall.push(newbullet);
				g.main.addChild(newbullet);
				
				clearhead();
				flowerhead2.visible = true;
				headanimatetimer = 4;
				
			}
			
			var spdmov:Number = Math.max((this.y-g.testguy.y)/75,0.5);
			this.y -= spdmov;
			
			return checkhit(g);
		}
		
		private function addparticles() {
			for (var i = 0; i < 20 ; i++) {
				var np:Particle = new Particle();
				np.graphics.beginFill(0xcc6666);
				np.graphics.drawCircle(0,0,2);
				np.vx = Math.random()*500;
				np.vy = -Math.random()*150;
				np.theta = Math.random()*Math.PI;
				np.c = Math.random()*50+50;
				particlefield.addChild(np);
				particlesarray.push(np);
			}
		}
		
		private function updateparticles() {
			for each(var p:Particle in particlesarray) {
				p.theta+=0.04;
				var r:Number = (p.c)*Math.sin(3*p.theta);
				p.x = p.vx+r*Math.cos(p.theta);
				p.y = p.vy+r*Math.sin(p.theta);
				if (p.theta > 2*Math.PI) {
					p.theta = 0;
				}
			}
		}
		
		private function animatehead() {
			if (headanimatetimer > 0) {
				headanimatetimer--;
				clearhead();
				if (headanimatetimer == 3) {
					flowerhead1.visible = true;
				} else if (headanimatetimer == 2) {
					flowerhead2.visible = true;
				} else {
					flowerhead3.visible = true;
				}
			}
		}
		
		public static function getangle(ax:Number,ay:Number,bx:Number,by:Number):Number {
			return Math.atan2(by - ay, bx - ax) * 180 / Math.PI;
		}
		
		private function clearhead() {
			flowerhead1.visible = false;
			flowerhead2.visible = false;
			flowerhead3.visible = false;
		}
		
		private function checkhit(g:GameEngine):Boolean {
			if (g.testguy.innerhitbox.hitTestObject(this.hitboxbody) ||
				g.testguy.innerhitbox.hitTestObject(this.hitboxstem) ||
				g.testguy.innerhitbox.hitTestObject(this.hitboxhead)
				) {
				g.main.playsfx(JumpDieCreateMain.explodesound);
				g.timer.stop();
				g.testguy.explode();
				g.timer = new Timer(1200,1);
				g.timer.start();
				g.timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(){g.reload();});
				return true;
			}
			return false;
			
		}
		
		private function hitboxhelper(show:Number = 0) {
			hitboxbody.graphics.beginFill(0x000000,show);
			hitboxhead.graphics.beginFill(0x000000,show);
			hitboxstem.graphics.beginFill(0x000000,show);
			hitboxstem.graphics.drawRect(232,-40,32,40);
			hitboxhead.graphics.drawRect(218,-80,60,60);
			hitboxbody.graphics.drawRect(0,0,500,300);
			this.addChild(hitboxbody);
			this.addChild(hitboxstem);
			this.addChild(hitboxhead);
		}
		
		public override function type():String {
			return "flowerboss";
		}
		
				[Embed(source='..//img//boss//flowerhead.png')]
		private var imgfhead:Class;
		private var flowerhead1:Bitmap = (new imgfhead) as Bitmap;
		
						[Embed(source='..//img//boss//flowerhead2.png')]
		private var imgfhead2:Class;
		private var flowerhead2:Bitmap = (new imgfhead2) as Bitmap;
		
						[Embed(source='..//img//boss//flowerhead3.png')]
		private var imgfhead3:Class;
		private var flowerhead3:Bitmap = (new imgfhead3) as Bitmap;
		
						[Embed(source='..//img//boss//flowerstem.png')]
		private var imgfstem:Class;
		private var flowerstem:Bitmap = (new imgfstem) as Bitmap;
		
	}
	
}
