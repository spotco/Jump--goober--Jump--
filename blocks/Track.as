package blocks {
		import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import flash.text.TextField;
    import flash.text.TextFormat;
	import flash.display.BitmapData;
	import flash.text.AntiAliasType;
    import flash.utils.Timer;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class Track extends BaseBlock {
		
		//t horiz, f vertical
		public var direction:Boolean;
		public static var HORIZ:Boolean = true;
		public static var VERT:Boolean = false;
		
		public var start:Number;
		public var end:Number;
		
		
		public function Track(x:Number,y:Number,w:Number,h:Number) {
			graphics.beginFill(0x5f95b1);
			
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
			
			if (w > h) {
				
				direction = true;
				etrackball.x = w;
				for(var i = 0; i < (w-11)/10; i++) {
					graphics.drawRect((i*10)+11,5,6,2);
				}
				this.start = x;
				this.end = x+w;
				
			} else {
				
				direction = false;
				etrackball.y = h;
				for (var i = 0; i < (h-11)/10; i++) {
					graphics.drawRect(4,(i*10)+11,2,6);
				}
				this.start = y;
				this.end = y+h;
				
			}
			
			
			
			addChild(strackball);
			addChild(etrackball);
		}
		
		public override function type():String {
			return "track";
		}
		
		/*public override function update(g:GameEngine):Boolean {
			if (this.stage != null) {
				g.main.setChildIndex(this,g.main.numChildren-1);
			}
		}*/
		
		[Embed(source='..//img//block//track//trackball.png')]
		private var t0:Class;
		private var strackball:Bitmap = new t0;
		private var etrackball:Bitmap = new t0;
	}
}
