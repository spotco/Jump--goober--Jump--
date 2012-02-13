package blocks  {
	import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	import flash.media.SoundTransform;
	
	public class TrackBlade extends FalldownBlock {
		
		public var direction:Boolean;
		public var start:Number;
		public var end:Number;
		public var hasFoundDirection:Boolean = false;
		
		public var hitbox:Sprite = new Sprite;
		
		public var directiontoggle:Boolean = false; //t left up, f right down
		public var speed:Number = 0;
		
		var wrapper:Sprite = new Sprite;
		
		public function TrackBlade(x:Number,y:Number) {
			super(0,0,0,0);
			graphics.clear();
			this.x = x; this.y = y;
			this.w = 50; this.h = 55;
			wrapper.addChild(blade);
			blade.x = -.5*wrapper.width;
			blade.y = -.5*wrapper.height;
			addChild(wrapper);
			hitbox.graphics.beginFill(0x000000,0);
			hitbox.graphics.drawCircle(0,0,22);
			addChild(hitbox);
		}
		
		public override function update(g:GameEngine):Boolean {
			return rupdate(g,false);
		}
		
		private function rupdate(g:GameEngine,simple:Boolean):Boolean {
			if (!simple) {
				wrapper.rotation+=8;
			}
			if (this.stage != null) {
				g.main.setChildIndex(this,g.main.numChildren-1);
			}
			
			if (!hasFoundDirection) {
				hasFoundDirection = true;
				findTrack(g);
			}
			if (this.direction == Track.VERT && speed != 0) {
				
				if (directiontoggle) { //up
					this.y-=this.speed;
					if (this.y-g.currenty < Math.min(this.start,this.end)) {
						directiontoggle = !directiontoggle;
					}
				} else { //down
					this.y+=this.speed;
					if (this.y-g.currenty > Math.max(this.start,this.end)) {
						directiontoggle = !directiontoggle;
					}
				}
				
				
			} else if (this.direction == Track.HORIZ && speed != 0) {
				
				if (directiontoggle) { //left
					this.x-=this.speed;
					if (this.x < Math.min(this.start,this.end)) {
						directiontoggle = !directiontoggle;
					}
					
				} else { //right
					this.x+=this.speed;
					if (this.x > Math.max(this.start,this.end)) {
						directiontoggle = !directiontoggle;
					}
				}
				
			}
			if (!simple && hitbox.hitTestObject(g.testguy.innerhitbox)) {
				/*g.main.playsfx(JumpDieCreateMain.explodesound);
				g.timer.stop();
				g.testguy.explode();
				g.timer = new Timer(1200,1);
				g.timer.start();
				g.timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(){g.reload();});
				return true;*/
				return guyhit(g);
			}
			
			return false;
		}
		
		public override function simpleupdate(g:GameEngine) {
			rupdate(g,true);
		}
		
		private function findTrack(g:GameEngine) {
			for each(var t:Track in g.tracks) {
				if (this.hitTestObject(t)) {
					this.direction = t.direction;
					this.start = t.start;
					this.end = t.end;
					speed+=3;
				}
			}
		}
		
		public override function type():String {
			return "trackblade";
		}
		
		[Embed(source='..//img//block//red//trackblade.png')]
		private var bladeimg:Class;
		private var blade:Bitmap = (new bladeimg) as Bitmap;
		
	}
	
}
