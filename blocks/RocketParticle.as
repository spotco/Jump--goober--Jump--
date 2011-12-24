package blocks {
	import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
		import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class RocketParticle extends FalldownBlock {
		
		public var vx:Number;
		public var vy:Number;
		public var ax:Number = 0;
		public var ay:Number = 0;
		public var alphaspd:Number = 0.1;
		
		public static var num:Number = 0;
		
		public function RocketParticle(gravity:Boolean = false) {
			super(0,0,0,0);
			num++;
		}
		
		public override function update(g:GameEngine):Boolean {
			this.x += this.vx;
			this.y += this.vy;
			this.alpha-=alphaspd;
			if (this.alpha <= 0.1 ) {
				if (this.stage != null) {
					g.main.removeChild(this);
				}
				g.particles.splice(g.particles.indexOf(this),1);
				
			}
			this.vy+=ax;
			this.vy+=ay;
		}
		
		public override function type():String {
			return "rocketparticle";
		}
		
	}
	
}
