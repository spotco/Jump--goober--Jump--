package blocks {
	import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class Goal extends BaseBlock {
		
		public var mainfillcontainer:Sprite;
		public var animationcounter:Number;
		public var animationphase:Number;

		public function Goal(x:Number,y:Number,w:Number,h:Number, noEdge:Boolean = false) {
			//green blob of guys, the goal for ingame
			animationcounter = 0;
			animationphase = 0;
			if (w < 0) {
				x += w;
				w = -w;
			}
			if (h < 0) {
				y += h;
				h = -h;
			}
			this.x = x;
			this.y = y;
			this.w = w;
			this.h = h;
			
			mainfillcontainer = new Sprite;
			mainfillcontainer.graphics.beginBitmapFill(makeBitmap(yellowblock));
			mainfillcontainer.graphics.drawRect(0, 0, w,h);
			mainfillcontainer.graphics.endFill();
			addChild(mainfillcontainer);
			
			if (noEdge) {
				return;
			}
			
			graphics.beginBitmapFill(getTransparent(top));
			//graphics.drawRect(0,-17,w,17);
			graphics.drawRect(0,-16,w,16);
			graphics.endFill();
			
			graphics.beginBitmapFill(getTransparent(left));
			//graphics.drawRect(-17,0,17,h);
			graphics.drawRect(-16,0,16,h);
			graphics.endFill();
			
			var bottomRepeatContainer:Sprite = new Sprite;
			bottomRepeatContainer.graphics.beginBitmapFill(getTransparent(bottom));
			//bottomRepeatContainer.graphics.drawRect(0,0,w,15);
			bottomRepeatContainer.graphics.drawRect(0,0,w,14);
			bottomRepeatContainer.y = h;
			bottomRepeatContainer.graphics.endFill();
			addChild(bottomRepeatContainer);
			
			var rightRepeatContainer:Sprite = new Sprite;
			rightRepeatContainer.graphics.beginBitmapFill(getTransparent(right));
			rightRepeatContainer.graphics.drawRect(0,0,17,h);
			rightRepeatContainer.x = w;
			rightRepeatContainer.graphics.endFill();
			addChild(rightRepeatContainer);
			
			
		}
		[Embed(source='..//img//block//greenblock.png')]
		private var tl:Class;
		private var yellowblock:Bitmap = new tl();
		
				[Embed(source='..//img//block//greenblock2.png')]
		private var t2:Class;
		private var yellowblock2:Bitmap = new t2();
		
		[Embed(source='..//img//block//green//top.png')]
		private var top:Class;
		
		[Embed(source='..//img//block//green//left.png')]
		private var left:Class;
		
		[Embed(source='..//img//block//green//bottom.png')]
		private var bottom:Class;
		
				[Embed(source='..//img//block//green//right.png')]
		private var right:Class;

		
		public override function update(g:GameEngine):Boolean {
			this.animate(g);
			if (g.testguy.hitTestObject(this)) {
				g.timer.stop();
				g.loadnextlevel(true); //HIT GOAL EXIT
				return true;
			}
			return false;
		}
		
		public function animate(g:GameEngine):Boolean {
			animationcounter++;
			if (animationcounter > 15) {
				animationcounter = 0;
				removeChild(mainfillcontainer);
				mainfillcontainer = new Sprite;
				if (animationphase == 0) { 
					animationphase++;
					mainfillcontainer.graphics.beginBitmapFill(makeBitmap(yellowblock));
				} else if (animationphase == 1) {
					animationphase = 0;
					mainfillcontainer.graphics.beginBitmapFill(makeBitmap(yellowblock2));
				}
				mainfillcontainer.graphics.drawRect(0, 0, w,h);
				mainfillcontainer.graphics.endFill();
				addChild(mainfillcontainer);
			}
			return false;
		}
		
		public override function type():String {
			return "goal";
		}
	}
	
}
