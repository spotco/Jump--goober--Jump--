package blocks  {
	import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	import fl.motion.easing.Back;
	
	public class ActivateTrackWall extends TrackWall {
		
		
		public function ActivateTrackWall(x:Number,y:Number,w:Number,h:Number) {
			super(x,y,w,h);
			this.direction = Track.VERT;
			this.speed = 0;
			this.hasFoundDirection = true;
			this.directiontoggle = true;
		}
		
		public override function update(g:GameEngine):Boolean {
			if (this.speed == 0 && g.testguy.hitTestObject(this.frictionbox)) {
				this.speed = 3;
			}
			return super.update(g);
		}
		
		public override function type():String {
			return "activatetrackwall";
		}
	}
	
}
