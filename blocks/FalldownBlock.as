package blocks {
		import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class FalldownBlock extends BaseBlock {
		//red block of death, also known as deathwall
		//I have no idea where the name FalldownBlock came from (must be something from original jump or die)

		public function FalldownBlock(x:Number,y:Number,w:Number,h:Number, noedge:Boolean = false) {
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

			graphics.beginBitmapFill(makeBitmap(redblock));
			graphics.drawRect(0, 0, w,h);
			graphics.endFill(); 
			
			if (noedge) {
				return;
			}
			
			var topRepeatContainer:Sprite = new Sprite;
			topRepeatContainer.y = -9;
			topRepeatContainer.graphics.beginBitmapFill(getTransparent(top));
			topRepeatContainer.graphics.drawRect(0,0,w,9);
			topRepeatContainer.graphics.endFill();
			addChild(topRepeatContainer);
			
			var leftRepeatContainer:Sprite = new Sprite;
			leftRepeatContainer.x = -11;
			leftRepeatContainer.graphics.beginBitmapFill(getTransparent(left));
			leftRepeatContainer.graphics.drawRect(0,0,11,h);
			leftRepeatContainer.graphics.endFill();
			addChild(leftRepeatContainer);
			
			var bottomRepeatContainer:Sprite = new Sprite;
			bottomRepeatContainer.graphics.beginBitmapFill(getTransparent(bottom));
			bottomRepeatContainer.graphics.drawRect(0,0,w,10);
			bottomRepeatContainer.y = h;
			bottomRepeatContainer.graphics.endFill();
			addChild(bottomRepeatContainer);
			
			var rightRepeatContainer:Sprite = new Sprite;
			rightRepeatContainer.graphics.beginBitmapFill(getTransparent(right));
			rightRepeatContainer.graphics.drawRect(0,0,8,h);
			rightRepeatContainer.x = w;
			rightRepeatContainer.graphics.endFill();
			addChild(rightRepeatContainer);
		}
		
						[Embed(source='..//img//block//redblock.png')]
		private var tl:Class;
		private var redblock:Bitmap = new tl();
		
		[Embed(source='..//img//block//red//top.png')]
		private var top:Class;
		
		[Embed(source='..//img//block//red//left.png')]
		private var left:Class;
		
		[Embed(source='..//img//block//red//bottom.png')]
		private var bottom:Class;
		
				[Embed(source='..//img//block//red//right.png')]
		private var right:Class;
		
		public override function type():String {
			return "deathwall";
		}
		
		public override function update(g:GameEngine):Boolean {
			if (this.stage != null) {
				g.main.setChildIndex(this,g.main.numChildren-1);
			}
			
			if (g.testguy.hitTestObject(this)) {
				return guyhit(g);
			}
			return false;
		}
		
		public function guyhit(g:GameEngine):Boolean {
			if (!g.main.mute) { g.main.explodesound.play(); }
			g.timer.stop();
			g.testguy.explode();
			g.timer = new Timer(1200,1);
			g.timer.start();
			g.timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(){g.reload();});
			return true;
		}
		
	}
	
}
