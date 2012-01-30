package misc {
	import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
		import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class MenuOption extends Sprite {
		
		public var guycursor:Guy;
		public var guycursorX:Number;
		public var guycursorY:Number;
		public var menuoption:Number;
		
		var menu:JumpDieCreateMenu;
		
		public function MenuOption(x:Number,y:Number,img:Bitmap,menuoption:Number) {
			img.x = -(img.width/2);
			img.y = -(img.height/2);
			addChild(img);
			guycursorX = img.x - 30;
			guycursorY = img.y - 4;
			this.menuoption = menuoption;
			this.x = x;
			this.y = y;
		}
		
		public function addEvents(menu:JumpDieCreateMenu) {
			this.menu = menu;
			var tmpref:MenuOption = this;
			this.addEventListener(MouseEvent.ROLL_OVER, onmouseover);
			this.addEventListener(MouseEvent.CLICK, onclick);
		}
		
		public function onmouseover(e:MouseEvent) {
			menu.menupos = menu.use_menu.indexOf(this);
			menu.updateCursor();
		}
		
		public function onclick(e:MouseEvent) {
			menu.activate();
		}
		
		public function removeEvents() {
			this.removeEventListener(MouseEvent.MOUSE_OVER, onmouseover);
			this.removeEventListener(MouseEvent.CLICK, onclick);
		}
		
	}
	
}
