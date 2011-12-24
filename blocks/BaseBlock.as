package blocks  {
	import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class BaseBlock extends Sprite {
		//inheritance base for all class that are interactable in-game
		public var w:Number;
		public var h:Number;
		public var memRemoved:Boolean = false;
		
		public function getTransparent(tar:Class):BitmapData {
			var test:Bitmap = new Bitmap(new BitmapData(1,1,true));
			return test.bitmapData = (new tar as Bitmap).bitmapData;
		}
		
		public function makeBitmap(myDO:DisplayObject):BitmapData {
    		var myBD:BitmapData = new BitmapData(myDO.width, myDO.height);
    		myBD.draw(myDO);
    		return myBD;
		}
		
		public function type():String {
			return null;
		}
		
		public function internaltext():String {
			return "";
		}
		
		public function update(g:GameEngine):Boolean {
			return false;			
		}
		
		public function gameScroll(scroll_spd:Number) {
			this.y += scroll_spd;
		}
	}
	
}
