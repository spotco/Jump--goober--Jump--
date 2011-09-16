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
			mute = false;
			initmusic();
			curfunction = new JumpDieCreateMenu(this);
			
		}
		
		public function menuStart(menupos:Number) {
			curfunction.destroy();
			stop();
			if (menupos == WORLD1) {
				curfunction = new TutorialGame(this);
			} else if (menupos == LEVELEDITOR) {
				curfunction = new LevelEditor(this);
			} else if (menupos == RANDOMONLINE) {
				curfunction = new RandomOnlineGame(this);
			} else if (menupos == ENTERNAMEONLINE) {
				curfunction = new JumpDieCreateMenu(this);
			}
		}
		
		//oh yeah, and the main is the sound manager lol
		private function initmusic() {
			music = new Array();
			//TODO -- Add in better
			/*music.push((new m1) as Sound);
			music.push((new m3) as Sound);*/
		}
		
		public function playRandom() {
			if (!mute) {
				if (sc) {
					sc.stop();
				}
				if (music.length == 0) {
					return;
				}
				sc = music[Math.round(Math.random()*(music.length-1))].play(0,9999);
			}
		}
		
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
				}  else if (tar == WIN_SOUND) {
					test = ((new winsounddata) as Sound);
				}
				if (repeat) {
					sc = test.play(0,9999);
				} else {
					sc = test.play();
				}
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
		public static var WORLD2:Number = 0;
		public static var WORLD3:Number = 0;
		
		public static var MENU_MUSIC:Number = 44141;
		public static var LEVELEDITOR_MUSIC:Number = 12312;
		public static var WIN_SOUND:Number = 19282;
		

		[Embed(source='snd//menu.mp3')] 		 
		private var mmenu : Class;
		
		[Embed(source='snd//explode.mp3')] 		 
		public var explode : Class;
		public var explodesound:Sound = (new explode) as Sound;
		
		
		[Embed(source='snd//leveleditor.mp3')] 		 
		private var mleveleditor : Class;
		
		[Embed(source='snd//win.mp3')] 		 
		private var winsounddata:Class;
		
		private var music : Array;
		
		[Embed(source='misc//Bienvenu.ttf', embedAsCFF="false", fontName='Game', fontFamily="Game", mimeType='application/x-font')] 
      	public static var bar:String;
		
		public static function getTextFormat(size:Number):TextFormat {
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "Game";
           	textFormat.size = size;
			return textFormat;
		}
		
	}
	
}
