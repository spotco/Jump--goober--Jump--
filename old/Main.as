package {
	import CPMStar.AdLoader;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.*;
	
	public class Main extends MovieClip {
		
		[Embed(source='preloader_bar.png')] 		 
		private var preloader_bar:Class;
		
		[Embed(source='preloader_bg.png')] 		 
		private var preloader_bg:Class;
		
		private var bg:Bitmap = new preloader_bg as Bitmap;
		private var bar:Bitmap = new preloader_bar as Bitmap;
		var testtext:TextField = new TextField();
		
		var t:Timer = new Timer(20)
		var m_w:Number = bar.width;
		
		public function Main():void {
			if (stage) {
				start();
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, function() { start(); } );
			}

		}
		
		private function start() {
			this.addChild(bg);
			this.addChild(bar);
			bar.x = 33;
			bar.y = 479;
			bar.scrollRect = new Rectangle(0, 0, 0, bar.height);
			
			t.addEventListener(TimerEvent.TIMER, update);
			t.start();
			init_ad();
			stop();
		}
		
		var bgframe:Sprite = new Sprite;
		var adContainer:MovieClip = new MovieClip;
		var testAd:AdLoader = new AdLoader("6601Q3F4C5CDF");
		
		private function init_ad() {			
			bgframe.graphics.lineStyle(5,0x111111);
			bgframe.graphics.moveTo(100,50);
			bgframe.graphics.lineTo(100+300,50);
			bgframe.graphics.lineTo(100+300,50+250);
			bgframe.graphics.lineTo(100,50+250);
			bgframe.graphics.lineTo(100,50);

			adContainer.graphics.beginFill(0);
			adContainer.graphics.drawRect(0, 0, 300, 250);
			adContainer.graphics.endFill();

			adContainer.width = 300;
			adContainer.height = 250;
			adContainer.x = 100;
			adContainer.y = 50;

			this.addChild(bgframe);
			adContainer.addChild(testAd);
			this.addChild(adContainer);
		}
		
		private function update(e:Event) {
			if (!stage) {
				return;
			}
			var percent_total:Number = (Number(stage.loaderInfo.bytesLoaded) / Number(stage.loaderInfo.bytesTotal));
			bar.scrollRect = new Rectangle(0, 0, percent_total * m_w, bar.height);
			if (percent_total >= 1) {
				t.removeEventListener(TimerEvent.TIMER, update);
				t.stop();
				nextFrame();
				init_game();
			}
			
		}
		
		[Embed(source='startgame_bg.png')] 		 
		private var startgame_bg:Class;
		
		var playb:Sprite;
		var moregames:Sprite;
		
		private function init_game() {
			stop();
			trace("preloader bar done");
			this.removeChild(bg);
			this.removeChild(bar);
			this.addChild(new startgame_bg as Bitmap);
			
			this.setChildIndex(bgframe, this.numChildren - 1);
			this.setChildIndex(adContainer, this.numChildren - 1);
			
			playb = new Sprite;
			playb.x = 113;
			playb.y = 460;
			playb.graphics.beginFill(0x00FF00, 0);
			playb.graphics.drawRect(0, 0, 98, 43);
			
			moregames = new Sprite;
			moregames.x = 226;
			moregames.y = 460;
			moregames.graphics.beginFill(0x00FF00, 0);
			moregames.graphics.drawRect(0, 0, 192, 43);
			
			this.addChild(playb);
			this.addChild(moregames);
			
			playb.addEventListener(MouseEvent.ROLL_OVER, function() {
				Mouse.cursor = MouseCursor.BUTTON;
			});
			
			playb.addEventListener(MouseEvent.ROLL_OUT, function() {
				Mouse.cursor = MouseCursor.AUTO;
			});
			
			moregames.addEventListener(MouseEvent.ROLL_OVER, function() {
				Mouse.cursor = MouseCursor.BUTTON;
			});
			
			moregames.addEventListener(MouseEvent.ROLL_OUT, function() {
				Mouse.cursor = MouseCursor.AUTO;
			});
			
			playb.addEventListener(MouseEvent.CLICK, function() {
				start_game();
			});
			
			moregames.addEventListener(MouseEvent.CLICK, function() {
				flash.net.navigateToURL(new URLRequest("http://www.flashegames.net/"));
			});
		}
		
		private function start_game() {
			var c:Class = Class(getDefinitionByName("Preloader"));
			new c(stage);
			stage.removeChild(this);
		}
		
	}
	
}