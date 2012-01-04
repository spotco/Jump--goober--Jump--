package  {
	import flash.display.*; //lol k
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.geom.Rectangle;
	import flash.net.*;
	import flash.xml.*;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.net.*;
	import flash.xml.*;
	import flash.media.*;
	import flash.events.ProgressEvent;
	import flash.sampler.NewObjectSample;
	import flash.display.LoaderInfo;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.system.Security;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	//JUMP DIE AND CREATE by spotco (http://www.spotcos.com)
	//An extension of Jump or Die (http://spotcos.com/misc/jumpdie/jumpordie.html), the xml level files are even both ways compatable!
	//Compile from this class to run, a seperate SWF for preloader
	
	public class JumpDieCreateMain extends Sprite {
		public var sc:SoundChannel;
		public var curfunction:CurrentFunction;
		public var mute:Boolean;
		public var cstage:Stage;
		
		public function JumpDieCreateMain(stage:Stage) {
			var _mochiads_game_id:String = "2b4163180653a1e6";
			Security.allowDomain("spotcos.com");
            Security.allowInsecureDomain("spotcos.com");
			cstage = stage;
			mute = true;
			curfunction = new JumpDieCreateMenu(this);
		}
		
		public function menuStart(menupos:Number) {
			curfunction.destroy();
			if (menupos != WORLD1 && menupos != WORLD2 && menupos != WORLD3) {
				stop();
			}
			if (menupos == WORLD1) {
				curfunction = new TutorialGame(this);
			} else if (menupos == LEVELEDITOR) {
				curfunction = new LevelEditor(this);
			} else if (menupos == RANDOMONLINE) {
				curfunction = new RandomOnlineGame(this);
			} else if (menupos == ENTERNAMEONLINE) {
				curfunction = new JumpDieCreateMenu(this);
			} else if (menupos == WORLD2) {
				curfunction = new WorldTwoGame(this);
			} else if (menupos == WORLD3) {
				curfunction = new WorldThreeGame(this);
			}
		}
		
		//oh yeah, and the main is the sound manager lol
		public function playSpecific(tar:Number,repeat:Boolean = true) {
			if (!mute) {
				if (sc) {
					sc.stop();
				}
				var test:Sound;
				
				if (tar == LEVELEDITOR_MUSIC) {
					test = ((new mleveleditor) as Sound);
				} else if (tar == MENU_MUSIC) {
					test = ((new mmenu) as Sound);
				} else if (tar == SONG1) {
					test = ((new m1) as Sound);
				} else if (tar == SONG2) {
					test = ((new m2) as Sound);
				} else if (tar == SONG1END) {
					test = ((new m1end) as Sound);
				} else if (tar == SONG2END) {
					test = ((new m2end) as Sound);
				} else if (tar == SONG3END) {
					test = ((new m3end) as Sound);
				} else if (tar == ONLINEEND) {
					test = ((new onlineend) as Sound);
				} else if (tar == ONLINE) {
					test = ((new online) as Sound);
				} else if (tar == SONG3) {
					test = ((new m3) as Sound);
				} else if (tar == SONG4) {
					test = ((new m4) as Sound);
				} else if (tar == BOSSSONG) {
					test = ((new mboss) as Sound);
				} else if (tar == BOSSENDSONG) {
					test = ((new mbossend) as Sound);
				}
				
				if (repeat) {
					sc = test.play(0,9999);
				} else {
					sc = test.play();
				}
				
				/*if (tar == SONG1) {
					sc.addEventListener(Event.SOUND_COMPLETE, function() {
											var test2:Sound = (new m1) as Sound;
											sc = test2.play(0,9999);
										});
				}*/
			}
		}
		
		public function stop() {
			if (sc) {
				sc.stop();
			}
		}
		
		public static var LEVELEDITOR:Number = 2;
		public static var RANDOMONLINE:Number = 3;
		public static var TOPONLINE:Number = 0;
		public static var ENTERNAMEONLINE:Number = 5;
		
		public static var WORLD1:Number = 6;
		public static var WORLD2:Number = 7;
		public static var WORLD3:Number = 8;
		
		public static var MENU_MUSIC:Number = 44141;
		public static var LEVELEDITOR_MUSIC:Number = 12312;
		public static var WIN_SOUND:Number = 19282;
		public static var BOSSSONG:Number = 99213;
		public static var BOSSENDSONG:Number = 88732;
		public static var SONG1:Number = 23567;
		public static var SONG2:Number = 67223;
		public static var SONG3:Number = 65412;
		public static var SONG4:Number = 44214;
		public static var SONG1END:Number = 87367;
		public static var SONG2END:Number = 66423;
		public static var SONG3END:Number = 13325;
		public static var ONLINE:Number = 77231;
		public static var ONLINEEND:Number = 88123;
		
		[Embed(source='snd//song1.mp3')] 		 
		private var m1 : Class;
		
		[Embed(source='snd//song1end.mp3')] 		 
		private var m1end : Class;
		
		[Embed(source='snd//song2.mp3')] 		 
		private var m2 : Class;
		
		[Embed(source='snd//song2end.mp3')] 		 
		private var m2end : Class;
		
		[Embed(source='snd//song3.mp3')] 		 
		private var m3 : Class;
		
		[Embed(source='snd//song3end.mp3')] 		 
		private var m3end : Class;
		
		[Embed(source='snd//bossend.mp3')] 		 
		private var mbossend : Class;

		[Embed(source='snd//boss.mp3')] 		 
		private var mboss : Class;

		[Embed(source='snd//menu.mp3')] 		 
		private var mmenu : Class;
		
		[Embed(source='snd//online.mp3')] 		 
		private var online : Class;

		[Embed(source='snd//onlineend.mp3')] 		 
		private var onlineend : Class;
		
		[Embed(source='snd//explode.mp3')] 		 
		public var explode : Class;
		public var explodesound:Sound = (new explode) as Sound;
		
		
		[Embed(source='snd//leveleditor.mp3')] 		 
		private var mleveleditor : Class;
		
		private var music : Array;
		
		[Embed(source='misc//Bienvenu.ttf', embedAsCFF="false", fontName='Game', fontFamily="Game", mimeType='application/x-font')] 
      	public static var bar:String;
		
		[Embed(source='misc//acknowtt.ttf', embedAsCFF="false", fontName='Menu', fontFamily="Menu", mimeType='application/x-font')] 
      	public static var foo:String;
		
		public static function getTextFormat(size:Number,type:Number = 1):TextFormat {
			var textFormat:TextFormat = new TextFormat();
			if (type == 2) {
				textFormat.font = "Menu";
			} else {
				textFormat.font = "Game";
			}
			textFormat.size = size;
			return textFormat;
		}
		
	}
	
}
