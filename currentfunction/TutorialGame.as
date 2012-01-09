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
		public var clvl:Number = 1;
		public var currentGame:GameEngine;
		public var switchsong:Boolean;
		
		public var buttonarray:Array = new Array;
		
		public var thisnametext:String;
		public var thisworld:Number;
		private var selectorguy:Guy = new Guy(0,0);
		
		public var maxlvl:Number;
		
		public function TutorialGame(main:JumpDieCreateMain) {
			if (!thisnametext) {
				thisnametext = "World 1";
				thisworld = 1;
			}
			
			makeLevelArray();
			this.main = main;
			this.main.addChild(this);
			getsave();
			selectorguy.x = 114;
			selectorguy.y = 159;
			levelSelect();
		}
		
		public function getsave() {
			trace("world 1");
			this.maxlvl = main.localdata.data.world1;
			trace("maxlvl:"+this.maxlvl);
		}
		
		private function makeKbListeners() {
			this.main.cstage.addEventListener(KeyboardEvent.KEY_UP, kblmanager);
			this.main.cstage.focus = this.stage;
		}
		
		private function kblmanager(e:KeyboardEvent) {
			if (e.keyCode == Keyboard.UP) {
				clvl--;
				if (clvl == 0) {
					clvl = -1;
				} else if (clvl < -1) {
					clvl = 11;
				}
				if (clvl > maxlvl) {
					clvl = maxlvl;
				}
				moveclvl();
			} else if (e.keyCode == Keyboard.DOWN) {
				clvl++;
				if (clvl > 11) {
					clvl = -1;
				} else if (clvl == 0) {
					clvl = 1;
				}
				if (clvl > maxlvl) {
					clvl = -1;
				}
				moveclvl();
			} else if (e.keyCode == Keyboard.SPACE) {
				if (clvl == -1) {
					destroy();
				} else {
					playGame();
				}
			}
		}
		
		private function moveclvl() {
			var tar:LevelSelectButton;
			for each(var b:LevelSelectButton in this.buttonarray) {
				if (b.clvl == this.clvl) {
					tar = b;
					break;
				}
			}
			selectorguy.x = (tar).x - 26;
			selectorguy.y = (tar).y;
		}
		
		public function levelSelect() {
			this.addChild(new JumpDieCreateMenu.t1c as Bitmap);
			this.addChild(JumpDieCreateMenu.getTextBubble());
			var nametext:TextField = LevelSelectButton.makeLevelSelectText(215,131,this.thisnametext);
			nametext.setTextFormat(JumpDieCreateMain.getTextFormat(16));
			this.addChild(nametext);
			
			for (var i = 1; i <= 11; i++) {
				var container:LevelSelectButton;
				if (i <= 5) {
					container = new LevelSelectButton(146-6,159+28*(i-1),i);
				} else if (i <= 10) {
					container = new LevelSelectButton(146+116+6,159+28*(i-1-5),i);
				} else {
					container = new LevelSelectButton(168,303,i);
				}
				
				this.buttonarray.push(container);
				this.addChild(container);
				
				if (container.clvl > this.maxlvl) {
					container.alpha = 0.3;
					continue;
				}
				
				container.addEventListener(MouseEvent.CLICK,function(e:Event){
					if (e.target is TextField) {
						return;
					}
					clvl = e.target.buttonmaster.clvl;
					playGame();
				});
				
				container.addEventListener(MouseEvent.MOUSE_OVER,function(e:Event) {
					if (e.target is TextField) {
						return;
					}
					clvl = e.target.buttonmaster.clvl;
					moveclvl();
				});
								   
				
			}
			
			var backbutton:LevelSelectButton = new LevelSelectButton(227,349,-1);
			backbutton.removeChild(backbutton.text);
			backbutton.addChild(new GameEngine.mb2 as Bitmap);
			this.addChild(backbutton);
			
			backbutton.addEventListener(MouseEvent.CLICK, function() {
				destroy();
			});
			
			backbutton.addEventListener(MouseEvent.MOUSE_OVER, function(e:Event) {
				clvl = -1;
				moveclvl();
			});
			
			this.buttonarray.push(backbutton);
			
			this.addChild(selectorguy);
			makeKbListeners();
		}
				
		public function playGame() {
			this.main.cstage.removeEventListener(KeyboardEvent.KEY_UP, kblmanager);
			numDeath = 0;
			starttime = new Date();
			switchsong = true;
			main.removeChild(this);
			main.stop();
			startLevel();
		}
		
		public override function startLevel() {
			if (clvl >= levels.length) {
				/*clvl = 1;
				main.addChild(this);
				makeKbListeners();
				main.stop();
				main.playSpecific(JumpDieCreateMain.MENU_MUSIC);*/
				destroy();
				return;
			}
			currentGame = null;
			if (switchsong) {
				getsong();
				switchsong = false;
			}
			var noskip:Boolean = this.clvl < this.maxlvl;
			currentGame = new GameEngine(main,this,levels[clvl],levels[clvl].@name,false,this.thisworld,noskip);
		}
		
		public function getsong() {
			if (clvl == 11) {
				main.playSpecific(JumpDieCreateMain.BOSSSONG);
			} else {
				main.playSpecific(JumpDieCreateMain.SONG1);
			}
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
				
				//save progress
				if (thisworld == 1) { 
					main.localdata.data.world1 = Math.max(this.clvl+1,main.localdata.data.world1);
					trace("written to world 1:"+main.localdata.data.world1);
				} else if (thisworld == 2) {
					main.localdata.data.world2 = Math.max(this.clvl+1,main.localdata.data.world2);
					trace("written to world 2:"+main.localdata.data.world2);
				} else if (thisworld == 3) {
					main.localdata.data.world3 = Math.max(this.clvl+1,main.localdata.data.world3);
					trace("written to world 3:"+main.localdata.data.world3);
				}
				
				//save best time
				var stostr:String = thisworld+"-"+this.clvl;
				if (main.localdata.data[stostr]) {
					main.localdata.data[stostr] = Math.min(main.localdata.data[stostr],sectotal);
				} else {
					main.localdata.data[stostr] = sectotal;
				}
				main.localdata.flush();
				trace("best time for("+stostr+"):"+main.localdata.data[stostr]);
				
				
				
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
				playWinSound();
				main.stage.addEventListener(KeyboardEvent.KEY_UP, winscreencontinue);
				main.stage.focus = main.stage;
				return;
			} else {
				loadNextLevel();
			}
		}
		
		public function playWinSound() {
				if (clvl == 11) {
					main.playSpecific(JumpDieCreateMain.BOSSENDSONG,false);
				} else {
					main.playSpecific(JumpDieCreateMain.SONG1END,false);
				}
			
		}
		
		function winscreencontinue(e:KeyboardEvent){
			if (e.keyCode == Keyboard.SPACE) {
				while(main.numChildren > 0) {
					main.removeChildAt(0);
				}
				main.stage.removeEventListener(KeyboardEvent.KEY_UP, winscreencontinue);
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
			while(main.numChildren > 0) {
				main.removeChildAt(0);
			}
			this.main.cstage.removeEventListener(KeyboardEvent.KEY_UP, kblmanager);
			main.curfunction = null;
			this.currentGame = null;
			this.levels = null;
			main.stop();
			main.curfunction = new JumpDieCreateMenu(main);
		}
		
		public function makeLevelArray() {
			levels = new Array();
			levels.push(new XML);
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
		
		public static function getXML(input:Object) : XML {
   			var ba:ByteArrayAsset = ByteArrayAsset(input);
   			var xml:XML = new XML( ba.readUTFBytes( ba.length ) );
   			return xml;    
		}
				
		[Embed(source="..//misc//world_1//level1.xml", mimeType="application/octet-stream")]
		private var l1:Class;
		
		[Embed(source="..//misc//world_1//level2.xml", mimeType="application/octet-stream")]
		private var l2:Class;
		
		[Embed(source="..//misc//world_1//level3.xml", mimeType="application/octet-stream")]
		private var l3:Class;
		
		[Embed(source="..//misc//world_1//level4.xml", mimeType="application/octet-stream")]
		private var l4:Class;
		
		[Embed(source="..//misc//world_1//level5.xml", mimeType="application/octet-stream")]
		private var l5:Class;
		
		[Embed(source="..//misc//world_1//level6.xml", mimeType="application/octet-stream")]
		private var l6:Class;
		
		[Embed(source="..//misc//world_1//level7.xml", mimeType="application/octet-stream")]
		private var l7:Class;
		
		[Embed(source="..//misc//world_1//level8.xml", mimeType="application/octet-stream")]
		private var l8:Class;
		
		[Embed(source="..//misc//world_1//level9.xml", mimeType="application/octet-stream")]
		private var l9:Class;
		
		[Embed(source="..//misc//world_1//level10.xml", mimeType="application/octet-stream")]
		private var l10:Class;
		
		[Embed(source="..//misc//world_1//level11.xml", mimeType="application/octet-stream")]
		private var l11:Class;
		
	}
	
}
