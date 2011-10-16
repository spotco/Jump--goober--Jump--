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
		public var ok:Sprite;
		public var no:Sprite;
		public var currentfunction:CurrentFunction;
		public var gamefont:TextFormat;
		
		//default for message, text entry box and confirmation button
		public function TextWindow(questiontext:String,currentfunction:CurrentFunction,nfunction:Function) {
			gamefont = JumpDieCreateMain.getTextFormat(13);
			
			makewindow(questiontext);
			
			entryfield = new TextField();
			entryfield.embedFonts = true; entryfield.antiAliasType = AntiAliasType.ADVANCED;
			entryfield.x = 150; entryfield.y = 284;entryfield.width=150;entryfield.height=20;
			entryfield.border = true;entryfield.type = "input";entryfield.text = "";
			entryfield.defaultTextFormat = gamefont;entryfield.setTextFormat(gamefont);
			addChild(entryfield);
			
			ok = new Sprite();
			ok.x = 310; ok.y = 276;
			ok.addChild(okbutton);
			ok.addEventListener(MouseEvent.CLICK,nfunction);
			addChild(ok);
		}
		
		//question message with yes and no button
		public function yesnobox(questiontext:String, yes:Function, no: Function) {
			clear();
			makewindow(questiontext);
			
			ok = new Sprite();
			ok.x = 166; ok.y = 293;
			ok.addChild(yesbutton);
			ok.addEventListener(MouseEvent.CLICK,yes);
			addChild(ok);
			
			this.no = new Sprite();
			this.no.x = 260; this.no.y = 293;
			this.no.addChild(nobutton);
			this.no.addEventListener(MouseEvent.CLICK,no);
			addChild(this.no);
		}
		
		//message with ok
		public function okbox(questiontext:String,ok:Function) {
			clear();
			makewindow(questiontext);
			
			this.ok = new Sprite();
			this.ok.x = 220; this.ok.y = 293;
			this.ok.addChild(okbutton);
			this.ok.addEventListener(MouseEvent.CLICK,ok);
			addChild(this.ok);
		}
		
		//message with no interaction (leveleditor sending uses it)
		public function messagebox(questiontext:String) {
			clear();
			makewindow(questiontext);
		}
		
		private function clear() {
			graphics.clear();
			while(numChildren > 0) {
    			removeChildAt(0);
			}
		}
		
		private function makewindow(questiontext:String) {
			this.currentfunction = currentfunction;
			
			this.addChild(JumpDieCreateMenu.titlebg);
			this.addChild(JumpDieCreateMenu.getTextBubble());
			
			displaytext = new TextField();
			displaytext.embedFonts = true;displaytext.antiAliasType = AntiAliasType.ADVANCED;
			displaytext.x=140;displaytext.y=150;displaytext.wordWrap = true;
			displaytext.width=230;displaytext.height=400;
			displaytext.selectable=false;displaytext.text=questiontext;displaytext.setTextFormat(gamefont);
			addChild(displaytext);
		}
		
				[Embed(source='..//img//button//yes.png')]
		private var mb1:Class;
		private var yesbutton:Bitmap = new mb1;
		
				[Embed(source='..//img//button//no.png')]
		private var mb2:Class;
		private var nobutton:Bitmap = new mb2;
		
						[Embed(source='..//img//button//ok.png')]
		private var mb3:Class;
		private var okbutton:Bitmap = new mb3;

	}
	
}
