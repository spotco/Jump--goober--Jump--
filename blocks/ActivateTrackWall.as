package blocks  {
	import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class ActivateTrackWall extends TrackWall {
		
		public function ActivateTrackWall(x:Number,y:Number,w:Number,h:Number) {
			super(x,y,w,h);
		}
		
		public override function update(g:GameEngine) {
			//set speed to 0
			//hit frictionbox, set speed to variable??? 
		}
		
		public override function type():String {
			return "activatetrackwall";
		}
	}
	
}
