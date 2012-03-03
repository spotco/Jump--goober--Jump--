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
	import flash.text.engine.SpaceJustifier;
	import flash.sampler.NewObjectSample;
	import flash.system.System;
	
	public class BrowseMostPlayedGame extends CurrentFunction {
		var currentgame:GameEngine;
		var clvlxml:XML;
		var thislevelinfo:Object;
		
		var main:JumpDieCreateMain;
		var bg:Sprite;
		var loadingdisplay:TextField;
		var browsedisplay:Sprite = new Sprite;
		
		var currentoffset:Number = 0;
		var cxml:XML;
		var selectionarray:Array;
		
		var startsong = true;
		
		var KILL = false;
		
		var numdeath = -1;
		
		public function BrowseMostPlayedGame(main:JumpDieCreateMain,noload:Boolean = false) {
			this.main = main;
			initbg();
			if (!noload) {
				loaddisplay();
			}
		}
		
		public function loaddisplay() {
			browsedisplay.visible = false;
			loadingdisplay.visible = true;
			
			if (browsedisplay.stage != null) {
				main.removeChild(browsedisplay);
			}
			
			var urlRequest:URLRequest = new URLRequest(this.getXMLListURL());
			var vars:URLVariables = new URLVariables;
			vars.nocache = new Date().getTime(); 
			vars.offset = currentoffset;
			vars = addURLParam(vars);
			urlRequest.data = vars;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, makexmldisplay);
			configureErrors(urlLoader);
			urlLoader.load(urlRequest);
		}
		
		public function addURLParam(a:URLVariables):URLVariables {
			return a;
		}
		
		public function getXMLListURL():String {
			return JumpDieCreateMain.ONLINE_DB_URL+'getmostplayed.php';
		}
		
		public function getSelectionDisplayMode():Boolean {
			return false;
		}
		
		private function makexmldisplay(e:Event) {
			if (cxml != null) {
				System.disposeXML(cxml);
			}
			if (this.KILL || this.main.curfunction != this) {
				trace("kill in makexmldisplay");
				return;
			}
			cxml = new XML(e.target.data);
			browsedisplay = new Sprite;
			this.selectionarray = new Array;
			loadingdisplay.visible = false;
			var i = 0;
			for each (var s:XML in cxml.level) {
				var info = new Object;
				info.id = s.@id;
				info.level_name = s.@level_name;
				info.creator_name = s.@creator_name;
				info.ratingavg = s.@ratingavg;
				info.ratingcount = s.@ratingcount;
				info.playcount = s.@playcount;
				info.date_created = s.@date_created;
				var o:OnlineBrowseSelection = new OnlineBrowseSelection(90,25+65*i,info,this.getSelectionDisplayMode());
				browsedisplay.addChild(o);
				i++;
				o.addEventListener(MouseEvent.ROLL_OVER, function(e) {
					bdispclr();
					e.target.draw(0.2);
				});
				this.selectionarray.push(o);
				o.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
					if (KILL) {
						return;
					}
					KILL = true;
					loadwithid(e.currentTarget.info);   
				});
			}
			main.addChild(browsedisplay);
			
			var prevbutton:Sprite = new Sprite;
			prevbutton.addChild(new prev as Bitmap);
			prevbutton.x = 93;
			prevbutton.y = 356;
			prevbutton.addEventListener(MouseEvent.CLICK, function() {
				currentoffset-=5; 
				loaddisplay();
			});
			if (currentoffset > 0) {
				browsedisplay.addChild(prevbutton);
			}
			
			var nextbutton:Sprite = new Sprite;
			nextbutton.addChild(new next as Bitmap);
			nextbutton.x = 400;
			nextbutton.y = 356;
			nextbutton.addEventListener(MouseEvent.CLICK, function() {
				currentoffset+=5; 
				loaddisplay();
			});
			JumpDieCreateMain.add_mouse_over(nextbutton);
			JumpDieCreateMain.add_mouse_over(prevbutton);
			if (i >= 5) {
				browsedisplay.addChild(nextbutton);
			}
			
			var pagedisp:TextField = SubmitMenu.maketextdisplay(228,358,"Page "+(this.currentoffset/5),12,100,30);
			browsedisplay.addChild(pagedisp);
		}
		
		private function loadwithid(info:Object) {
			this.thislevelinfo = info;
			var urlRequest:URLRequest = new URLRequest(JumpDieCreateMain.ONLINE_DB_URL+'/getbyid.php');
			var vars:URLVariables = new URLVariables;
			vars.nocache = new Date().getTime(); 
			vars.id = info.id;
			urlRequest.data = vars;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, newLevelRecieved);
			this.KILL = false;
			configureErrors(urlLoader);
			urlLoader.load(urlRequest);
			if (this.browsedisplay.stage != null) {
				main.removeChild(this.browsedisplay);
			}
			loadingdisplay.visible = true;
		}
		
		private function newLevelRecieved(e:Event) {
			if (this.KILL || this.main.curfunction != this) {
				trace("kill in newLevelRecieved");
				return;
			}
			if (clvlxml != null) {
				System.disposeXML(clvlxml);
			}
			this.clvlxml = new XML(e.target.data);
			if (this.browsedisplay.stage != null) {
				main.removeChild(this.browsedisplay);
			}
			if (this.loadingdisplay.stage != null) {
				main.removeChild(this.loadingdisplay);
			}
			if (this.bg.stage != null) {
				main.removeChild(this.bg);
			}
			KILL = false;
			startLevel();
		}
		
		public override function startLevel() {
			if (startsong) {
				main.playSpecific(JumpDieCreateMain.ONLINE);
				startsong = false;
			}
			this.numdeath++;
			this.currentgame = new GameEngine(this.main,this,this.clvlxml,this.clvlxml.@name,true,-1,true,numdeath);
		}
		
		public override function nextLevel(hitgoal:Boolean) {
			startsong = true;
			numdeath = -1;
			if (hitgoal) {
				new ReviewSubmitMenu(this,remakeUI,main,this.thislevelinfo);
			} else {
				remakeUI();
			}
		}
		
		private function remakeUI() {
			JumpDieCreateMain.clearDisplay(main);
			
			main.playSpecific(JumpDieCreateMain.MENU_MUSIC);
			main.addChild(this.bg);
			main.addChild(this.browsedisplay);
			main.addChild(this.loadingdisplay);
			loaddisplay();
		}
		
		private function bdispclr() {
			for each (var t:OnlineBrowseSelection in this.selectionarray) {
				t.graphics.clear();
				t.draw(0);
			}
		}
		
		private function configureErrors(dispatcher:IEventDispatcher) {
			dispatcher.addEventListener(NetStatusEvent.NET_STATUS, errorhandle);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorhandle);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR,errorhandle);
		}
		
		private function errorhandle(e:Event) {
			try {
				browsedisplay.visible = false;
				loadingdisplay.visible = true;
				loadingdisplay.x = 145; loadingdisplay.y = 140;
				loadingdisplay.setTextFormat(JumpDieCreateMain.getTextFormat(10));
				loadingdisplay.defaultTextFormat = JumpDieCreateMain.getTextFormat(10);
				loadingdisplay.textColor = 0xFF0000;
				loadingdisplay.text = "Network error: "+e+"\nPlease try again.";
			} catch (er:Error) {
				trace(e);
				trace(er);
			}
		}
		
		public function initbg() {
			bg = new Sprite;
			bg.addChild(new JumpDieCreateMenu.t1c as Bitmap);
			var spbubble:Bitmap = JumpDieCreateMenu.getTextBubble();
			spbubble.alpha = 0.8;
			spbubble.scaleX = 1.4;
			spbubble.scaleY = 1.4;
			spbubble.x = 50;
			spbubble.y = 12;
			bg.addChild(spbubble);
			var backbutton:Sprite = new Sprite;
			bg.addChild(backbutton);		
			backbutton.addChild(new GameEngine.mb2 as Bitmap);
			backbutton.y = 503;
			backbutton.addEventListener(MouseEvent.CLICK,function() {
											destroy();
										});
			bg.addChild(backbutton);
			JumpDieCreateMain.add_mouse_over(backbutton);
			main.addChild(bg);
			
			loadingdisplay = SubmitMenu.maketextdisplay(200,100,"Loading...",20,200,250);
			main.addChild(loadingdisplay);
		}
		
		public override function destroy() {
			flash.system.System.disposeXML(this.cxml);
			flash.system.System.disposeXML(this.clvlxml);
			JumpDieCreateMain.clearDisplay(main);
			JumpDieCreateMain.clearDisplay(bg);
			JumpDieCreateMain.clearDisplay(this.browsedisplay);
			this.selectionarray = null;
			this.bg = null;
			this.browsedisplay = null;
			main.curfunction = new JumpDieCreateMenu(main);
			this.KILL = true;
		}
		
				[Embed(source='..//img//button//next.png')]
		public static var next:Class;
		
				[Embed(source='..//img//button//prev.png')]
		public static var prev:Class;

	}
	
}
