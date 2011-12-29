package blocks  {
	import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class ActivateTrackWall extends TrackWall {
		
		private var animframe1:Sprite = new Sprite;
		private var animframe2:Sprite = new Sprite;
		
		private var lefthitbox:Sprite = new Sprite;
		private var righthitbox:Sprite = new Sprite;
		
		private var isactive:Boolean = false;
		private var animcounter:Number = 0;
		
		
		public function ActivateTrackWall(x:Number,y:Number,w:Number,h:Number) {
			super(x,y,w,h);
			
			animframe1.graphics.beginBitmapFill(makeBitmap(bgf1));
			animframe2.graphics.beginBitmapFill(makeBitmap(bgf2));
			animframe1.graphics.drawRect(0,0,this.w,this.h);
			animframe2.graphics.drawRect(0,0,this.w,this.h);
			animframe2.visible = false;
			this.addChild(animframe1);
			this.addChild(animframe2);
			
			lefthitbox.graphics.beginFill(0x000000,0);
			lefthitbox.graphics.drawRect(-1,0,this.w,this.h);
			this.addChild(lefthitbox);
			
			righthitbox.graphics.beginFill(0x000000,0);
			righthitbox.graphics.drawRect(1,0,this.w,this.h);
			this.addChild(righthitbox);
			
			this.direction = Track.VERT;
			this.speed = 0;
			this.hasFoundDirection = true;
			this.directiontoggle = true;
		}
		
		public override function update(g:GameEngine):Boolean {
			if (g.testguy.hitTestObject(this.frictionbox)) {
				this.direction = Track.VERT;
				this.directiontoggle = true;
				this.speed = 3;
				isactive = true;
			} else if (g.testguy.hitTestObject(this.lefthitbox)) {
				this.direction = Track.HORIZ;
				this.directiontoggle = true;
				this.speed = 3;
				isactive = true;
			} else if (g.testguy.hitTestObject(this.righthitbox)) {
				this.direction = Track.HORIZ;
				this.directiontoggle = false;
				this.speed = 3;
				isactive = true;
			} else {
				this.speed = 0;
				isactive = false;
			}

			if (isactive) {
				animcounter++;
				if (animcounter > 10) {
					animcounter = 0;
					if (animframe1.visible) {
						animframe1.visible = false;
						animframe2.visible = true;
					} else {
						animframe1.visible = true;
						animframe2.visible = false;
					}
				}
			}
			return super.update(g);
		}
		
		public override function type():String {
			return "activatetrackwall";
		}
		
		[Embed(source='..//img//block//blue//mech1.png')]
		private var bgf1dat:Class;
		public var bgf1:Bitmap = new bgf1dat();
		
		[Embed(source='..//img//block//blue//mech2.png')]
		private var bgf2dat:Class;
		public var bgf2:Bitmap = new bgf2dat();
		
		
		
	}
	
}
