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
	
	public class TypeNameGame extends CurrentFunction {
		var main:JumpDieCreateMain;
		var currentGame:GameEngine;
		var menuprompt:TextWindow;
		var currentlevelxml:XML;
		
		public function TypeNameGame(main:JumpDieCreateMain) {
			this.main = main;
			menuprompt = new TextWindow("",this,function(){});
			promptnew();
		}
		
		public function promptnew() {
			if (menuprompt.parent == main) {
				main.removeChild(menuprompt);
			}
			menuprompt = new TextWindow("Enter the name of the level you would like to play.",this,function(){getNewLevel(menuprompt.entryfield.text)});
			main.addChild(menuprompt);
		}
		
		public function getNewLevel(name:String) {
			var urlRequest:URLRequest = new URLRequest('getspecific.php?name='+name);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, checkValid);
			urlLoader.load(urlRequest);
		}
		
		public function checkValid(evt:Event) {
			main.removeChild(menuprompt);
			menuprompt = new TextWindow("",this,function(){});
			if (evt.target.data == "ERROR00") {
				menuprompt.yesnobox("Invalid request. Retry?",function(){promptnew();},function(){destroy();});
				main.addChild(menuprompt);
			} else if (evt.target.data == "ERROR01") {
				menuprompt.yesnobox("Level not found. Retry?",function(){promptnew();},function(){destroy();});
				main.addChild(menuprompt);
			} else {
				newLevelRecieved(evt);
			}
		}
		
		public function newLevelRecieved(evt:Event) {
			currentlevelxml = new XML(evt.target.data);
			startLevel();
		}
		
		public override function startLevel() {
			var nom:String = currentlevelxml.@name;
			currentGame = new GameEngine(main,this,currentlevelxml,nom);
		}
		
		public override function nextLevel(hitgoal:Boolean) {
			promptnew();
		}
		
		public override function destroy() {
			main.curfunction = null;
			this.currentGame = null;
			main.curfunction = new JumpDieCreateMenu(main);
		}

	}
	
}
