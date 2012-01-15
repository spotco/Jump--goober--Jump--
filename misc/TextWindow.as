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
	
	public class TextWindow extends Sprite {
		
		public var displaytext:TextField;
		public var entryfield:TextField;
		public var ok = new Sprite;
		public var currentfunction:CurrentFunction;
		public var gamefont:TextFormat;
		
		//default for message, text entry box and confirmation button
		public function TextWindow(questiontext:String,currentfunction:CurrentFunction,nfunction:Function,stop:Boolean = false) {
			if (stop) {
				return;
			}
			gamefont = JumpDieCreateMain.getTextFormat(13);
			
			makewindow(questiontext);
			
			entryfield = new TextField();
			entryfield.embedFonts = true; entryfield.antiAliasType = AntiAliasType.ADVANCED;
			entryfield.x = 150; entryfield.y = 284;entryfield.width=150;entryfield.height=20;
			entryfield.border = true;entryfield.type = "input";entryfield.text = "";
			entryfield.defaultTextFormat = gamefont;entryfield.setTextFormat(gamefont);
			addChild(entryfield);
			
			ok.x = 310; ok.y = 276;
			ok.addChild(okbutton);
			ok.addEventListener(MouseEvent.CLICK,nfunction);
			addChild(ok);
		}
		
		public function makewindow(questiontext:String) {
			this.currentfunction = currentfunction;
			this.addChild(JumpDieCreateMenu.titlebg);
			var b:Bitmap = JumpDieCreateMenu.getTextBubble();
			b.alpha = 0.7;
			this.addChild(b);
			
			displaytext = new TextField();
			displaytext.embedFonts = true;displaytext.antiAliasType = AntiAliasType.ADVANCED;
			displaytext.x=140;displaytext.y=150;displaytext.wordWrap = true;
			displaytext.width=230;displaytext.height=400;
			displaytext.selectable=false;displaytext.text=questiontext;displaytext.setTextFormat(gamefont);
			addChild(displaytext);
		}
		
				[Embed(source='..//img//button//yes.png')]
		public static var mb1:Class;
		public static var yesbutton:Bitmap = new mb1;
		
				[Embed(source='..//img//button//no.png')]
		public static var mb2:Class;
		public static var nobutton:Bitmap = new mb2;
		
						[Embed(source='..//img//button//ok.png')]
		public static var mb3:Class;
		public static var okbutton:Bitmap = new mb3;

	}
	
}
