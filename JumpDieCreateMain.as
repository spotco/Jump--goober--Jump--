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
	import flash.events.*;
	import flash.system.*;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	import CPMStar.AdLoader;
	
	//JUMP DIE AND CREATE by spotco (http://www.spotcos.com)
	//An extension of Jump or Die (http://spotcos.com/misc/jumpdie/jumpordie.html), the xml level files are even both ways compatable!
	//public static var ONLINE_DB_URL:String =  "http://spotcos.com/jumpdiecreate/dbscripts/";
	
	public class JumpDieCreateMain extends Sprite {
		public var sc:SoundChannel;
		public var curfunction:CurrentFunction;
		public var mute:Boolean;
		public var cstage:Stage;
		public var localdata:SharedObject;
		public var rankdata:Object;
		public var mochimanager:MochiManager;
		
		public static var MOCHI_ENABLED:Boolean = true;
		public static var ONLINE_DB_URL:String =  "http://flashegames.net/spotco/"; //main on flashegames
		public static var HAS_CHALLENGE_LEVELS:Boolean = false;
		public static var IS_MUTED:Boolean = false;
		
		public static var CONTEST_MODE:Boolean = false;
		public static var LEVELS_UNLOCKED:Boolean = false;
		
		
		public function JumpDieCreateMain(stage:Stage=null) {
			cstage = stage;
			//var _mochiads_game_id:String = "2b4163180653a1e6"; JUMP DIE CREATE on spotco
			//var _mochiads_game_id:String = "aa38693f65f9ca8e"; Jump, Goober, Jump on mthree
			var _mochiads_game_id:String = "b503d0e90c77ace3"; //Jump, goober, jump unlocked
			localdata = SharedObject.getLocal("JumpDieOrCreateSPOTCO");
			Security.allowDomain("*");
			Security.loadPolicyFile("http://flashegames.net/spotco/crossdomain.xml");
			Security.allowDomain("mochiads.com");
			Security.allowDomain("gameplay.mochimedia.com");
			mochimanager = new MochiManager(_mochiads_game_id,this,localdata);
			
			Security.allowDomain("flashegames.net");
            Security.allowInsecureDomain("flashegames.net");
			stage.quality = StageQuality.LOW;
			
			mute = IS_MUTED;
			
			initrankdata();
			
			verifysave();
			
			if (CONTEST_MODE) {
				ONLINE_DB_URL = "http://flashegames.net/spotcolevel/";
			}
			curfunction = new JumpDieCreateMenu(this);
		}
		
		public static function clearDisplay(s:Sprite) {
			if (s == null) {
				return;
			}
			while(s.numChildren > 0) {
				if (s.getChildAt(0) == null) {
					continue;
				}
				if (s.getChildAt(0) is Bitmap) {
					(s.getChildAt(0) as Bitmap).bitmapData.dispose();
				}
				s.removeChildAt(0);
			}
		}
		
		public static function getChecksum(a:String, b:Number):Number {
			var s = 0;
			for (var i = 0; i < a.length; i++) {
				s+=a.charCodeAt(i);
			}
			s=s%b;
			return s;
		}
		
		public static function tracemem() {
			var s:Timer = new Timer(100);
			s.addEventListener(TimerEvent.TIMER,function() {
				trace((System.totalMemory*0.0009765625)/1024);
			});
			s.start();
		}
		
		public static function gc() {
			System.gc();
			System.gc();
			try {
			new LocalConnection().connect('foo');
			new LocalConnection().connect('foo');
			} catch (e:*) {}
		}
		
		private function verifysave() {
			if (LEVELS_UNLOCKED) {
				localdata.data.world1 = 12;
				localdata.data.world2 = 12;
				localdata.data.world3 = 12;
			}
			if (!localdata.data.world1 || !localdata.data.world2 || !localdata.data.world3) {
				localdata.data.world1 = 1;
				localdata.data.world2 = 1;
				localdata.data.world3 = 1;
				trace("save init");
			}
			
		}
		
		public function menuStart(menupos:Number) {
			try {
				curfunction.destroy();
			} catch (e) {
				trace("this only fires when mochi doesn't connect");
			}
			if (menupos != WORLD1 && menupos != WORLD2 && menupos != WORLD3 && menupos!= MOSTPLAYEDONLINE && menupos!= NEWESTONLINE && menupos!= SPECIFICONLINE && menupos != WORLD_SPECIAL) {
				stop();
			}
			if (menupos == WORLD1) {
				curfunction = new TutorialGame(this);
			} else if (menupos == LEVELEDITOR) {
				curfunction = new LevelEditor(this);
			} else if (menupos == RANDOMONLINE) {
				curfunction = new RandomOnlineGame(this);
			} else if (menupos == WORLD2) {
				curfunction = new WorldTwoGame(this);
			} else if (menupos == WORLD3) {
				curfunction = new WorldThreeGame(this);
			} else if (menupos == MOSTPLAYEDONLINE) {
				curfunction = new BrowseMostPlayedGame(this);
			} else if (menupos == NEWESTONLINE) {
				curfunction = new BrowseMostRecentGame(this);
			} else if (menupos == SPECIFICONLINE) {
				curfunction = new BrowseSpecificGame(this);
			} else if (menupos == JumpDieCreateMain.WORLD_SPECIAL) {
				curfunction = new SpecialGame(this);
			}
		}
		
		public static function add_mouse_over(o:DisplayObject) {
			o.addEventListener(MouseEvent.ROLL_OVER, function() {
				flash.ui.Mouse.cursor = flash.ui.MouseCursor.BUTTON; 
			});
			o.addEventListener(MouseEvent.ROLL_OUT, function() {
				flash.ui.Mouse.cursor = flash.ui.MouseCursor.AUTO; 
			});
		}
		
		public var pmenufix:Boolean = false;
		
		//oh yeah, and the main is the sound manager lol
		public function playSpecific(tar:Number,repeat:Boolean = true) {
			/*if (mute) {
				return;
			}*/
			
			if (tar == MENU_MUSIC && pmenufix) {
				return;
			} else  if (tar == MENU_MUSIC && !pmenufix) {
				pmenufix = true;
			} else {
				pmenufix = false;
			}
			
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
			
			var t:SoundTransform;
			if (mute) {
				t = new SoundTransform(0);
			} else {
				t = new SoundTransform(1);
			}
			
			
			if (repeat) {
				sc = test.play(0,9999,t);
			} else {
				sc = test.play(0,1,t);
			}
		}
		
		public function stop() {
			if (sc) {
				sc.stop();
			}
		}
		
		public static var LEVELEDITOR:Number = 38817;
		public static var RANDOMONLINE:Number = 11293;
		public static var MOSTPLAYEDONLINE:Number = 1232333;
		public static var NEWESTONLINE:Number = 77333;
		public static var SPECIFICONLINE:Number = 828264;
		
		public static var WORLD1:Number = 1283;
		public static var WORLD2:Number = 876423;
		public static var WORLD3:Number = 908974;
		public static var WORLD_SPECIAL:Number = 463811;
		
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
		private static var explode : Class;
		public static var explodesound:Sound = (new explode) as Sound;
		
		[Embed(source='snd//cheer.mp3')] 		 
		private static var cheer : Class;
		public static var cheersound:Sound = (new cheer) as Sound;
		
		[Embed(source='snd//wow.mp3')] 		 
		private static var wow : Class;
		public static var wowsound:Sound = (new wow) as Sound;
		
		
		[Embed(source='snd//fruit.mp3')] 		 
		private static var fruit : Class;
		public static var fruitsound:Sound = (new fruit) as Sound;
		
		[Embed(source='snd//thunder.mp3')] 		 
		private static var thunder : Class;
		public static var thundersound:Sound = (new thunder) as Sound;
		
		[Embed(source='snd//jump//jump1.mp3')] 		 
		private static var jump1 : Class;
		public static var jump1sound:Sound = (new jump1) as Sound;

		[Embed(source='snd//jump//jump2.mp3')] 		 
		private static var jump2 : Class;
		public static var jump2sound:Sound = (new jump2) as Sound;
		
		[Embed(source='snd//jump//jump3.mp3')] 		 
		private static var jump3 : Class;
		public static var jump3sound:Sound = (new jump3) as Sound;
		
		[Embed(source='snd//jump//jump4.mp3')] 		 
		private static var jump4 : Class;
		public static var jump4sound:Sound = (new jump4) as Sound;
		
		[Embed(source='snd//fall.mp3')] 		 
		private static var fall : Class;
		public static var fallsound:Sound = (new fall) as Sound;
		
		[Embed(source='snd//rocketexplode.mp3')] 		 
		private static var rocketexplode: Class;
		public static var rocketexplodesound:Sound = (new rocketexplode) as Sound;
		
		[Embed(source='snd//shoot.mp3')] 		 
		private static var shoot: Class;
		public static var shootsound:Sound = (new shoot) as Sound;
		
		[Embed(source='snd//boost.mp3')] 		 
		private static var boost: Class;
		public static var boostsound:Sound = (new boost) as Sound;
		
		[Embed(source='snd//rocketboss.mp3')] 		 
		private static var rocketboss: Class;
		public static var rocketbosssound:Sound = (new rocketboss) as Sound;
		
		[Embed(source='snd//rocketbossdie.mp3')] 		 
		private static var rocketbossdie: Class;
		public static var rocketbossdiesound:Sound = (new rocketbossdie) as Sound;
		
		[Embed(source='snd//pause.mp3')] 		 
		private static var pause: Class;
		public static var pausesound:Sound = (new pause) as Sound;
		
		[Embed(source='snd//unpause.mp3')] 		 
		private static var unpause: Class;
		public static var unpausesound:Sound = (new unpause) as Sound;
		
		[Embed(source='snd//leveleditor.mp3')] 		 
		private var mleveleditor : Class;
		
		private var music : Array;
		
		[Embed(source='misc//Bienvenu.ttf', embedAsCFF="false", fontName='Game', fontFamily="Game", mimeType='application/x-font')] 
      	public static var bar:String;
		
		[Embed(source='misc//acknowtt.ttf', embedAsCFF="false", fontName='Menu', fontFamily="Menu", mimeType='application/x-font')] 
      	public static var foo:String;
		
				[Embed(source='img//playbutton.png')] 		 
		public static var playbuttonpreloader: Class;
		
		
		public function playsfx(s:Sound,t:SoundTransform = null) {
			if (mute) {
				return;
			}
			s.play(0,1,t);
		}
		
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
		
		private function initrankdata() {
			this.rankdata = RankData.initrankdata();			
		}
		
	}
	
}
