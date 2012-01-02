package currentfunction {
    import flash.display.*;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import flash.utils.Timer;
    import flash.events.*;
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
		
		var loadingmessagedisplay:TextField;
		
		var error:Boolean = false;
		var die:Boolean = false;
		var dietimer:Timer;
		
		var startsong:Boolean = true;
		
		public function RandomOnlineGame(main:JumpDieCreateMain) {
			this.main = main;
			makeloadbg();
			getNewLevel();
		}
		
		public function getNewLevel() {
			dietimer = new Timer(100);
			dietimer.addEventListener(TimerEvent.TIMER,function(){
									  		if(die) {
												destroy();
											}
									  });
			dietimer.start();
			
			var urlRequest:URLRequest = new URLRequest('http://spotcos.com/jumpdiecreate/dbscripts/getrandomid.php');
			urlRequest.data = makeUrlVars();
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, idRecieved);
			urlLoader.load(urlRequest);
			configureErrors(urlLoader);
		}
		
		public function idRecieved(evt:Event) {
			var urlRequest:URLRequest = new URLRequest('http://spotcos.com/jumpdiecreate/dbscripts/getbyid.php');
			var vars:URLVariables = makeUrlVars();
			vars.id = evt.target.data;
			urlRequest.data = vars;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, newLevelRecieved);
			configureErrors(urlLoader);
			urlLoader.load(urlRequest);
		}
		
		public function newLevelRecieved(evt:Event) {
			currentlevelxml = new XML(evt.target.data);
			trace("level data recieved, starting game");
			startLevel();
		}
		
		public override function startLevel() {
			var nom:String = currentlevelxml.@name;
			if (startsong) {
				main.playSpecific(JumpDieCreateMain.ONLINE);
				startsong = false;
			}
			currentGame = new GameEngine(main,this,currentlevelxml,nom,false);
		}
		
		public override function nextLevel(hitgoal:Boolean) {
			//main.playSpecific(JumpDieCreateMain.ONLINEEND);
			dietimer.stop();
			makeloadbg();
			startsong = true;
			getNewLevel();
		}
		
		private function configureErrors(dispatcher:IEventDispatcher) {
			dispatcher.addEventListener(NetStatusEvent.NET_STATUS, errorhandle);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorhandle);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR,errorhandle);
		}
		
		private function errorhandle(e:Event) {
			error = true;
			loadingmessagedisplay.x = 145; loadingmessagedisplay.y = 140;
			loadingmessagedisplay.setTextFormat(JumpDieCreateMain.getTextFormat(10));
			loadingmessagedisplay.defaultTextFormat = JumpDieCreateMain.getTextFormat(10);
			loadingmessagedisplay.textColor = 0xFF0000;
			loadingmessagedisplay.text = "Network error: "+e;
		}		
		
		public override function destroy() {
			if (currentGame != null || error) {
				while(main.numChildren > 0) {
					main.removeChildAt(0);
				}
				main.stop();
				if (currentGame != null) {
					currentGame.clear();
				}
				dietimer.stop();
				main.curfunction = new JumpDieCreateMenu(main);
			}
		}
		
		private function makeloadbg() {
			var bg:Sprite = new Sprite;
			bg.addChild(JumpDieCreateMenu.titlebg);
			var spbubble:Bitmap = JumpDieCreateMenu.getTextBubble();
			bg.addChild(spbubble);
			var backbutton:Sprite = new Sprite;
			bg.addChild(backbutton);
			loadingmessagedisplay = SubmitMenu.maketextdisplay(200,230,"Loading...",20,200,250);
			bg.addChild(loadingmessagedisplay);			
			
			var backbutton:Sprite = new Sprite;
			backbutton.addChild(GameEngine.backbuttonimg);
			backbutton.y = 503;
			backbutton.addEventListener(MouseEvent.CLICK,function() {
											die = true;
										});
			bg.addChild(backbutton);
			
			main.addChild(bg);
		}
		
		public static function makeUrlVars():URLVariables {
			var v:URLVariables = new URLVariables;
			v.nocache = new Date().getTime(); 
			return v;
		}

	}
	
}
