package {
	import flash.text.TextField;
	import flash.events.*;
	import flash.text.TextFormat;
	import flash.display.BitmapData;
	import flash.text.AntiAliasType;
	import flash.display.*;
	import flash.net.*;
	import flash.display.MovieClip;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import com.gskinner.utils.SWFBridgeAS3;
	import flash.utils.ByteArray;
	
	
	public class Preloader extends MovieClip {

		public var container:MovieClip;		
		var swfLoader:Loader;
		var myBridge:SWFBridgeAS3;
		
		[Embed(source='intro.swf', mimeType="application/octet-stream")] 		 
		private var gameslogoswf:Class;
		
		[Embed(source='jumpdiecreate.swf', mimeType="application/octet-stream")] 		 
		private var gameswf:Class;
		
		private var cstage:Stage;
		
		public function Preloader(stage:Stage) {
			stage.addChild(this);
			this.cstage = stage;
			
			swfLoader = new Loader();
			container= new MovieClip();
			swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(){loadComplete()});
			swfLoader.loadBytes(new gameslogoswf as ByteArray);
			 
			container.addChild(swfLoader);
			
			addChild(container);
			
			init_time = getTimer();
			this.addEventListener(Event.ENTER_FRAME, backup_init);
		}
		
		var init_time:Number;
		
		private function backup_init(e:Event) {
			if (getTimer() - init_time > 6000) {
				trace("backup activated");
				test();
				this.removeEventListener(Event.ENTER_FRAME, backup_init);
			}
		}
		
		public function clickhide() {
			while (cstage.numChildren > 0) {
				cstage.removeChildAt(0);
			}
			cstage.addChild(this);
		}
		
		public function loadComplete() {
			try {
				myBridge = new SWFBridgeAS3("12345", this);
			} catch (e:Error) {
				test();
			}
		}
		
		private var gameswfLoader:Loader;
		private var gamecontainer:MovieClip;
		
		private var kill:Boolean = false;
		
		public function test() {
			if (kill) {
				return;
			} else {
				kill = true;
			}
			trace("Starting Game...");
			removeChild(container);
			
			container.removeChild(swfLoader);
			
			while (this.numChildren > 0) {
				this.removeChildAt(0);
			}
			cstage.addChild(this);
			
			container = null;
			swfLoader = null;
			
			gamecontainer = new MovieClip;
			gameswfLoader = new Loader();
			gameswfLoader.loadBytes(new gameswf as ByteArray);
			cstage.frameRate = 60;
			gamecontainer.addChild(gameswfLoader);
			this.addChild(gamecontainer);
			gamecontainer.addChild(gameswfLoader);
			
			if (myBridge != null && myBridge.connected) {
				myBridge.close();
			}
		}
		
	}
	
}
