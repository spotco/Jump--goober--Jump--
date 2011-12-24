package blocks {
		import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class Rocket extends FalldownBlock {
		
		private var rocketBody:Sprite = new Sprite;
		private var speed:Number = 7;
		private var trailParticles:Array = new Array;
		private var flipimg:Sprite = new Sprite;
		private var hitbox:Sprite = new Sprite;
		
		public function Rocket(x:Number,y:Number,rotation:Number) {
			super(0,0,0,0);
			this.x = x;
			this.y = y;
			rocketBody.addChild(flipimg);
			flipimg.addChild(rocketimg);
			flipimg.x =  -.5*rocketBody.width;
			flipimg.y =  -.5*rocketBody.height;
			rocketimg.x =  -1*rocketBody.width;
			rocketimg.y =  -1*rocketBody.height;
			
			flipimg.rotation = 180;
			this.addChild(rocketBody);
			rocketBody.rotation = rotation;
			
			hitbox.graphics.beginFill(0x0000FF,0);
			hitbox.graphics.drawCircle(0,0,25/2);
			this.addChild(hitbox);
		}
		
		public override function update(g:GameEngine):Boolean {
			var dx:Number = -Math.sin(rocketBody.rotation*(Math.PI/180))*speed;
			var dy:Number = Math.cos(rocketBody.rotation*(Math.PI/180))*speed;
			this.x+=dx;
			this.y+=dy;
			
			var tarAngle:Number = RocketLauncher.getTarAngle(this.x,this.y,g);
			rocketBody.rotation += RocketLauncher.rotDir(rocketBody.rotation,tarAngle)*3;
			
			if (this.x < -20 || this.x > 520 || this.y < -20 || this.y > 590) {
				g.main.removeChild(this);
				g.deathwall.splice(g.deathwall.indexOf(this),1);
				return;
			}
			
			if (this.hitbox.hitTestObject(g.testguy)) {
				return guyhit(g);
			}
			for each(var w:Wall in g.walls) {
				if (this.hitbox.hitTestObject(w.hitbox)) {
					for (var i = 0; i < 24; i++) {
						var particle:RocketParticle = new RocketParticle;
						var randSpd = Math.random()*10;
						particle.graphics.beginFill(0xFF0000);
						particle.graphics.drawCircle(0,0,3*Math.random());
						particle.alphaspd = 0.05;
						particle.x = this.x; particle.y = this.y;
						particle.vx = Math.sin(i*(Math.PI/12))*randSpd;
						particle.vy = Math.cos(i*(Math.PI/12))*randSpd;
						particle.ay = 0.5;
						g.particles.push(particle);
						g.main.addChild(particle);
					}
					g.main.removeChild(this);
					g.deathwall.splice(g.deathwall.indexOf(this),1);
					return;
					
				}
			}
			
			var newp:RocketParticle = new RocketParticle();
			newp.x = this.x;
			newp.y = this.y;
			newp.vx = -dx+(Math.random()*3)-1.5;
			newp.vy = -dy+(Math.random()*3)-1.5;
			newp.graphics.beginFill(0xFF0000);
			newp.graphics.drawCircle(0,0,Math.random()*4);
			
			g.particles.push(newp);
			g.main.addChild(newp);
		}
		
		
		public override function type():String {
			return "rocket";
		}
		
		[Embed(source='..//img//block//red//rocket.png')]
		public var rdata:Class;
		private var rocketimg:Bitmap = (new rdata) as Bitmap;
		
		
		
	}
	
}
