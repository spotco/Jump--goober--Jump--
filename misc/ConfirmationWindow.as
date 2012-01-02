package misc {
	import flash.display.*;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
	import flash.text.TextFieldType;
    import flash.geom.Rectangle;
	import flash.net.*;
	import flash.xml.*;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
		import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class ConfirmationWindow extends TextWindow {
		
		public var yes:Sprite = new Sprite;
		public var no:Sprite = new Sprite;

		public function ConfirmationWindow(questiontext:String,currentfunction:CurrentFunction,yfunction:Function,nfunction:Function) {
			super("",currentfunction,function(){},true);
			
			gamefont = JumpDieCreateMain.getTextFormat(13);
			
			makewindow(questiontext);
			
			yes.x = 180; yes.y = 276;
			yes.addChild(yesbutton);
			yes.addEventListener(MouseEvent.CLICK,yfunction);
			addChild(yes);
			
			no.x = 270; no.y = 276;
			no.addChild(nobutton);
			no.addEventListener(MouseEvent.CLICK,nfunction);
			addChild(no);
		}

	}
	
}
