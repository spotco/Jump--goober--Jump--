package blocks  {
	import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class Wall extends BaseBlock {
		//the blue block wall with detail on top
		public var hitbox:Sprite;
		var frame:Sprite = new Sprite;
		
		public function Wall(x:Number,y:Number,w:Number,h:Number,nodetails:Boolean = false) {
			if (w < 0) {
				x += w;
				w = -w;
			}
			if (h < 0) {
				y += h;
				h = -h;
			}
			
			hitbox = new Sprite;
			if (h > 58) {
				hitbox.graphics.beginBitmapFill(makeBitmap(blocktall));
			} else {
				hitbox.graphics.beginBitmapFill(makeBitmap(block));
			}
			this.x = x;
			this.y = y;
			this.w = w;
			this.h = h;
			hitbox.graphics.drawRect(0, 0, w,h);
			hitbox.graphics.endFill(); 
			addChild(hitbox);
			
			if (nodetails) {
				return;
			}
			var test:Sprite = new Sprite;
			test.graphics.beginBitmapFill(getTransparent(top));
			test.graphics.drawRect(0,-32,w,32);
			test.graphics.endFill();
			addChild(test);
			
			/*frame.graphics.lineStyle(1,0x7788BB);
			frame.graphics.lineTo(this.w,0);
			frame.graphics.lineTo(this.w,this.h);
			frame.graphics.lineTo(0,this.h);
			frame.graphics.lineTo(0,0);
			addChild(frame);*/
		}
		
				[Embed(source='..//img//block//blueblock.png')]
		public var tl:Class;
		public var block:Bitmap = new tl();
		
						[Embed(source='..//img//block//blueblocktall.png')]
		public var t2:Class;
		public var blocktall:Bitmap = new t2();
		
		[Embed(source='..//img//block//blue//top.png')]
		public var top:Class;
		
		public override function type():String {
			return "wall";
		}
		
		public function whitemode(x:Number,y:Number,w:Number,h:Number) {
			graphics.clear();
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(x, y, w,h);
			graphics.endFill(); 
		}

	}
	
}
