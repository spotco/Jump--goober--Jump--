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
		
		private var statusdisplaycontainer:Sprite = new Sprite;
		private var statusdisplay = new TextField();
		
		private var desc:Object = new Object();
		private var titlelogo:Bitmap;
		
		public function JumpDieCreateMenu(main:JumpDieCreateMain) {
			initdesc();
			initmenu();
			this.main = main;
			sound = (new MySound) as Sound;
			menupos = 0;
			if (!main.pmenufix) {
				main.playSpecific(JumpDieCreateMain.MENU_MUSIC);
			}
			titlelogo = new l1 as Bitmap;
			titlelogo.x = 70; titlelogo.y = 15;
			main.addChild(new t1c as Bitmap);
			main.addChild(titlelogo);
			main.addChild(menubuttonwrapper);
			use_menu = main_menu;
			loadOptions();
			updateCursor();
			
			//make keypress
			main.cstage.addEventListener(KeyboardEvent.KEY_UP,keyPressed);
			main.cstage.focus = main.cstage;
			makemutebutton();
			
			makelogo();
			
			checkonline();
			JumpDieCreateMain.gc();
		}
		
		private function makelogo() {
			var logo:TextField = SubmitMenu.maketextdisplay(0,505,"SPOTCO(www.spotcos.com)",12,200,30);
			main.addChild(logo);
		}
		
		private function checkonline() {
			var urlRequest:URLRequest = new URLRequest(JumpDieCreateMain.ONLINE_DB_URL+'getnumlevels.php');
			var vars:URLVariables = new URLVariables;
			vars.nocache = new Date().getTime(); 
			urlRequest.data = vars;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, updateonlinestatus);
			urlLoader.load(urlRequest);
			
			var s:Bitmap = new GameEngine.mb4 as Bitmap;
			s.scaleX = 2.3;
			statusdisplaycontainer.addChild(s);
			statusdisplay.embedFonts = true;
            statusdisplay.antiAliasType = AntiAliasType.ADVANCED;
            statusdisplay.x = 12; statusdisplay.y = 2;
            statusdisplay.width = 500;
			statusdisplay.selectable = false;
			statusdisplay.text = "SERVER STATUS: OFFLINE";
			statusdisplay.setTextFormat(JumpDieCreateMain.getTextFormat(10));
			statusdisplay.defaultTextFormat = JumpDieCreateMain.getTextFormat(10);
			
			statusdisplaycontainer.addChild(statusdisplay);
			main.addChild(statusdisplaycontainer);
			
			statusdisplaycontainer.x = -10;
			statusdisplaycontainer.y = 504;
			statusdisplaycontainer.visible = false;
		}
		
		private function updateonlinestatus(e:Event) {
			var t:XML = new XML(e.target.data);
			statusdisplay.text = "SERVER STATUS: ONLINE with currently "+(t.numlevels.@val-1)+" levels!";
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
											main.pmenufix = false;
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
			if (use_menu == online_menu) {
				statusdisplaycontainer.visible = true;
			} else {
				statusdisplaycontainer.visible = false;
			}
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
				} else if (this.menupos == 1) {
					return "newest online";
				} else if (this.menupos == 2) {
					return "most plays online";
				} else if (this.menupos == 3) {
					return "specific online";
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
			desc["newest online"] = "Browse the newest submitted levels online!";
			desc["most plays online"] = "Browse the most played levels online!";
			desc["specific online"] = "Enter a specific level to play online!";
		}
		
		public override function destroy() {
			JumpDieCreateMain.clearDisplay(main);
			main.stage.removeEventListener(KeyboardEvent.KEY_UP, keyPressed);
		}
		
		private function initmenu() {
			main_menu = new Array(new MenuOption(250,260,adventure,ADVENTURE),
								  new MenuOption(250,310,online,ONLINE),
								  new MenuOption(250,360,leveleditor,JumpDieCreateMain.LEVELEDITOR));
			
			world_menu = new Array(new MenuOption(250,260,world1,JumpDieCreateMain.WORLD1),
								   new MenuOption(250,310,world2,JumpDieCreateMain.WORLD2),
								   new MenuOption(250,360,world3,JumpDieCreateMain.WORLD3),
								   new MenuOption(250,410,(new backdata) as Bitmap,BACK_TO_MAIN));
			
			online_menu = new Array(new MenuOption(250,250,playrandom,JumpDieCreateMain.RANDOMONLINE),
									new MenuOption(250,300,newestsubmitted,JumpDieCreateMain.NEWESTONLINE),
									new MenuOption(250,350,mostplayed,JumpDieCreateMain.MOSTPLAYEDONLINE),
									new MenuOption(250,400,entername,JumpDieCreateMain.SPECIFICONLINE),
								   new MenuOption(250,450,(new backdata) as Bitmap,BACK_TO_MAIN));
		}
		
		public static var ADVENTURE:Number = -3;
		public static var ONLINE:Number = -1;
		public static var BACK_TO_MAIN:Number = -2;
		
		[Embed(source='..//img//misc//menubg0.png')]
		public static var t1c:Class;
		
						[Embed(source='..//img//misc//menububble.png')]
		public static var menububble:Class;
		
				[Embed(source='..//img//misc//titlelogo.png')]
		private var l1:Class;
		
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
		
						[Embed(source='..//img//misc//mostplayed.png')]
		private var a9:Class;
		private var mostplayed:Bitmap = new a9();
		
								[Embed(source='..//img//misc//newestsubmitted.png')]
		private var a11:Class;
		private var newestsubmitted:Bitmap = new a11();
		
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
