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
	
	public class WorldThreeGame extends TutorialGame {
		
		
		public function WorldThreeGame(main:JumpDieCreateMain) {
			super(main);
		}
		
		public override function startLevel() {
			if (clvl >= levels.length) {
				clvl = 0;
			}
			currentGame = null;
			if (switchsong) {
				if (clvl == 4 || clvl == 8 || clvl == 10) {
					main.playSpecific(JumpDieCreateMain.BOSSSONG);
				} else {
					main.playSpecific(JumpDieCreateMain.SONG3);
				}
				switchsong = false;
			}
			currentGame = new GameEngine(main,this,levels[clvl],levels[clvl].@name,false,3);
		}
		
		public override function makeLevelArray() {
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
			levels.push(getXML(new l11()));
		}
		
		public override function playWinSound() {
				if (clvl == 4 || clvl == 8 || clvl == 10) {
					main.playSpecific(JumpDieCreateMain.BOSSENDSONG,false);
				} else {
					main.playSpecific(JumpDieCreateMain.SONG3END,false);
				}
			
		}
		
		private static function getXML(input:Object) : XML {
   			var ba:ByteArrayAsset = ByteArrayAsset(input);
   			var xml:XML = new XML( ba.readUTFBytes( ba.length ) );
   			return xml;    
		}
				
		[Embed(source="..//misc//world_3//level1.xml", mimeType="application/octet-stream")]
		private var l1:Class;
		
		[Embed(source="..//misc//world_3//level2.xml", mimeType="application/octet-stream")]
		private var l2:Class;
		
		[Embed(source="..//misc//world_3//level3.xml", mimeType="application/octet-stream")]
		private var l3:Class;
		
		[Embed(source="..//misc//world_3//level4.xml", mimeType="application/octet-stream")]
		private var l4:Class;
		
		[Embed(source="..//misc//world_3//level5.xml", mimeType="application/octet-stream")]
		private var l5:Class;
		
		[Embed(source="..//misc//world_3//level6.xml", mimeType="application/octet-stream")]
		private var l6:Class;
		
		[Embed(source="..//misc//world_3//level7.xml", mimeType="application/octet-stream")]
		private var l7:Class;
		
		[Embed(source="..//misc//world_3//level8.xml", mimeType="application/octet-stream")]
		private var l8:Class;
		
		[Embed(source="..//misc//world_3//level9.xml", mimeType="application/octet-stream")]
		private var l9:Class;
		
		[Embed(source="..//misc//world_3//level10.xml", mimeType="application/octet-stream")]
		private var l10:Class;
		
		[Embed(source="..//misc//world_3//level11.xml", mimeType="application/octet-stream")]
		private var l11:Class;
		
	}
	
}
