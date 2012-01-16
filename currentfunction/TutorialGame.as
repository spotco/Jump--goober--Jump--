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
		
		private var besttimebubble:Sprite = new Sprite;
		private var text:TextField = new TextField;
		private var textbubblepic:Bitmap;
		
		
		public function TutorialGame(main:JumpDieCreateMain) {
			if (!thisnametext) {
				thisnametext = "World 1";
				thisworld = 1;
			}
			
			text.embedFonts = true;
            text.antiAliasType = AntiAliasType.ADVANCED;
			text.text = "best time lol??";
			text.wordWrap = true;
			text.selectable=false;
			text.setTextFormat(JumpDieCreateMain.getTextFormat(10));
			textbubblepic = new Textdisplay.t2 as Bitmap;
			textbubblepic.scaleX = -0.7;
			textbubblepic.scaleY = 0.8;
			besttimebubble.addChild(textbubblepic);
			besttimebubble.addChild(text);
			text.width = textbubblepic.width;
			text.height = textbubblepic.height;
			text.x = -84;
			text.y = 3;
			besttimebubble.visible = false;
			selectorguy.addChild(besttimebubble);
			
			makeLevelArray();
			this.main = main;
			this.main.addChild(this);
			getsave();
			selectorguy.x = 114;
			selectorguy.y = 159;
			levelSelect();
			
			if (this.maxlvl >= 12) {
				trace("World complete!");
				var wc:TextField = LevelSelectButton.makeLevelSelectText(20,15,"World Complete!");
				wc.setTextFormat(JumpDieCreateMain.getTextFormat(60,2));
				this.addChild(wc);
			}
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
		
		public function moveclvl() {
			var tar:LevelSelectButton;
			for each(var b:LevelSelectButton in this.buttonarray) {
				if (b.clvl == this.clvl) {
					tar = b;
					break;
				}
			}
			if (clvl >= 6 && clvl <= 10) {
				selectorguy.x = (tar).x - 26+125;
				selectorguy.y = (tar).y;
				
				textbubblepic.scaleX = 0.7;
				this.besttimebubble.x = 20;
				this.besttimebubble.y = -50;
				text.x = 10;
			} else {
				selectorguy.x = (tar).x - 26;
				selectorguy.y = (tar).y;
				textbubblepic.scaleX = -0.7;
				this.besttimebubble.x = 0;
				this.besttimebubble.y = -50;
				text.x = -100;
				
			}
			
			var stostr:String = this.thisworld+"-"+this.clvl;
			if (main.localdata.data[stostr]) {
				this.text.text = "Best time:\n"+main.localdata.data[stostr];
				text.setTextFormat(JumpDieCreateMain.getTextFormat(10));
				this.besttimebubble.visible = true;
			} else {
				this.besttimebubble.visible = false;
			}
		}
		
		public function getScrollingBg():Bitmap {
			return new GameEngine.bg1 as Bitmap;
		}
		
		public function levelSelect() {
			//this.addChild(new JumpDieCreateMenu.t1c as Bitmap);
			var scrollingBg:Bitmap = getScrollingBg();
			scrollingBg.y = -1050;
			var scrolltimer:Timer = new Timer(40);
			scrolltimer.addEventListener(TimerEvent.TIMER, function() {
				if (scrollingBg.stage == null) {
					scrolltimer.stop();
				}
				scrollingBg.y+=1;
				if (scrollingBg.y >= 0) {
					scrollingBg.y = -1050;
				}
			});
			scrolltimer.start();
			this.addChild(scrollingBg);
			this.addChild(new transbg as Bitmap);
			
			var bgmenu:Bitmap = JumpDieCreateMenu.getTextBubble();
			bgmenu.alpha = 0.7;
			this.addChild(bgmenu);
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
			
			moveclvl();
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
				main.stop();
				var complt:Sprite = new Sprite;
				var compltbg:Bitmap;
				if (this.thisworld == 1) {
					compltbg = new TutorialGame.complete1 as Bitmap;
				} else if (this.thisworld == 2) {
					compltbg = new TutorialGame.complete2 as Bitmap;
				} else if (this.thisworld == 3) {
					compltbg = new TutorialGame.complete3 as Bitmap;
				}
				
				
				var f:Function = function(e:KeyboardEvent) {
					if (e.keyCode == Keyboard.SPACE) {
						main.stage.removeEventListener(KeyboardEvent.KEY_UP, f);
						if (thisworld == 3) {
							credits();
						} else {
							destroy();
						}
					}
				}
				var wait:Timer = new Timer(400);
				wait.addEventListener(TimerEvent.TIMER,function() {
					main.stage.addEventListener(KeyboardEvent.KEY_UP, f);
					wait.stop();
				});
				wait.start();
				
				var wc:TextField = LevelSelectButton.makeLevelSelectText(60,470,"World "+this.thisworld+" complete!");
				wc.setTextFormat(JumpDieCreateMain.getTextFormat(45,2));
				
				
				var wcd:TextField = LevelSelectButton.makeLevelSelectText(wc.x+wc.width,wc.y+30,"(Press space to continue)");
				wcd.setTextFormat(JumpDieCreateMain.getTextFormat(10));
				wcd.x -= wcd.width;
				
				
				var textbg:Sprite = new Sprite;
				textbg.graphics.beginFill(0xFFFFFF,0.5);
				textbg.graphics.drawRect(wc.x,wc.y+10,wc.width,wc.height+wcd.height);
				
				complt.addChild(compltbg);
				complt.addChild(textbg);
				complt.addChild(wc);
				complt.addChild(wcd);
				main.addChild(complt);
				
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
		
		public function credits() {
			trace("credits");
			while(main.numChildren > 0) {
				main.removeChildAt(0);
			}
			var creditslist:Bitmap = (new TutorialGame.creditslist as Bitmap);
			creditslist.y = 0;
			creditslist.alpha = 0;
			main.addChild(new JumpDieCreateMenu.t1c as Bitmap);
			main.addChild(creditslist);
			main.addChild(new transbg as Bitmap);
			
			var wcd:TextField = LevelSelectButton.makeLevelSelectText(0,0,"(Press space to skip)");
			wcd.setTextFormat(JumpDieCreateMain.getTextFormat(10));
			wcd.x = 500-wcd.width;
			wcd.y = 520-wcd.height;
			main.addChild(wcd);
			
			var t:Timer = new Timer(50);
			var f:Function =  function(e:KeyboardEvent) {
				if (e.keyCode == Keyboard.SPACE) {
					creditslist.y = -1950;
				}
			}
			
			main.playSpecific(JumpDieCreateMain.ONLINE);
			t.addEventListener(TimerEvent.TIMER, function(){
				if (creditslist.y > -100 && creditslist.alpha < 1) {
					creditslist.alpha+=0.025;
				} else if (creditslist.y > -1950) {
					creditslist.y-=3;
				} else if (creditslist.alpha > 0) {
					creditslist.alpha-=0.010;
				} else {
					t.stop();
					main.stage.removeEventListener(KeyboardEvent.KEY_UP,f);
					destroy();
				}
			});
			main.stage.addEventListener(KeyboardEvent.KEY_UP,f);
			t.start();
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
				var msectotal:Number = endtime.time - starttime.time;
				trace("timeSec:"+sectotal);
				var displaytime:String = Math.floor(sectotal/60) + ":";
				if (sectotal%60 < 10) {
					displaytime += "0"+(sectotal%60);
				} else {
					displaytime += (sectotal%60);
				}
				var msdisplaytimecalc:Number = (((msectotal%1000)/1000)*1000/1000)*1000;
				if (msdisplaytimecalc < 10) {
					displaytime += ":00"+msdisplaytimecalc;
				} else if (msdisplaytimecalc < 100) {
					displaytime += ":0"+msdisplaytimecalc;
				} else {
					displaytime += ":"+msdisplaytimecalc;
				}
				
				trace("numDeath:"+numDeath);
				
				/*msectotal = msectotal/1000 + ((msectotal%1000)/1000);
				msectotal = Math.round(msectotal*1000)/1000;

				trace("timeMS:"+msectotal);*/
				
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
					//main.localdata.data[stostr] = Math.min(main.localdata.data[stostr],msectotal);
					var saveddat:Array = main.localdata.data[stostr].split(":");
					var savedsum:Number = 0;
					for (var i = 0; i < saveddat.length; i++) {
						if (i == 0) {
							savedsum+=(60000*Number(saveddat[i]));
						} else if (i == 1) {
							savedsum+=(1000*Number(saveddat[i]));
						} else if (i == 2) {
							savedsum+=(Number(saveddat[i]));
						} else {
							trace("saved data parsing error!!!");
						}
					}
					if (saveddat.length != 3) {
						savedsum = msectotal+1;
					}
					trace("saved:"+savedsum);
					trace("new:"+msectotal);
					if (savedsum > msectotal) {
						trace("new record");
						main.localdata.data[stostr] = displaytime;
					}
				} else {
					//main.localdata.data[stostr] = msectotal;
					main.localdata.data[stostr] = displaytime;
				}
				main.localdata.flush();
				trace("best time for("+stostr+"):"+main.localdata.data[stostr]);
				
				
				
				main.addChild(JumpDieCreateMenu.titlebg);
				main.addChild(JumpDieCreateMenu.getTextBubble());
				
				var displaytext:TextField = new TextField; 
				displaytext.embedFonts = true;
            	displaytext.antiAliasType = AntiAliasType.ADVANCED;
				displaytext.selectable = false;
				displaytext.text = "  Time: "+displaytime+"\n    Deaths: "+numDeath;
				displaytext.x = 140; 
				displaytext.y = 225; 
				displaytext.width = 230; displaytext.height = 400;
				displaytext.defaultTextFormat = JumpDieCreateMain.getTextFormat(20);
				displaytext.setTextFormat(JumpDieCreateMain.getTextFormat(20));
				main.addChild(displaytext);
				
				var displayflash:Timer = new Timer(1000);
				var haslistener:Boolean = false;
				displayflash.addEventListener(TimerEvent.TIMER, function(){
						if (!displaytext.wordWrap) {
							displaytext.text = "  Time: "+displaytime+"\n    Deaths: "+numDeath+"\n\n    Press Space\n    to Continue";
						} else {
							displaytext.text = "  Time: "+displaytime+"\n    Deaths: "+numDeath;
						}
						displaytext.wordWrap = !displaytext.wordWrap;
						if (displaytext.stage == null) {
							displayflash.stop();
						}
						if (!haslistener) {
							haslistener = true;
							main.stage.addEventListener(KeyboardEvent.KEY_UP, winscreencontinue);
							main.stage.focus = main.stage;
						}
				  });
				displayflash.start();
				
				var winanim:WinAnimation = new WinAnimation();
				winanim.x = 140; winanim.y = 140;
				main.addChild(winanim);
				winanim.start();
				main.stop();
				playWinSound();
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
			//main.stop();
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

		[Embed(source='..//img//misc//transparentmenu.png')]
		private static var transbg:Class;
		
		[Embed(source='..//img//misc//creditslist.png')]
		private static var creditslist:Class;
		
		[Embed(source='..//img//misc//complete1.png')]
		public static var complete1:Class;
		
		[Embed(source='..//img//misc//complete2.png')]
		public static var complete2:Class;
		
		[Embed(source='..//img//misc//complete3.png')]
		public static var complete3:Class;
				
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
