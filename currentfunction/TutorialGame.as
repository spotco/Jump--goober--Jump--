package currentfunction {
	import flash.display.*;
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
	import flash.media.Sound;
	import mx.core.ByteArrayAsset;
	import flash.text.AntiAliasType;
		import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class TutorialGame extends CurrentFunction {
		public var levels:Array;
		public var main:JumpDieCreateMain;
		public var clvl:Number;
		public var currentGame:GameEngine;
		public var switchsong:Boolean;
		
		public function TutorialGame(main:JumpDieCreateMain) {
			starttime = new Date();
			numDeath = 0;
			makeLevelArray();
			this.main = main;
			clvl = 0;
			switchsong = true;
			startLevel();
		}
		
		public override function startLevel() {
			if (clvl >= levels.length) {
				clvl = 0;
			}
			currentGame = null;
			if (switchsong) {
				main.playRandom();
				switchsong = false;
			}
			currentGame = new GameEngine(main,this,levels[clvl],levels[clvl].@name);
		}
		
		public override function nextLevel(hitgoal:Boolean) {
			//hitgoal = true;
			if (hitgoal) {
				var endtime:Date = new Date();
				var sectotal:Number = (endtime.hours - starttime.hours)*60*60 + (endtime.minutes - starttime.minutes)*60 + (endtime.seconds - starttime.seconds);
				trace("timeSec:"+sectotal);
				var displaytime:String = Math.floor(sectotal/60) + ":";
				if (sectotal%60 < 10) {
					displaytime += "0"+(sectotal%60);
				} else {
					displaytime += (sectotal%60);
				}
				trace("numDeath:"+numDeath);
				
				main.addChild(JumpDieCreateMenu.titlebg);
				main.addChild(JumpDieCreateMenu.getTextBubble());
				
				var displaytext:TextField = new TextField; 
				displaytext.embedFonts = true;
            	displaytext.antiAliasType = AntiAliasType.ADVANCED;
				displaytext.selectable = false;
				displaytext.text = "Time: "+displaytime+"\nDeaths: "+numDeath+"\n\nPress Space\nto Continue";
				displaytext.x = 170; displaytext.y = 225; displaytext.width = 230; displaytext.height = 400;
				displaytext.defaultTextFormat = JumpDieCreateMain.getTextFormat(20);
				displaytext.setTextFormat(JumpDieCreateMain.getTextFormat(20));
				main.addChild(displaytext);
				
				var displayflash:Timer = new Timer(1000);
				displayflash.addEventListener(TimerEvent.TIMER, function(){
											  		if (displaytext.wordWrap) {
														displaytext.text = "Time: "+displaytime+"\nDeaths: "+numDeath+"\n\nPress Space\nto Continue";
													} else {
														displaytext.text = "Time: "+displaytime+"\nDeaths: "+numDeath;
													}
													displaytext.wordWrap = !displaytext.wordWrap;
													if (displaytext.stage == null) {
														displayflash.stop();
													}
													//trace("lol");
											  });
				displayflash.start();
				
				var winanim:WinAnimation = new WinAnimation();
				winanim.x = 140; winanim.y = 140;
				main.addChild(winanim);
				winanim.start();
				main.stop();
				if (!main.mute) {
					main.winsound.play(0,1);
				}
				main.stage.addEventListener(KeyboardEvent.KEY_DOWN, winscreencontinue);
				main.stage.focus = main.stage;
				return;
			} else {
				loadNextLevel();
			}
		}
		
		function winscreencontinue(e:KeyboardEvent){
			if (e.keyCode == Keyboard.SPACE) {
				while(main.numChildren > 0) {
					main.removeChildAt(0);
				}
				main.stage.removeEventListener(KeyboardEvent.KEY_DOWN, winscreencontinue);
				loadNextLevel();
			}
		}
		
		public function loadNextLevel() {
			numDeath = 0;
			starttime = new Date;
			clvl++;
			switchsong = true;
			startLevel();
		}
		
		public override function destroy() {
			main.curfunction = null;
			this.currentGame = null;
			this.levels = null;
			main.stop();
			main.curfunction = new JumpDieCreateMenu(main);
		}
		
		private function makeLevelArray() {
			levels = new Array();
			levels.push(getXML(new l1()));
			levels.push(getXML(new l2()));
			levels.push(getXML(new l3()));
			levels.push(getXML(new l4()));
			levels.push(getXML(new l5()));
			levels.push(getXML(new l6()));
			levels.push(getXML(new l7()));
			levels.push(getXML(new l8()));
			levels.push(getXML(new l9()));
			levels.push(getXML(new l10()));
		}
		
		private static function getXML(input:Object) : XML {
   			var ba:ByteArrayAsset = ByteArrayAsset(input);
   			var xml:XML = new XML( ba.readUTFBytes( ba.length ) );
   			return xml;    
		}
				
		[Embed(source="..//misc//world_1//level1.xml", mimeType="application/octet-stream")]
		protected static const l1:Class;
		
		[Embed(source="..//misc//world_1//level2.xml", mimeType="application/octet-stream")]
		protected static const l2:Class;
		
		[Embed(source="..//misc//world_1//level3.xml", mimeType="application/octet-stream")]
		protected static const l3:Class;
		
		[Embed(source="..//misc//world_1//level4.xml", mimeType="application/octet-stream")]
		protected static const l4:Class;
		
		[Embed(source="..//misc//world_1//level5.xml", mimeType="application/octet-stream")]
		protected static const l5:Class;
		
		[Embed(source="..//misc//world_1//level6.xml", mimeType="application/octet-stream")]
		protected static const l6:Class;
		
		[Embed(source="..//misc//world_1//level7.xml", mimeType="application/octet-stream")]
		protected static const l7:Class;
		
		[Embed(source="..//misc//world_1//level8.xml", mimeType="application/octet-stream")]
		protected static const l8:Class;
		
		[Embed(source="..//misc//world_1//level9.xml", mimeType="application/octet-stream")]
		protected static const l9:Class;
		
		[Embed(source="..//misc//world_1//level10.xml", mimeType="application/octet-stream")]
		protected static const l10:Class;
		
	}
	
}
