package currentfunction {
	import flash.display.*;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.text.*;
    import flash.geom.Rectangle;
	import flash.net.*;
	import flash.xml.*;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.net.*;
	import flash.xml.*;
	import flash.media.Sound;
		import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	
	public class JumpDieCreateMenu extends CurrentFunction {
		private var main:JumpDieCreateMain;
		private var menubuttonwrapper:Sprite = new Sprite;
		private var mutebutton;
		
		public var menupos:Number;
		//private var cursor:Guy;
		
		public var use_menu:Array;
		
		private var main_menu:Array;
		private var world_menu:Array;
		private var online_menu:Array;
		
		private var desc:Object = new Object();
		
		public function JumpDieCreateMenu(main:JumpDieCreateMain) {
			initdesc();
			initmenu();
			this.main = main;
			sound = (new MySound) as Sound;
			menupos = 0;
			main.playSpecific(JumpDieCreateMain.MENU_MUSIC);
			titlelogo.x = 70; titlelogo.y = 17;
			main.addChild(titlebg);
			main.addChild(titlelogo);
			main.addChild(menubuttonwrapper);
			use_menu = main_menu;
			loadOptions();
			updateCursor();
			
			//make keypress
			main.cstage.addEventListener(KeyboardEvent.KEY_UP,keyPressed);
			main.cstage.focus = main.cstage;
			makemutebutton();
		}
		
		public function activate() {
			if (use_menu[menupos].menuoption > 0) {
				main.menuStart(use_menu[menupos].menuoption);
			} else if (use_menu[menupos].menuoption < 0) {
				swapMenu(use_menu[menupos].menuoption);
			} else {
				trace("feature not implemented!");
			}
		}
		
		public function swapMenu(n:Number) {
			menupos = 0;
			if (n == ADVENTURE) {
				trace("using adventure");
				use_menu = world_menu;
			} else if (n == BACK_TO_MAIN) {
				trace("using main");
				use_menu = main_menu;
			} else if (n == ONLINE) {
				trace("using online");
				use_menu = online_menu;
			}
			loadOptions();
			updateCursor();
		}
		
		public function loadOptions() {
			while(menubuttonwrapper.numChildren > 0) {
				(menubuttonwrapper.getChildAt(0) as MenuOption).removeEvents();
				menubuttonwrapper.removeChildAt(0);
			}
			for (var i = 0; i < use_menu.length; i++) {
				use_menu[i].addEvents(this);
				menubuttonwrapper.addChild(use_menu[i]);
			}
		}
		
		public function makemutebutton() {
			mutebutton = new Sprite();
			changemutebuttonicon();
			mutebutton.addEventListener(MouseEvent.CLICK, function(){
										main.stop();
										main.mute = !main.mute; 
										changemutebuttonicon();
										if (!main.mute) {
											main.playSpecific(JumpDieCreateMain.MENU_MUSIC);
										}
										});
			main.addChild(mutebutton);
		}
		
		public function changemutebuttonicon() {
			while(mutebutton.numChildren > 0) {
    			mutebutton.removeChildAt(0);
			}
			if (main.mute) {
				mutebutton.addChild(muteon);
			} else {
				mutebutton.addChild(muteoff);
			}
		}
		
		public function keyPressed(e:KeyboardEvent) {
			if (e.keyCode == Keyboard.DOWN/* && menupos < use_menu.length-1*/) {
				menupos++;
				if (menupos >= this.use_menu.length) {
					menupos = 0;
				}
				updateCursor();
			} else if (e.keyCode == Keyboard.UP/* && menupos > 0*/) {
				menupos--;
				if (menupos < 0) {
					menupos = this.use_menu.length - 1;
				}
				updateCursor();
			} else if (e.keyCode == Keyboard.SPACE) {
				activate();
			}
		}
		
		public function updateCursor() {
			var oldpos:Number = -1;
			for each(var o:MenuOption in use_menu) {
				if (o.guycursor != null) {
					oldpos = use_menu.indexOf(o);
					o.removeChild(o.guycursor);
					o.guycursor = null;
				}
			}
			if (!main.mute && oldpos != -1 && oldpos != menupos) {
				sound.play(0,1);
			}
			use_menu[menupos].guycursor = new Guy(use_menu[menupos].guycursorX,use_menu[menupos].guycursorY);
			if (desc[getopt()]) {
				var t:Sprite = getoptiondesc(desc[getopt()]);
				use_menu[menupos].guycursor.addChild(t)
			}
			use_menu[menupos].addChild(use_menu[menupos].guycursor);
		}
		
		private function getoptiondesc(t:String):Sprite {
			var text:TextField = new TextField;
			var besttimebubble:Sprite = new Sprite;
			text.embedFonts = true;
            text.antiAliasType = AntiAliasType.ADVANCED;
			text.text = t;
			text.wordWrap = true;
			text.selectable=false;
			text.setTextFormat(JumpDieCreateMain.getTextFormat(10));
			var textbubblepic:Bitmap = new Textdisplay.t2 as Bitmap;
			besttimebubble.addChild(textbubblepic);
			besttimebubble.addChild(text);
			textbubblepic.scaleX = -0.8;
			text.width = textbubblepic.width;
			text.height = textbubblepic.height;
			textbubblepic.alpha = 0.9;
			text.x = -textbubblepic.width+5;
			text.y = 3;
			besttimebubble.x = 3;
			besttimebubble.y = -besttimebubble.height+3;
			return besttimebubble;
		}
		
		private function getopt():String {
			if (this.use_menu == this.main_menu) {
				if (this.menupos == 0) {
					return "adventure";
				} else if (this.menupos == 1) {
					return "online";
				} else if (this.menupos == 2) {
					return "level editor";
				}
				
			} else if (this.use_menu == this.online_menu) {
				if (this.menupos == 0) {
					return "random online";
				}
				
			} else if (this.use_menu == this.world_menu) {
				if (this.menupos == 0) {
					return "world 1";
				} else if (this.menupos == 1) {
					return "world 2";
				} else if (this.menupos == 2) {
					return "world 3";
				}
			}
			return "";
		}
		
		private function initdesc() {
			desc["adventure"] = "Play the levels!\nLots of surprises await!";
			desc["online"] = "Browse and play user-made levels online!";
			desc["level editor"] = "Create and submit your own levels!";
			desc["random online"] = "Play a randomly selected level.";
			desc["world 1"] = "The first world and tutorial! You don't want to skip this!";
			desc["world 2"] = "The second world!\nIt only gets harder from here!";
			desc["world 3"] = "The third and final world! Only for the truly hardcore.";
		}
		
		public override function destroy() {
			while(main.numChildren > 0) {
    			main.removeChildAt(0);
			}
			main.stage.removeEventListener(KeyboardEvent.KEY_UP, keyPressed);
		}
		
		private function initmenu() {
			main_menu = new Array(new MenuOption(250,230,adventure,ADVENTURE),
								  new MenuOption(250,280,online,ONLINE),
								  new MenuOption(250,330,leveleditor,JumpDieCreateMain.LEVELEDITOR));
			
			world_menu = new Array(new MenuOption(250,210,world1,JumpDieCreateMain.WORLD1),
								   new MenuOption(250,260,world2,JumpDieCreateMain.WORLD2),
								   new MenuOption(250,310,world3,JumpDieCreateMain.WORLD3),
								   new MenuOption(250,360,(new backdata) as Bitmap,BACK_TO_MAIN));
			
			online_menu = new Array(new MenuOption(250,210,playrandom,JumpDieCreateMain.RANDOMONLINE),
								   new MenuOption(250,360,(new backdata) as Bitmap,BACK_TO_MAIN));
		}
		
		public static var ADVENTURE:Number = -3;
		public static var ONLINE:Number = -1;
		public static var BACK_TO_MAIN:Number = -2;
		
		[Embed(source='..//img//misc//menubg0.png')]
		public static var t1c:Class;
		public static var titlebg:Bitmap = new t1c();
		
						[Embed(source='..//img//misc//menububble.png')]
		public static var menububble:Class;
		
				[Embed(source='..//img//misc//titlelogo.png')]
		private var l1:Class;
		private var titlelogo:Bitmap = new l1();
		
		[Embed(source='..//img//soundon.png')]
		private var mb1:Class;
		private var muteoff:Bitmap = new mb1();
		
		[Embed(source='..//img//soundoff.png')]
		private var mb2:Class;
		private var muteon:Bitmap = new mb2();
		
		[Embed(source='..//snd//beep.mp3')] 		 
		private var MySound : Class;
		private var sound : Sound;
		
		[Embed(source='..//img//misc//adventure.png')]
		private var a1:Class;
		private var adventure:Bitmap = new a1();
		
		[Embed(source='..//img//misc//online.png')]
		private var a2:Class;
		private var online:Bitmap = new a2();
		
				[Embed(source='..//img//misc//leveleditor.png')]
		private var a3:Class;
		private var leveleditor:Bitmap = new a3();
		
						[Embed(source='..//img//misc//world1.png')]
		private var a5:Class;
		private var world1:Bitmap = new a5();
		
								[Embed(source='..//img//misc//world2.png')]
		private var a6:Class;
		private var world2:Bitmap = new a6();
		
		[Embed(source='..//img//misc//world3.png')]
		private var a7:Class;
		private var world3:Bitmap = new a7();
		
				[Embed(source='..//img//misc//playrandom.png')]
		private var a8:Class;
		private var playrandom:Bitmap = new a8();
		
						[Embed(source='..//img//misc//toprated.png')]
		private var a9:Class;
		private var toprated:Bitmap = new a9();
		
								[Embed(source='..//img//misc//entername.png')]
		private var a10:Class;
		private var entername:Bitmap = new a10();
		
		[Embed(source='..//img//misc//back.png')]
		private var backdata:Class;
		
		public static function getTextBubble():Bitmap {
			var s:Bitmap = (new menububble) as Bitmap;
			s.x = 100; s.y = 118;
			return s;
		}
		
	}
	
}
