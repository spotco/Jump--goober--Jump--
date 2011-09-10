package  {
	import flash.text.TextField;
	import flash.events.*;
	import flash.text.TextFormat;
	import flash.display.BitmapData;
	import flash.text.AntiAliasType;
	import flash.display.*;
	import flash.net.*;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	
	
	public class Preloader extends MovieClip {
		[Embed(source='misc//Bienvenu.ttf', embedAsCFF="false", fontName='Game', fontFamily="Game", mimeType='application/x-font')] 
		public var bar:String;
		
		public var loadingdisplay:TextField;
		public var container:MovieClip;
		
		public var animguy:Guy;
		public var animwall:Wall;
		
		public var loadbarcontainer:Sprite;
		
		public var timer:Timer;
		var swfLoader:Loader;
		
		public function Preloader() {

			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "Game";
			textFormat.size = 30;
			
			swfLoader = new Loader();
			var swfFile:URLRequest = new URLRequest("jumpdiecreate.swf");
			container= new MovieClip();
			
			loadingdisplay = new TextField();
			loadingdisplay.x = 95; loadingdisplay.y = 160;
			loadingdisplay.embedFonts = true;
			loadingdisplay.antiAliasType = AntiAliasType.ADVANCED;
			loadingdisplay.selectable = false;
			loadingdisplay.width = 500;
			loadingdisplay.height = 500;
			loadingdisplay.text = "Loading, please wait...";
			loadingdisplay.textColor = 0xFFFFFF;
			loadingdisplay.defaultTextFormat = textFormat;
			addChild(loadingdisplay);
			
			swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			swfLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgress);
			 
			swfLoader.load(swfFile);
			 
			container.addChild(swfLoader);
			addChild(container);
			
			animguy = new Guy(250,250);
			animwall = new Wall(0,520,500,10);
			addChild(animguy);
			addChild(animwall);
			
			timer = new Timer(30);
            timer.addEventListener(TimerEvent.TIMER, update);
            timer.start();
			
			drawload();
			loadbarcontainer = new Sprite;
			addChild(loadbarcontainer);
		}
		
		function drawload() {
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(107,212,288,13);
			graphics.drawRect(95,225,13,83);
			graphics.drawRect(107,308,288,13);
			graphics.drawRect(395,225,13,83);
		}
		
		function update(e:TimerEvent) {
			animguy.update(new Array(animwall));
			if (Math.abs(animguy.vy) < 0.2) {
				animguy.vy = -10;
				animguy.canJump = false;
			}
			//trace("test");
		}
		
		function loadComplete(e:Event):void {
			timer.stop();
			removeChild(animwall);
			removeChild(animguy);
			removeChild(loadbarcontainer);
			graphics.clear();
			loadingdisplay.text = "Loading, please wait...";
			swfLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
		}

		function loadProgress(event:ProgressEvent):void {
			var percentLoaded:Number = event.bytesLoaded / event.bytesTotal;
			percentLoaded = Math.round(percentLoaded * 100);
			loadingdisplay.text = "Percent Loaded:"+percentLoaded+"%";
			loadbarcontainer.graphics.clear();
			loadbarcontainer.graphics.beginFill(0xFFFFFF);
			loadbarcontainer.graphics.drawRect(107,225,287*(percentLoaded/100),83);
		}
	}
	
}
