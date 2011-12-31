package blocks {
		import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class RocketBoss extends FalldownBlock {
		
		private var bossbody:Sprite = new Sprite;
		private var rotatecontainer:Sprite = new Sprite;
		private var hitbox:Sprite = new Sprite;
		public var activatecontroller:BossActivate;
		
		private var animtimer:Number = 0;
		private var doParticles:Boolean = true;
		private var speed:Number = 7;
		
		public var side:Boolean = LEFT;
		
		public static var LEFT:Boolean = true;
		public static var RIGHT:Boolean = false;
		
		private var init:Boolean = false;
		
		private var flashtimer:Number = 0;
		private var flashcount:Number = 0;
		private var flashstatus:Boolean = false;
		
		public var doExplode:Boolean = false;
		
		private var deathanimcounter:Number = 0;
		
		public function RocketBoss(x:Number,y:Number) {
			super(0,0,0,0);
			this.x = x;
			this.y = y;
			
			rotatecontainer.addChild(bodyimg);
			rotatecontainer.addChild(bodyimg2);
			bodyimg2.visible = false;
			
			rp1.x = 52-29; rp1.y = 104;
			rp2.x = 52-29; rp2.y = 104;
			rp3.x = 52-29; rp3.y = 104;
			
			rp1.visible = true;
			rp2.visible = false;
			rp3.visible = false;
			
			rotatecontainer.addChild(rp1);
			rotatecontainer.addChild(rp2);
			rotatecontainer.addChild(rp3);
			
			bossbody.addChild(rotatecontainer);
			rotatecontainer.x = -.5*bossbody.width;
			rotatecontainer.y = -.5*bossbody.height;
			
			this.addChild(bossbody);
			
			//this.hitbox.graphics.beginFill(0x0000FF,0);
			//this.hitbox.graphics.drawCircle(0,0,50);
			this.addChild(this.hitbox);
			
			this.scaleX = 0.75;
			this.scaleY = 0.75;
		}
		
		public override function update(g:GameEngine):Boolean {
			var dx:Number = Math.sin(bossbody.rotation*(Math.PI/180));
			var dy:Number = -Math.cos(bossbody.rotation*(Math.PI/180));
			
			animatePropeller();
			animateParticles(dx,dy,g);
			flashanimation();
			
			if (deathanimcounter > 0) {
				if (flashtimer == 0) {
					flashtimer = 10;
					flashcount = 0;
				}
				deathanimcounter--;
				bossbody.rotation+=15;
				if (this.doExplode) {
					dieExplode(g);
				} else {
					dieNoExplode(g);
				}
				return die(g);
			}
			
			hitbox.x = dx*15;
			hitbox.y = dy*15;
			
			this.x += dx*speed;
			this.y += dy*speed;
						
			
			if (!init) {
				init = true;
				this.x = -105;
				this.y = 250;
			}
			
			if (x < -100 || x > 600 || y < -100 || y > 600) {
				side = !side;
				if (side == LEFT) {
					this.x = -99;
				} else {
					this.x = 599
				}
				this.y = (Math.random()*400-100);
				
				bossbody.rotation = FlowerBoss.getangle(this.x,this.y,g.testguy.x + g.testguy.width/2, g.testguy.y + g.testguy.height/2) + 90;
				
			}
			
			return die(g);
		}
		
		private function die(g):Boolean {
			//do manual 2 circle hitbox calculation to improve accuracy
			var calcdist:Number = Math.sqrt(Math.pow((this.x+hitbox.x)-(g.testguy.x+g.testguy.width/2),2) + Math.pow((this.y+hitbox.y)-(g.testguy.y+g.testguy.height/2),2));
			if (calcdist < (50+5)) {
				return guyhit(g);
			} else {
				return false;
			}
		}
		
		private function dieNoExplode(g:GameEngine) {
			if (deathanimcounter == 0) {
				deathanimcounter = 1;
				bossbody.rotation = 0;
				this.y -= 7;
				if (this.y < -50) {
					g.deathwall.splice(g.deathwall.indexOf(this),1);
					g.main.removeChild(this);
					this.activatecontroller.addShowAfter(g);
				}
			}
		}
		
		private function dieExplode(g:GameEngine) {
			for (var i = 0; i < 6; i++) {
				var particle:RocketParticle = new RocketParticle;
				var randSpd = Math.random()*10;
				particle.graphics.beginFill(0xcc6666);
				particle.graphics.drawCircle(0,0,3*Math.random());
				particle.alphaspd = 0.05;
				particle.x = this.x+(Math.random()*105)-50; 
				particle.y = this.y+(Math.random()*105)-50;
				particle.vx = Math.sin(i*(Math.PI/3))*randSpd;
				particle.vy = Math.cos(i*(Math.PI/3))*randSpd;
				g.particles.push(particle);
				g.main.addChild(particle);
			}
			if (deathanimcounter == 0) {
				for (var i = 0; i < 24; i++) {
					var particle:RocketParticle = new RocketParticle;
					var randSpd = Math.random()*10;
					particle.graphics.beginFill(0xcc6666);
					particle.graphics.drawCircle(0,0,7*Math.random());
					particle.alphaspd = 0.025;
					particle.x = this.x; particle.y = this.y;
					particle.vx = Math.sin(i*(Math.PI/12))*randSpd;
					particle.vy = Math.cos(i*(Math.PI/12))*randSpd;
					particle.ay = 0.25;
					g.particles.push(particle);
					g.main.addChild(particle);
				}
				g.deathwall.splice(g.deathwall.indexOf(this),1);
				g.main.removeChild(this);
				this.activatecontroller.addShowAfter(g);
			}
		}
		
		public function tempdeathanim(){ 
			deathanimcounter = 65;
		}
		
		public function hitByRocket() {
			flashtimer = 10;
			flashcount = 0;
			if (activatecontroller != null) {
				activatecontroller.hit();
			}
		}
		
		public function flashanimation() {
			if (flashtimer > 0) {
				flashtimer--;
				flashcount++;
				if (flashcount > 3) {
					flashcount = 0;
					flashstatus = !flashstatus;
				}
				if (flashstatus) {
					bodyimg.visible = false;
					bodyimg2.visible = true;
				} else {
					bodyimg.visible = true;
					bodyimg2.visible = false;
				}
			} else {
				bodyimg.visible = true;
				bodyimg2.visible = false;
			}
		}
		
		private function animateParticles(dx:Number, dy:Number, g:GameEngine) {
			if (doParticles) {
				dx = dx*5;
				dy = dy*5;
				var newp:RocketParticle = new RocketParticle();
				newp.x = this.x + (dx* -12);
				newp.y = this.y + (dy* -12);
				newp.vx = -dx+(Math.random()*6)-1.5;
				newp.vy = -dy+(Math.random()*6)-1.5;
				newp.ay = 0.75;
				newp.alphaspd = 0.05;
				newp.graphics.beginFill(0xcc6666);
				newp.graphics.drawCircle(0,0,Math.random()*4);
				
				g.particles.push(newp);
				g.main.addChild(newp);
			}
		}
		
		private function animatePropeller() {
			animtimer++;
			if (animtimer > 3) {
				animtimer = 0;
				if (rp1.visible) {
					rp1.visible = false; rp2.visible = true; rp3.visible = false;
				} else if (rp2.visible) {
					rp1.visible = false; rp2.visible = false; rp3.visible = true;
				} else if (rp3.visible) {
					rp1.visible = true; rp2.visible = false; rp3.visible = false;
				}
			}
		}
		
		public override function type():String {
			return "rocketboss";
		}
		
		[Embed(source='..//img//boss//rocketboss.png')]
		private var imgfstem:Class;
		private var bodyimg:Bitmap = (new imgfstem) as Bitmap;
		
				[Embed(source='..//img//boss//rocketboss2.png')]
		private var imgfstem2:Class;
		private var bodyimg2:Bitmap = (new imgfstem2) as Bitmap;
		
				[Embed(source='..//img//boss//rocketpropeller1.png')]
		private var rp1d:Class;
		private var rp1:Bitmap = (new rp1d) as Bitmap;
		
				[Embed(source='..//img//boss//rocketpropeller2.png')]
		private var rp2d:Class;
		private var rp2:Bitmap = (new rp2d) as Bitmap;
		
				[Embed(source='..//img//boss//rocketpropeller3.png')]
		private var rp3d:Class;
		private var rp3:Bitmap = (new rp3d) as Bitmap;
		
	}
	
}
