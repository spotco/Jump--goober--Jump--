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
	import flash.system.*;
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
		
		var currentlevelinfo:Object;
		
		var error:Boolean = false;
		var die:Boolean = false;
		var dietimer:Timer;
		
		var numdeath = -1;
		
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
			var urlRequest:URLRequest = new URLRequest(JumpDieCreateMain.ONLINE_DB_URL+'getrandomid.php');
			urlRequest.data = makeUrlVars();
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, idRecieved);
			urlLoader.load(urlRequest);
			configureErrors(urlLoader);
		}
		
		public function idRecieved(evt:Event) {
			if (die) {
				return;
			}
			
			var tarxml:XML = (new XML(evt.target.data)).level[0];
			
			currentlevelinfo = new Object;
			currentlevelinfo.id = tarxml.@id;
			currentlevelinfo.creator_name = tarxml.@creator_name;
			currentlevelinfo.level_name = tarxml.@level_name;
			currentlevelinfo.date_created = tarxml.@date_created;
			
			currentlevelinfo.playcount = tarxml.@playcount;
			currentlevelinfo.ratingavg = tarxml.@ratingavg;
			currentlevelinfo.ratingcount = tarxml.@ratingcount;
			
			/*trace("LEVEL_NAME: "+currentlevelinfo.level_name);
			trace("CREATOR_NAME: "+currentlevelinfo.creator_name);
			trace("DATE_CREATED: "+currentlevelinfo.date_created);*/
			
			var urlRequest:URLRequest = new URLRequest(JumpDieCreateMain.ONLINE_DB_URL+'getbyid.php');
			var vars:URLVariables = makeUrlVars();
			vars.id = currentlevelinfo.id;
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
			if (die) {
				return;
			}
			var nom:String = currentlevelxml.@name;
			if (startsong) {
				main.playSpecific(JumpDieCreateMain.ONLINE);
				startsong = false;
			}
			numdeath++;
			currentGame = new GameEngine(main,this,currentlevelxml,nom,false,-1,true,numdeath);
		}
		
		public override function nextLevel(hitgoal:Boolean) {
			numdeath = -1;
			if (hitgoal) {
				new ReviewSubmitMenu(this,processNext,main,currentlevelinfo);
			} else {
				processNext();
			}
		}
		
		public function processNext() {
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
			die = true;
			JumpDieCreateMain.clearDisplay(main);
			main.stop();
			dietimer.stop();
			main.curfunction = new JumpDieCreateMenu(main);
			System.disposeXML(this.currentlevelxml);
			this.currentGame = null;
			this.main = null;
			this.dietimer = null;
			this.currentlevelinfo = null;
		}
		
		private function makeloadbg() {
			var bg:Sprite = new Sprite;
			bg.addChild(new JumpDieCreateMenu.t1c as Bitmap);
			var spbubble:Bitmap = JumpDieCreateMenu.getTextBubble();
			spbubble.alpha = 0.8;
			bg.addChild(spbubble);
			var backbutton:Sprite = new Sprite;
			bg.addChild(backbutton);
			loadingmessagedisplay = SubmitMenu.maketextdisplay(200,230,"Loading...",20,200,250);
			bg.addChild(loadingmessagedisplay);			
			
			var backbutton:Sprite = new Sprite;
			backbutton.addChild(GameEngine.backbuttonimg);
			backbutton.y = 503;
			backbutton.addEventListener(MouseEvent.CLICK,function() {
											destroy();
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
