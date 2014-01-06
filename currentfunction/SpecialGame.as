package currentfunction {
	import flash.display.*;
	import flash.xml.*;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	import flash.text.*;
	import flash.utils.*;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class SpecialGame extends CurrentFunction {
		
		var currentgame:GameEngine;
		var main:JumpDieCreateMain;
		var clvl:Number = 1;
		var lvl_select_options:Object = new Object;
		var cursor:Guy = new Guy(-100,-100);
		
		public function SpecialGame(main:JumpDieCreateMain) {
			this.main = main;
			make_level_select();
			main.addChild(this);
			main.stage.addEventListener(KeyboardEvent.KEY_UP, kbl_press);
			moveclvl();
		}
		
		private function kbl_press(e:KeyboardEvent) {
			if (e.keyCode == Keyboard.UP) {
				clvl--;
				if (clvl < 1) {
					clvl = 4;
				}
				moveclvl();
			} else if (e.keyCode == Keyboard.DOWN) {
				clvl++;
				if (clvl > 4) {
					clvl = 1;
				}
				moveclvl();
			} else if (e.keyCode == Keyboard.SPACE) {
				main.stage.removeEventListener(KeyboardEvent.KEY_UP, kbl_press);
				if (clvl == 4) {
					destroy();
				} else {
					start_game(clvl);
				}
			}
		}
		
		private function make_level_select() {
			var scrollingBg:Bitmap = new GameEngine.bg1 as Bitmap;
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
			this.addChild(new TutorialGame.transbg as Bitmap);
			
			var bgmenu:Bitmap = JumpDieCreateMenu.getTextBubble();
			bgmenu.alpha = 0.7;
			this.addChild(bgmenu);
			
			var nametext:TextField = LevelSelectButton.makeLevelSelectText(175,131,"Challenge Levels");
			nametext.setTextFormat(JumpDieCreateMain.getTextFormat(16));
			this.addChild(nametext);
			
			this.addChild(cursor);
			
			for (var i = 1; i < 4; i++) {
				var test:LevelSelectButton = new LevelSelectButton(185,165+28*(i-1),i);
				test.text.text = "Challenge "+i;
				this.addChild(test);
				lvl_select_options[i] = test;
				test.addEventListener(MouseEvent.ROLL_OVER, function(e:Event) {
					if (!(e.target is LevelSelectButton)) {
						return;
					}
					clvl = e.target.clvl;
					moveclvl();
				  });
				test.addEventListener(MouseEvent.CLICK, function(e:Event) {
					start_game(clvl);
				  });
			}
			
			var backbutton:LevelSelectButton = new LevelSelectButton(227,349,4);
			backbutton.removeChild(backbutton.text);
			backbutton.addChild(new GameEngine.mb2 as Bitmap);
			this.addChild(backbutton);
			JumpDieCreateMain.add_mouse_over(backbutton);
			lvl_select_options[4] = backbutton;
			
			backbutton.addEventListener(MouseEvent.CLICK, function() {
				destroy();
			});
			
			backbutton.addEventListener(MouseEvent.ROLL_OVER, function(e:Event) {
				clvl = 4;
				moveclvl();
			});
		}
		
		private function moveclvl() {
			cursor.x = lvl_select_options[clvl].x-26;
			cursor.y = lvl_select_options[clvl].y;
		}
		
		var xml:XML;
		private function start_game(clvl:Number) {
			main.stage.removeEventListener(KeyboardEvent.KEY_UP, kbl_press);
			if (this.currentgame != null) {
				return;
			}
			if (clvl == 1) {
				xml = new XML(new l2);
			} else if (clvl == 2) {
				xml = new XML(new l3);
			} else if (clvl == 3) {
				xml = new XML(new l4);
			}
			main.playSpecific(JumpDieCreateMain.BOSSSONG);
			startLevel();
		}
		
		var deathcount:Number = -1;
		
		public override function startLevel() {
			deathcount++;
			currentgame = new GameEngine(main,this,xml,xml.@name,false,-1,false,deathcount);
		}
		
		public override function nextLevel(hitgoal:Boolean) {
			if (hitgoal) {
				win_screen();
			} else {
				destroy();
			}
			
		}
		
		private function win_screen() {
				var displaytime:String = GameEngine.gettimet(currentgame.game_time);
				main.addChild(new JumpDieCreateMenu.t1c as Bitmap);
				var bub:Bitmap = JumpDieCreateMenu.getTextBubble();
				bub.alpha = 0.7;
				main.addChild(bub);
				
				var wc:TextField = LevelSelectButton.makeLevelSelectText(20,15,"Level Complete!");
				wc.setTextFormat(JumpDieCreateMain.getTextFormat(60,2));
				main.addChild(wc);
				
				var displaytext:TextField = new TextField; 
				displaytext.embedFonts = true;
            	displaytext.antiAliasType = AntiAliasType.ADVANCED;
				displaytext.selectable = false;
				displaytext.text = "Time: "+displaytime+"\nDeaths: "+deathcount;
				displaytext.x = 127; 
				displaytext.y = 210; 
				displaytext.width = 230; displaytext.height = 400;
				var tf:TextFormat = JumpDieCreateMain.getTextFormat(17);
				tf.align = "center";
				displaytext.defaultTextFormat = tf;
				displaytext.setTextFormat(tf);
				
				main.addChild(displaytext);
				
				var displayflash:Timer = new Timer(1000);
				var haslistener:Boolean = false;
				displayflash.addEventListener(TimerEvent.TIMER, function(){
						if (!displaytext.wordWrap) {
							displaytext.text = "Time: "+displaytime+"\nDeaths: "+deathcount+"\n\nPress Space\nto Continue";
						} else {
							displaytext.text = "Time: "+displaytime+"\nDeaths: "+deathcount;
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
				main.addChild(new Fireworks);
		}
		
		function winscreencontinue(e:KeyboardEvent){
			if (e.keyCode == Keyboard.SPACE) {
				JumpDieCreateMain.clearDisplay(main);
				main.stage.removeEventListener(KeyboardEvent.KEY_UP, winscreencontinue);
				destroy();
			}
		}
		
		private function playWinSound() {
			main.playSpecific(JumpDieCreateMain.BOSSENDSONG,false);
		}
		
		public override function destroy() {
			main.stage.removeEventListener(KeyboardEvent.KEY_UP, kbl_press);
			this.currentgame = null;
			if (this.stage != null) {
				main.removeChild(this);
			}
			while(main.numChildren != 0) {
				main.removeChildAt(0);
			}
			this.main.curfunction = new JumpDieCreateMenu(main);
		}
		
		[Embed(source="..//misc//challenge//Challenge1.xml", mimeType="application/octet-stream")]
		private var l2:Class;
		
		[Embed(source="..//misc//challenge//Challenge2.xml", mimeType="application/octet-stream")]
		private var l3:Class;
		
		[Embed(source="..//misc//challenge//Challenge3.xml", mimeType="application/octet-stream")]
		private var l4:Class;

	}
	
}
