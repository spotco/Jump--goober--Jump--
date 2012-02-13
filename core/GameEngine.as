package core {
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
	import flash.text.*;
	import flash.system.*;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	import flash.media.SoundTransform;
	import flash.utils.getTimer;
	
	public class GameEngine {
		public var displayname:String;
		public var curfunction:CurrentFunction; //current "mode" of the game, specifies certain callback functions like nextLevel, reload and destroy
		public var main:JumpDieCreateMain;
		
		//Game object arrays, cycle through each of them individually (yeah, probably shoulda done this more polymorphically...)
		public var deathwall:Array;
		public var boostlist:Array;
		public var textdisplays:Array;
		public var walls:Array;
		public var goals:Array;
		public var boostfruits:Array;
		public var tracks:Array;
		public var particles:Array;
		
		public var particlesreuse:Array;
		public var rocketparticlesreuse:Array;
		public var bulletsreuse:Array;
		
		public var testguy:Guy; //player, dunno why it's called testguy (another old jump or die thing?)
		
		public var timer:Timer;
		public var leveldisplay:TextField;
		public var storekey:Array;
		public var jumpUnpressed:Boolean;
		
		public var currenty:Number = 0;
		
		private var blocksarrays:Array;
		
		public var bg:Bitmap; //the current background
		var bgcounter:Number = 0;
		
		private var hasskip:Boolean;
		
		private var deathcount:Number;
		private var pause:Boolean = false;
		
		public var game_time:Number = 0;
		var prev_time:Number;
		
		var usebackbutton:Boolean;
		
		//loads and creates game given xml file, adds self to main param
		public function GameEngine(main:JumpDieCreateMain,curfunction:CurrentFunction,clvlxml:XML,name:String, usebackbutton:Boolean = false, useBg:Number = -1, hasskip:Boolean = true, deathcount:Number = 0) {
			trace("gameengine start");
			this.deathcount = deathcount;
			this.usebackbutton = usebackbutton;
			if (useBg == 1 || Number(clvlxml.@bg) == 1) {
				bg = new bg1();
			} else if (useBg == 2 || Number(clvlxml.@bg) == 2) {
				bg = new bg2();
			} else if (useBg == 3 || Number(clvlxml.@bg) == 3) {
				bg = new bg3();
			} else {
				bg = new bg1();
			}
			bg.y = -940;
			main.addChild(bg);
			
			this.hasskip = hasskip;
			
			displayname = name;
			this.curfunction = curfunction;
			this.main = main;
			loadfromXML(clvlxml); //loads and adds all blocks to stage
			
			makeui();
			leveldisplay.text = displayname;
			//makes player then adds eventlisteners
			testguy = new Guy(250,250);
			main.addChild(testguy);
			storekey = new Array();
			jumpUnpressed = true;
			
			blocksarrays = new Array(walls,goals,deathwall,boostlist,textdisplays,boostfruits,tracks,particles);
			
			main.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			main.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			main.stage.focus = main.stage;
			timer = new Timer(30); //start update cycle
            timer.addEventListener(TimerEvent.TIMER,update,false,100,false);
			prev_time = flash.utils.getTimer();
            timer.start();
			
		}
		
		public function loadfromXML(clvlxml:XML) { //loads and adds blocks from xml, called from constructor
			deathwall = new Array();
			boostlist = new Array();
			walls = new Array();
			goals = new Array();
			textdisplays = new Array();
			boostfruits = new Array();
			tracks = new Array();
			particles = new Array();
			
			this.particlesreuse = new Array();
			this.rocketparticlesreuse = new Array();
			this.bulletsreuse = new Array();
			
			for each (var node:XML in clvlxml.boost) {
				var boosk:Boost = new Boost(node.@x,node.@y,node.@width,node.@height);
				boostlist.push(boosk);
				main.addChild(boosk);
			}
			for each (var node:XML in clvlxml.deathwall) {
				var testfallblock:FalldownBlock = new FalldownBlock(node.@x,node.@y,node.@width,node.@height);
				deathwall.push(testfallblock);
				main.addChild(testfallblock);
			}
			for each (var node:XML in clvlxml.wall) {
				var testwall:Wall = new Wall(node.@x,node.@y,node.@width,node.@height);
				walls.push(testwall);
				main.addChild(testwall);
			}
			for each (var node:XML in clvlxml.goal) {
				var sto:Goal = new Goal(node.@x,node.@y,node.@width,node.@height);
				goals.push(sto);
				main.addChild(sto);
			}
			for each (var node:XML in clvlxml.textfield) {
				var newtext:Textdisplay = new Textdisplay(node.@x,node.@y,node.@text);
				newtext.text.selectable = false;
				textdisplays.push(newtext);
				main.addChild(newtext);
			}
			for each (var node:XML in clvlxml.boostfruit) {
				var newboostfruit:BoostFruit = new BoostFruit(node.@x,node.@y);
				boostfruits.push(newboostfruit);
				main.addChild(newboostfruit);
			}
			for each (var node:XML in clvlxml.trackwall) {
				var newtrackwall:Wall = new TrackWall(node.@x,node.@y,node.@width,node.@height);
				walls.push(newtrackwall);
				main.addChild(newtrackwall);
			}
			for each (var node:XML in clvlxml.trackblade) {
				var newtrackblade:FalldownBlock = new TrackBlade(node.@x,node.@y);
				deathwall.push(newtrackblade);
				main.addChild(newtrackblade);
			}
			for each (var node:XML in clvlxml.activatetrackwall) {
				var activatenewtrackwall:Wall = new ActivateTrackWall(node.@x,node.@y,node.@width,node.@height);
				walls.push(activatenewtrackwall);
				main.addChild(activatenewtrackwall);
			}
			for each (var node:XML in clvlxml.flowerboss) {
				var newFlowerBoss:FlowerBoss = new FlowerBoss(node.@y);
				deathwall.push(newFlowerBoss);
				main.addChild(newFlowerBoss);
			}
			for each (var node:XML in clvlxml.track) {
				var newtrack:Track = new Track(node.@x,node.@y,node.@width,node.@height);
				tracks.push(newtrack);
				main.addChild(newtrack);
			}
			for each (var node:XML in clvlxml.cloudboss) {
				var newCloudBoss:CloudBoss = new CloudBoss();
				deathwall.push(newCloudBoss);
				main.addChild(newCloudBoss);
			}
			for each (var node:XML in clvlxml.rocketlauncher) {
				var newLauncher:RocketLauncher = new RocketLauncher(node.@x,node.@y);
				deathwall.push(newLauncher);
				main.addChild(newLauncher);
			}
			for each (var node:XML in clvlxml.laserlauncher) {
				var newLLauncher:LaserLauncher = new LaserLauncher(node.@x,node.@y,node.@dir);
				deathwall.push(newLLauncher);
				main.addChild(newLLauncher);
			}
			for each (var node:XML in clvlxml.rocketboss) {
				var rboss:RocketBoss = new RocketBoss(node.@x,node.@y);
				deathwall.push(rboss);
				main.addChild(rboss);
			}
			for each (var node:XML in clvlxml.bossactivate) {
				var bactv:BossActivate = new BossActivate(node.@x,node.@y,node.@width,node.@height,node.@hp,node.@explode);
				particles.push(bactv);
				main.addChild(bactv);
			}
			
		}
		
		var menubutton:Sprite; //wrappers for the ui buttons on bot-right
		var mutebutton:Sprite;
		var skipbutton:Sprite;
		var pausebutton:Sprite;
		var pausedcover:Sprite = new Sprite;
		var toprighttext:TextField;
		
		public function makeui() { //makes game ui, called in constructor
			toprighttext = SubmitMenu.maketextdisplay(380,0,"TIME: 00:00:00\n"+"DEATHS:0",12,120,60);
			var tf:TextFormat = toprighttext.getTextFormat();
			tf.align = TextFormatAlign.RIGHT;
			toprighttext.setTextFormat(tf);
			toprighttext.defaultTextFormat = tf;
			main.addChild(toprighttext);
			/*SubmitMenu.maketextdisplay(0,490,"SPOTCO(www.spotcos.com)\nMUSIC BY(www.openheartsound.com)",12,500,60);*/
			
			menubutton = new Sprite;
			menubutton.addChild(menubuttonimg);
			menubutton.x = 458; menubutton.y = 503;
			main.addChild(menubutton);
			menubutton.addEventListener(MouseEvent.CLICK,function(){clear();curfunction.destroy();});
			
			
			pausebutton = new Sprite;
			pausebutton.addChild(pausebuttonimg);
			pausebutton.addChild(unpausebuttonimg);
			unpausebuttonimg.visible = false;
			pausebutton.x = 362; pausebutton.y = 503;
			pausebutton.addEventListener(MouseEvent.CLICK,function(){pausebuttonaction();});
			main.addChild(pausebutton);
			
			pausedcover.graphics.beginFill(0x000000,0.5);
			pausedcover.graphics.drawRect(0,0,500,520);
			var s:TextField = SubmitMenu.maketextdisplay(0,0,"PAUSED",14,500,500);
			s.textColor = 0xFFFFFF;
			pausedcover.addChild(s);
			pausedcover.visible = false;
			main.addChild(pausedcover);
			
			skipbutton = new Sprite;
			if (usebackbutton) {
				skipbutton.addChild(backbuttonimg);
			} else {
				skipbutton.addChild(skipbuttonimg);
			}
			skipbutton.x = 270; skipbutton.y = 503;
			skipbutton.addEventListener(MouseEvent.CLICK,function(){loadnextlevel(false);});
			
			leveldisplayimg.x = -10; leveldisplayimg.y = 503; 
			main.addChild(leveldisplayimg);

            leveldisplay = new TextField();
			leveldisplay.embedFonts = true;
            leveldisplay.antiAliasType = AntiAliasType.ADVANCED;
            leveldisplay.x = 2; leveldisplay.y = 504;
            leveldisplay.width = 200;
			leveldisplay.selectable = false;
			leveldisplay.text = "LOADING...";
			leveldisplay.setTextFormat(JumpDieCreateMain.getTextFormat(10));
			leveldisplay.defaultTextFormat = JumpDieCreateMain.getTextFormat(10);
            main.addChild(leveldisplay);
			
			mutebutton = new Sprite;
			mutebutton.addChild(this.soundonbuttonimg);
			mutebutton.addChild(this.soundoffbuttonimg);
			mutebutton.x = 410;
			mutebutton.y = 503;
			mutebutton.addEventListener(MouseEvent.CLICK, function() {
				mutebuttonaction();
			});
			main.addChild(mutebutton);
			
			var size:Number = 45;
			
			mutebuttonvisual();
			
			
			menubutton.x = 503-size*1;
			skipbutton.x = 503-size*4;
			mutebutton.x = 503-size*2;
			pausebutton.x = 503-size*3;
			
			if (this.hasskip) {
				main.addChild(skipbutton);
			}

			if (this.usebackbutton) {
				skipbutton.x = 503-size*2;
				mutebutton.x = 503-size*3;
				pausebutton.x = 503-size*4;
			}
			
			
		}
		
		public var kill = false;
		private function pausebuttonaction() {
			if (kill) {
				return;
			}
			pause = !pause;
			pausebuttonvisual();
		}
		
		private function pausebuttonvisual() {
			if (this.pause) {
				this.pausebuttonimg.visible = false;
				this.unpausebuttonimg.visible = true;
				this.pausedcover.visible = true;
				main.playsfx(JumpDieCreateMain.pausesound,new SoundTransform(0.1));
			} else {
				this.pausebuttonimg.visible = true;
				this.unpausebuttonimg.visible = false;
				this.pausedcover.visible = false;
				main.playsfx(JumpDieCreateMain.unpausesound,new SoundTransform(0.1));
			}
		}
		
		private function mutebuttonvisual() {
			if (main.mute) {
				this.soundoffbuttonimg.visible = true;
			} else {
				this.soundoffbuttonimg.visible = false;
			}
		}
		
		private function mutebuttonaction() {
			main.mute = !main.mute;
			mutebuttonvisual();
			var st:SoundTransform;
			if (soundTransformStack.length == 0) {
				st = new SoundTransform;
			} else {
				st = soundTransformStack.pop();
			}
			
			if (main.mute) {
				st.volume = 0;
			} else {
				st.volume = 1;
			}
			
			soundTransformStack.push(main.sc.soundTransform);
			main.sc.soundTransform = st;
		}
		
		var soundTransformStack:Array = new Array;
		private function soundfadein() {
			//trace(main.sc.soundTransform.volume);
			if (main.sc.soundTransform.volume < 1 && !main.mute) {
				soundTransformStack.push(main.sc.soundTransform);
				var nsct:SoundTransform ;
				if (soundTransformStack.length == 0) {
					nsct = new SoundTransform();
				} else {
					nsct = soundTransformStack.pop();
				}
				nsct.volume = main.sc.soundTransform.volume + 0.03;
				main.sc.soundTransform = nsct;
			}
		}
		
		public static function gettimet(n:Number):String {
			var min:Number = Math.floor(n/(60*1000));
			var displaytime:String = ""+min+":";
			var sectotal:Number = Math.floor(n/1000);
			if (sectotal%60 < 10) {
				displaytime += "0"+(sectotal%60);
			} else {
				displaytime += (sectotal%60);
			}
			var msectotal:Number = n;
			var msdisplaytimecalc:Number = (((msectotal%1000)/1000)*1000/1000)*1000;
			if (msdisplaytimecalc < 10) {
				displaytime += ":00"+msdisplaytimecalc;
			} else if (msdisplaytimecalc < 100) {
				displaytime += ":0"+msdisplaytimecalc;
			} else {
				displaytime += ":"+msdisplaytimecalc;
			}
			return displaytime;
		}
		
		private var justWallJumped:Boolean = false;

		//START GAME ENGINE CODE
		public function update(e:TimerEvent) { //main update cycle
			soundfadein();
			var ct:Number = flash.utils.getTimer();
			if (pause) {
				prev_time = ct;
				return;
			}
			
			game_time += ct - prev_time;
			prev_time = ct;
			
			toprighttext.text = "TIME: "+gettimet(game_time)+"\n"+"DEATHS:"+this.deathcount;
			
			inputStackMove(); //moves testguy based on top key in input stack
			
			justWallJumped = false;
			if (checkOffScreenDeath()) { //check if has fallen offscreen
				return;
			}
			testguy.update(walls,justWallJumped); //loops through walls and checks collision, also updates player position based on velocity (not smart, I know)
			
			for each(var a:Array in blocksarrays) {
				for each(var b:BaseBlock in a) {
					if (!b.activated) {
						continue;
					}
					if (b.y > -500 && b.y < 1000) {
						if (b.update(this)) {
							return;
						}
					} else if (b.y <= -500) {
						b.simpleupdate(this);
					}
					clearAbove(b);
					clearBelow(b,a,a.indexOf(b));
				}
			}
			
			gameScroll(); //scrolls all the current blocks and player
			moveUiToFront();
		}
		
		public function moveUiToFront() {
			for each (var b:FalldownBlock in deathwall) {
				if (b is FlowerBoss || b is Bullet || b is CloudBoss || b is RocketBoss) {
					main.setChildIndex(b,main.numChildren-1);
				}
			}
			main.setChildIndex(this.pausedcover,main.numChildren-1);
			main.setChildIndex(testguy,main.numChildren-1);
			main.setChildIndex(this.toprighttext,main.numChildren-1);
			main.setChildIndex(leveldisplayimg,main.numChildren-1);
			main.setChildIndex(leveldisplay,main.numChildren-1);
			main.setChildIndex(menubutton,main.numChildren-1);
			main.setChildIndex(pausebutton,main.numChildren-1);
			if (this.mutebutton.stage != null) {
				main.setChildIndex(this.mutebutton,main.numChildren-1);
			}
			if (skipbutton.stage != null) {
				main.setChildIndex(skipbutton,main.numChildren-1);
			}
			
		}
		
		//memory saving mathods, dunno why they have to be >='s (if not they break :( )
		public function clearAbove(b:BaseBlock) {
			if (b.y <= -500 && b.stage != null) {
				main.removeChild(b);
				b.memRemoved = true;
				b.visible = false;
			} else if (b.y >= -500 && b.y <= 1000 && b.stage == null && b.memRemoved) {
				main.addChild(b);
				b.memRemoved = false;
				b.visible = true;
			}
		}
		
		public function clearBelow(b:BaseBlock,a:Array,i:Number) { //dont show blocks far above, remove blocks far below
			if(b.y >= 1000 && b.stage != null) {
				main.removeChild(b);
				a.splice(i,1);
				b.visible = false;
			}
		}
		
		private function checkOffScreenDeath() : Boolean { //checks if fallen offscreen
			//if (testguy.y > 490 || testguy.x < -25 || testguy.x > 525 || testguy.y < -300) {
			
			if (testguy.x < -25 || testguy.x > 525 || testguy.y > 505 || testguy.y < -300) {
				this.main.playsfx(JumpDieCreateMain.fallsound,null);
				timer.stop();
				reload(); //offscreen
				return true;
			}
			return false;
		}
		
		
		private function gameScroll() { //scrolls all blocks and player if player is certain height, a lot of wizardry here
			//speed of scrolling based on distance between player and scrolling start point
			var SCROLL_SPD = Guy.roundDec((250 - testguy.y)/9,1);
			/*if (SCROLL_SPD < 0.5) {
				return;
			}*/
			if (testguy.y < 250) {
				bgcounter++;
				if(bgcounter > 0 && bg.y < -1 /*&& Math.abs(testguy.vy) >= 3*/) {
					bg.y+=(SCROLL_SPD/3);
					bgcounter = 0;
				}
				
				for each (var a:Array in blocksarrays) {
					for each (var b:BaseBlock in a) {
						b.gameScroll(SCROLL_SPD);
						//b.y+=SCROLL_SPD;
					}
				}
				testguy.y +=SCROLL_SPD;
				currenty += SCROLL_SPD;
			}
			if (bg.y > 0) {
				bg.y = 0;
			}
		}
		
		private function onKeyPress(e:KeyboardEvent):void { //keydown, add the pressed key to top of keystack
			if (storekey.indexOf(e.keyCode) != -1) {
				storekey.splice(storekey.indexOf(e.keyCode),1);
			}
			if (e.keyCode != Keyboard.SPACE && e.keyCode  != Keyboard.ENTER && e.keyCode  != Keyboard.UP && e.keyCode  != Keyboard.W && e.keyCode  != Keyboard.Z) {
				storekey.push(e.keyCode);
			} else if (jumpUnpressed) {
				jumpUnpressed = false;
				storekey.push(e.keyCode);
			}
			if (e.keyCode == Keyboard.DOWN) {
				testguy.vx = testguy.vx / 1.3;
			}
		}

		private function onKeyUp(e:KeyboardEvent):void { //keyup, remove key from keystack
			if (storekey.indexOf(e.keyCode) != -1) {
				storekey.splice(storekey.indexOf(e.keyCode),1);
			}
			if (e.keyCode == Keyboard.SPACE || e.keyCode  == Keyboard.ENTER || e.keyCode  == Keyboard.UP|| e.keyCode  == Keyboard.W || e.keyCode  == Keyboard.Z) {
				jumpUnpressed = true;
			}
			if (e.keyCode == Keyboard.ESCAPE) {
				pausebuttonaction();
			}
			if (e.keyCode == Keyboard.F1) {
				mutebuttonaction();
			}
		}
		
		private function inputStackMove() { //move based on top key in keystack
			var topkey = storekey[storekey.length-1];
			if (storekey.length > 0) {
				if (topkey == Keyboard.LEFT || topkey == Keyboard.A) {
					if (testguy.vx < -5) {
						//testguy.vx+=1;
					} else if (testguy.vx > 5)  {
						testguy.vx-=1;
					} else {
						testguy.vx = -5;
					}

				} else if (topkey == Keyboard.RIGHT || topkey == Keyboard.D) {

					if (testguy.vx < -5) {
						testguy.vx+=1;
 					} else if (testguy.vx > 5)  {
						//testguy.vx-=1;
					} else {
               			testguy.vx = 5;
					}
				} else if (  (topkey == Keyboard.SPACE || topkey == Keyboard.ENTER || topkey == Keyboard.UP|| topkey == Keyboard.W || topkey == Keyboard.Z) && ( (testguy.canJump && testguy.hashitwall || testguy.justtouched > 0)||testguy.boost > 0)) {
					if (!testguy.jumpavailable) { //cooldown not off, stop
						return;
					} else { //else set cooldown on, set cooldown to time
						testguy.jumpavailable = false;
						testguy.jumpcd = testguy.JUMPCDTIMER;
					}
					if (testguy.boost > 0) { //if boost(boostfruit), subtract boost counter
						testguy.boost--;
					}
					storekey.pop();
					
					testguy.jumpCounter++; //dunno what this is for lol
					testguy.vy = -15;
					
					if(/*!testguy.isslide &&*/ testguy.boost == 0) { //if not boosting, cannot jump until 
					testguy.canJump = false;
					}
					if(testguy.isslide) { //if sliding side of wall, add additional vx
						testguy.vx = 10;
						//if wall is to the right, bounce off and this is to reduce friction-loss for next cycle
						justWallJumped = true;
					}
					playjumpsound();
				}
			}
		}
		//END GAME ENGINE CODE
		
		var soundcount = 1;
		var prevdate:Date = new Date();
		var st:SoundTransform = new SoundTransform(0.5);
		
		private function playjumpsound() {
			//var i:Number = Math.floor((Math.random()*4))+1;
			var curdate:Date = new Date();
			var diftime = curdate.getTime() - prevdate.getTime();
			prevdate = curdate;
			if (diftime < 600) {
				soundcount++;
			} else {
				soundcount = 1;
			}
			var i = soundcount;
			if (i == 1) {
				this.main.playsfx(JumpDieCreateMain.jump1sound,st);
			} else if (i == 2) {
				this.main.playsfx(JumpDieCreateMain.jump2sound,st);
			} else if (i == 3) {
				this.main.playsfx(JumpDieCreateMain.jump3sound,st);
			} else {
				this.main.playsfx(JumpDieCreateMain.jump4sound,st);
			}
							   
		}
		
		
		public function reload() { //callback to curfunction, should reload game
			clear();
			curfunction.numDeath++;
			curfunction.startLevel();
			this.curfunction = null;
		}
		
		public function loadnextlevel(hitgoal:Boolean) { //callback to curfunction, next
			clear();
			curfunction.nextLevel(hitgoal);
		}
		
		public function clear() { //clears all from stage and removes keylisteners, called when player dies or otherwise ending game
			trace("gameengine end");
			JumpDieCreateMain.clearDisplay(main);
			timer.stop();
			main.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			main.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			for (var i = 0; i < this.blocksarrays.length; i++) {
				for (var j = 0; j < this.blocksarrays[i].length; j++) {
					(blocksarrays[i])[j] = null;
				}
				blocksarrays[i] = null;
			}
			this.bg = null;
			this.main = null;
			this.deathwall = null;
			this.boostfruits = null;
			this.boostlist = null;
			this.textdisplays = null;
			this.walls = null;
			this.goals = null;
			this.tracks = null;
			this.particles = null;
			this.timer = null;
			this.leveldisplay = null;
			this.storekey = null;
			this.particlesreuse = null;
			this.rocketparticlesreuse = null;
			this.bulletsreuse = null;
			JumpDieCreateMain.gc();
		}
		
		[Embed(source='..//img//button//menu.png')]
		private var mb1:Class;
		private var menubuttonimg:Bitmap = new mb1;
		
		[Embed(source='..//img//button//back.png')]
		public static var mb2:Class;
		public static var backbuttonimg:Bitmap = new mb2;
		
		[Embed(source='..//img//button//skip.png')]
		public static var mb3:Class;
		private var skipbuttonimg:Bitmap = new mb3;
		
		[Embed(source='..//img//button//soundon.png')]
		public static var mb4:Class;
		private var soundonbuttonimg:Bitmap = new mb4;
		
		[Embed(source='..//img//button//soundoff.png')]
		public static var mb6:Class;
		private var soundoffbuttonimg:Bitmap = new mb6;
		
		[Embed(source='..//img//button//pause.png')]
		public static var mb7:Class;
		private var pausebuttonimg:Bitmap = new mb7;
		
		[Embed(source='..//img//button//unpause.png')]
		public static var mb8:Class;
		private var unpausebuttonimg:Bitmap = new mb8;
		
		[Embed(source='..//img//button//leveldisplay.png')]
		public static var mb5:Class;
		private var leveldisplayimg:Bitmap = new mb5;
		
		[Embed(source='..//img//block//bg1.png')]
		public static var bg1:Class;
		
		[Embed(source='..//img//block//bg2.png')]
		public static var bg2:Class;
		
		[Embed(source='..//img//block//bg3.png')]
		public static var bg3:Class;

	}
	
}
