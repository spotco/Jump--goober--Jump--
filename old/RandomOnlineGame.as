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
	import flash.media.Sound;
		import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class RandomOnlineGame extends CurrentFunction {
		var main:JumpDieCreateMain;
		var currentGame:GameEngine;
		var switchsong:Boolean;
		var currentlevelxml:XML;
		
		public function RandomOnlineGame(main:JumpDieCreateMain) {
			this.main = main;
			switchsong = true;
			getNewLevel();
		}
		
		public function getNewLevel() {
			var urlRequest:URLRequest = new URLRequest('getrandom.php');
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, newLevelRecieved);
			urlLoader.load(urlRequest);
		}
		
		public function newLevelRecieved(evt:Event) {
			currentlevelxml = new XML(evt.target.data);
			//var confirmsave:TextWindow = new TextWindow(currentlevelxml.toXMLString(),this,function(){trace("lol");});
			//main.addChild(confirmsave);
			startLevel();
		}
		
		public override function startLevel() {
			var nom:String = currentlevelxml.@name;
			if (switchsong) {
				switchsong = false;
				main.playRandom();
			}
			currentGame = new GameEngine(main,this,currentlevelxml,nom);
		}
		
		public override function nextLevel(hitgoal:Boolean) {
			switchsong = true;
			getNewLevel();
		}
		
		public override function destroy() {
			main.curfunction = null;
			this.currentGame = null;
			main.stop();
			main.curfunction = new JumpDieCreateMenu(main);
		}

	}
	
}
