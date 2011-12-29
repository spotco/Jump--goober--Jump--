package blocks {
		import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class LaserLauncher extends RocketLauncher {
		
		protected var laserSight:Sprite = new Sprite;
		protected var particletrail:Array = new Array;
		protected var rotspd:Number = 3;
		
		public function LaserLauncher(x:Number,y:Number,rotspd:Number) {
			super(x,y);
			laserSight.x = 19-75/2+18;
			laserSight.y = 32-68/2-9;
			launcherContainer.addChild(laserSight);
			this.rotspd = rotspd;
		}
		
		public override function update(g:GameEngine):Boolean {
			if (g.testguy.hitTestObject(this.hitbox)) {
				return guyhit(g);
			}
			launcherContainer.rotation+=rotspd;
			var searchDepth:Number = 8;
			var dy:Number = Math.cos(launcherContainer.rotation*(Math.PI/180))*searchDepth;
			var dx:Number = -Math.sin(launcherContainer.rotation*(Math.PI/180))*searchDepth;
			
			var cx:Number = this.x;
			var cy:Number = this.y;
			
			for each(var p:Particle in particletrail) {
				p.alpha-=0.2;
				if (p.alpha <= 0) {
					if (this.getChildIndex(p) != -1) {
						this.removeChild(p);
					}
					particletrail.splice(particletrail.indexOf(p),1);
				}
				
			}
			
			var newp:Particle = new Particle;
			this.addChild(newp);
			particletrail.push(newp);
			newp.graphics.beginFill(0xFF0000);
			
			outerLoop: while(Math.sqrt(Math.pow(cx-this.x,2)+Math.pow(cy-this.y,2))<300) {
				for each (var wall:Wall in g.walls) {
					if (g.testguy.hitTestPoint(cx,cy)) {
						return guyhit(g);
					}
					if (wall.hitbox.hitTestPoint(cx,cy)) {
						break outerLoop;
						break;
					}
				}
				newp.graphics.drawCircle(0-this.x+cx,0-this.y+cy,3*Math.random());
				cx+=dx;
				cy+=dy;
			}
			
			laserSight.graphics.clear();
			
			var dist:Number = Math.max(Math.sqrt(Math.pow(cx-this.x,2)+Math.pow(cy-this.y,2)));
			if (dist > 45) { 
				laserSight.graphics.lineStyle(4,0xFF0000);
				laserSight.graphics.lineTo(0,dist);
			}
			return false;
		}
		
		public override function type():String {
			return "laserlauncher";
		}
		
		
	}
	
}
