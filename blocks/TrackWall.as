package blocks  {
	import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class TrackWall extends Wall {
		
		public var direction:Boolean;
		public var start:Number;
		public var end:Number;
		public var hasFoundDirection:Boolean;
		
		public var directiontoggle:Boolean = false; //t left up, f right down
		public var speed:Number = 0;
		
		public var frictionbox:Sprite = new Sprite;
		
		public function TrackWall(x:Number,y:Number,w:Number,h:Number) {
			super(x,y,w,h,true);
			hitbox.graphics.clear();
			hitbox.graphics.beginFill(0x57769c);
			hitbox.graphics.drawRect(0,0,this.w,this.h);
			
			frictionbox.graphics.beginFill(0x000000,0);
			//frictionbox.graphics.drawRect(0,-1,this.w,this.h);
			
			frictionbox.graphics.drawRect(0,-1,this.w,this.h/2);
			
			//frictionbox.graphics.drawRect(0,-3,this.w,this.h);
			this.addChild(frictionbox);
			
			makebolts();
			hasFoundDirection = false;
		}
		
		private function makebolts() {
			ltbolt.x = 1; ltbolt.y = 1;
			rtbolt.x = w-8; rtbolt.y = 2;
			lbbolt.x = 1; lbbolt.y = h-8;
			rbbolt.x = w-8; rbbolt.y = h-8;
			addChild(ltbolt);
			addChild(rtbolt);
			addChild(lbbolt);
			addChild(rbbolt);
		}

		public override function update(g:GameEngine):Boolean {
			if (this.stage != null) {
				g.main.setChildIndex(this,g.main.numChildren-1);
			}
			
			if (!hasFoundDirection) {
				hasFoundDirection = true;
				findTrack(g);
			}
			if (speed == 0) {
				return false;
			}
			if (this.direction == Track.VERT) {
				
				if (directiontoggle) { //up
					this.y-=this.speed;
					if (this.y-g.currenty+this.h/2 < Math.min(this.start,this.end)) {
						directiontoggle = !directiontoggle;
					}
					if (this.hitbox.hitTestObject(g.testguy)) { 
						g.testguy.y-=this.speed;
						//may need to check for up/down cases, but it seems like this works
						while(this.hitbox.hitTestObject(g.testguy)) { //for non-standard sizes, keep moving until out (rounding error?)
							g.testguy.y-=0.1;
						}
						return checkSmash(g);
					}
				} else { //down
					var hitfriction:Boolean = false;
					if (this.frictionbox.hitTestObject(g.testguy)) { //if guy is right above the block pulldown and remember to do extra check
						g.testguy.y+=this.speed;
						
						hitfriction = true;
						
					}
					this.y+=this.speed;
					if (hitfriction) { //push for above
						while(this.hitbox.hitTestObject(g.testguy) && g.testguy.y < this.y) {
							g.testguy.y-=0.1;
						}
						for each (var b:Wall in g.walls) { //for frictionbox drag down into another wall
							while (g.testguy.hitTestObject(b.hitbox)) {
								g.testguy.y-=0.1;
							}
						}
					}
					while (this.hitbox.hitTestObject(g.testguy) && g.testguy.y > this.y) { //push for below
						g.testguy.y+=0.1;
					}
					
					if (this.y-g.currenty+this.h/2 > Math.max(this.start,this.end)) {
						directiontoggle = !directiontoggle;
					}
					return checkSmash(g);
				}
				
				
			} else if (this.direction == Track.HORIZ) {
				
				if (directiontoggle) { //left
					this.x-=this.speed;
					if (this.x+this.w/2 < Math.min(this.start,this.end)) {
						directiontoggle = !directiontoggle;
					}
					if (this.hitbox.hitTestObject(g.testguy)) {
						g.testguy.x-=this.speed;
						while(this.hitbox.hitTestObject(g.testguy)) {
							g.testguy.x-=0.1;
						}
						return checkSmash(g);
					}
					if (this.frictionbox.hitTestObject(g.testguy)) {
						g.testguy.x-=this.speed;
						if (guyhitting(g)) {
							g.testguy.x+=this.speed;
						}
					}
					
				} else { //right
					this.x+=this.speed;
					if (this.x+this.w/2 > Math.max(this.start,this.end)) {
						directiontoggle = !directiontoggle;
					}
					if (this.hitbox.hitTestObject(g.testguy)) {
						g.testguy.x+=this.speed;
						while(this.hitbox.hitTestObject(g.testguy)) {
							g.testguy.x+=0.1;
						}
						return checkSmash(g);
					}
					if (this.frictionbox.hitTestObject(g.testguy)) {
						g.testguy.x+=this.speed;
						if (guyhitting(g)) {
							g.testguy.x-=this.speed;
						}
					}
				}
				
			}
			return false;
		}
		
		public override function simpleupdate(g:GameEngine) {
			if (!hasFoundDirection) {
				hasFoundDirection = true;
				findTrack(g);
			}
			if (speed == 0) {
				return false;
			}
			if (this.direction == Track.VERT) {
				if (directiontoggle) { //up
					this.y-=this.speed;
					if (this.y-g.currenty+this.h/2 < Math.min(this.start,this.end)) {
						directiontoggle = !directiontoggle;
					}
				} else { //down
					this.y+=this.speed;
					if (this.y-g.currenty+this.h/2 > Math.max(this.start,this.end)) {
						directiontoggle = !directiontoggle;
					}
				}
			} else if (this.direction == Track.HORIZ) {
				if (directiontoggle) { //left
					this.x-=this.speed;
					if (this.x+this.w/2 < Math.min(this.start,this.end)) {
						directiontoggle = !directiontoggle;
					}
				} else { //right
					this.x+=this.speed;
					if (this.x+this.w/2 > Math.max(this.start,this.end)) {
						directiontoggle = !directiontoggle;
					}
				}
			}
		}
		
		private function guyhitting(g:GameEngine):Boolean {
			for each (var w:Wall in g.walls) {
				if (w != this && g.testguy.hitTestObject(w.hitbox)) {
					return true;
				}
			}
			return false;
		}
		
		private function checkSmash(g:GameEngine):Boolean {
			for each(var w:Wall in g.walls) {
				if (w.hitbox.hitTestObject(g.testguy)) {
					return FalldownBlock.guyhit(g);
				}
			}
			return false;
			
		}
		
		private function findTrack(g:GameEngine) {
			for each(var t:Track in g.tracks) {
				if (this.hitbox.hitTestObject(t)) {
					this.direction = t.direction;
					this.start = t.start;
					this.end = t.end;
					speed+=3;
				}
			}
		}
		
		[Embed(source='..//img//block//blue//trackbolt.png')]
		private var bolt:Class;
		private var ltbolt:Bitmap = (new bolt) as Bitmap;
		private var rtbolt:Bitmap = (new bolt) as Bitmap;
		private var lbbolt:Bitmap = (new bolt) as Bitmap;
		private var rbbolt:Bitmap = (new bolt) as Bitmap;
		
		public override function type():String {
			return "trackwall";
		}
	}
	
}
