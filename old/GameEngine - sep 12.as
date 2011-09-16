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
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
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
		public var testguy:Guy; //player, dunno why it's called testguy (another old jump or die thing?)
		
		public var timer:Timer;
		public var leveldisplay:TextField;
		public var storekey:Array;
		public var jumpUnpressed:Boolean;
		
		[Embed(source='..//img//block//bgtest.png')]
		private var bg1:Class;
		private var bg:Bitmap; //the current only background, the pink forest
		var bgcounter:Number = 0;
		
		var usebackbutton:Boolean;
		//loads and creates game given xml file, adds self to main param
		public function GameEngine(main:JumpDieCreateMain,curfunction:CurrentFunction,clvlxml:XML,name:String, usebackbutton:Boolean = false) {
			trace("gameengine start");
			this.usebackbutton = usebackbutton;
			
			bg = new bg1();
			//TODO -- make this variable with other backgrounds
			bg.y = -1800;
			bg.x = -(Math.random()*290);
			main.addChild(bg);
			
			
			displayname = name;
			this.curfunction = curfunction;
			this.main = main;
			loadfromXML(clvlxml); //loads and adds all blocks to stage
			
			makeui();
			//makes player then adds eventlisteners
			testguy = new Guy(250,250);
			main.addChild(testguy);
			storekey = new Array();
			jumpUnpressed = true;
			main.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			main.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			main.stage.focus = main.stage;
			timer = new Timer(30); //start update cycle
            timer.addEventListener(TimerEvent.TIMER, update);
            timer.start();
		}
		
		public function loadfromXML(clvlxml:XML) { //loads and adds blocks from xml, called from constructor
			deathwall = new Array();
			boostlist = new Array();
			walls = new Array();
			goals = new Array();
			textdisplays = new Array();
			boostfruits = new Array();
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
		}
		
		var menubutton:Sprite; //wrappers for the ui buttons on bot-right
		var skipbutton:Sprite;
		
		public function makeui() { //makes game ui, called in constructor
			menubutton = new Sprite;
			menubutton.addChild(menubuttonimg);
			menubutton.x = 458; menubutton.y = 503;
			main.addChild(menubutton);
			menubutton.addEventListener(MouseEvent.CLICK,function(){clear();curfunction.destroy();});
			
			skipbutton = new Sprite;
			if (usebackbutton) {
				skipbutton.addChild(backbuttonimg);
			} else {
				skipbutton.addChild(skipbuttonimg);
			}
			skipbutton.x = 410; skipbutton.y = 503;
			main.addChild(skipbutton);
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
		}
		
		private var justWallJumped:Boolean = false;
		//START GAME ENGINE CODE
		public function update(e:TimerEvent) { //main update cycle
			leveldisplay.text = displayname;
			inputStackMove(); //moves testguy based on top key in input stack
			gameScroll(); //scrolls all the current blocks and player
			testguy.update(walls,justWallJumped); //loops through walls and checks collision, also updates player position based on velocity (not smart, I know)
			justWallJumped = false;
			if (checkOffScreenDeath()) { //check if has fallen offscreen
				return;
			}
			
			for (var i = 0; i < walls.length; i++) {
				clearAbove(walls[i]);
				clearBelow(walls[i],walls,i);
			}
			for (var i = 0; i < deathwall.length; i++) { //loops through deathwalls, if hit starts death animation then reloads
				if (testguy.hitTestObject(deathwall[i])) {
					timer.stop();
					testguy.explode();
					timer = new Timer(1200,1);
					timer.start();
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(){reload();});
					return;
				}
				clearAbove(deathwall[i]);
				clearBelow(deathwall[i],deathwall,i);
			}
			
			for (var i = 0; i < boostlist.length; i++) { //loops through boost and adds velocity
				boostlist[i].updateAnimation();
				if (testguy.hitTestObject(boostlist[i])) {
					if (testguy.vy > -20) {
						testguy.vy -= 3;
						//testguy.vy = -20;
					}
					testguy.canJump = true;
					testguy.jumpCounter+=4;
				}
				clearAbove(boostlist[i]);
				clearBelow(boostlist[i],boostlist,i);
			}
			
			for (var i = 0; i < textdisplays.length; i++) { //loops through and animates textbugs
				textdisplays[i].update(testguy);
				if (textdisplays[i].stage != null) {
					main.setChildIndex(textdisplays[i],main.numChildren-1);
				}
				clearAbove(textdisplays[i]);
				clearBelow(textdisplays[i],textdisplays,i);
			}
			
			for (var i = 0; i < goals.length; i++) { //loops through goals and checks collision, loads next level if yes
				goals[i].update();
				if (testguy.hitTestObject(goals[i])) {
					timer.stop();
					loadnextlevel(true); //HIT GOAL EXIT
					return;
				}
				clearAbove(goals[i]);
				clearBelow(goals[i],goals,i);
			}
			
			for (var i = 0; i < boostfruits.length; i++) {
				boostfruits[i].update(this);
				if (boostfruits[i].ready && testguy.hitTestObject(boostfruits[i].hitbox)) {
					testguy.boost = 3;
					testguy.canJump = true;
					boostfruits[i].eat(this);
				}
			}
			main.setChildIndex(leveldisplayimg,main.numChildren-1);
			main.setChildIndex(leveldisplay,main.numChildren-1);
			main.setChildIndex(menubutton,main.numChildren-1);
			main.setChildIndex(skipbutton,main.numChildren-1);
			main.setChildIndex(testguy,main.numChildren-1);
			
		}
		
		//memory saving mathods, dunno why they have to be >='s (if not they break :( )
		public function clearAbove(b:BaseBlock) {
			if (b.y <= -500 && b.stage != null) {
				main.removeChild(b);
			} else if (b.y >= -500 && b.y <= 1000 && b.stage == null) {
				main.addChild(b);
			}
		}
		
		public function clearBelow(b:BaseBlock,a:Array,i:Number) { //dont show blocks far above, remove blocks far below
			if(b.y >= 1000) {
				main.removeChild(b);
				a.splice(i,1);
			}
		}
		
		private function checkOffScreenDeath() : Boolean { //checks if fallen offscreen
			if (testguy.y > 490 || testguy.x < -25 || testguy.x > 525 || testguy.y < -300) {
				timer.stop();
				reload(); //offscreen
				return true;
			}
			return false;
		}
		
		
		private function gameScroll() { //scrolls all blocks and player if player is certain height, a lot of wizardry here
			//speed of scrolling based on distance between player and scrolling start point
			var SCROLL_SPD = Guy.roundDec((250 - testguy.y)/9,1);
			if (testguy.y < 250) {
				bgcounter++;
				if(bgcounter > 0 && bg.y < -1 && Math.abs(testguy.vy) >= 3) {
					bg.y+=(SCROLL_SPD/3);
					bgcounter = 0;
				}
				
				var blocksarrays:Array = new Array(walls,goals,deathwall,boostlist,textdisplays,boostfruits);
				for each (var a:Array in blocksarrays) {
					for each (var b:BaseBlock in a) {
						b.y+=SCROLL_SPD;
					}
				}
				testguy.y +=SCROLL_SPD;
				
			}
		}
		
		private function onKeyPress(e:KeyboardEvent):void { //keydown, add the pressed key to top of keystack
			if (storekey.indexOf(e.keyCode) != -1) {
				storekey.splice(storekey.indexOf(e.keyCode),1);
			}
			if (e.keyCode != Keyboard.SPACE ) {
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
			if (e.keyCode == Keyboard.SPACE) {
				jumpUnpressed = true;
			}
		}
		
		private function inputStackMove() { //move based on top key in keystack
			var topkey = storekey[storekey.length-1];
			if (storekey.length > 0) {
				if (topkey == Keyboard.LEFT) {
					if (testguy.vx < -4) {
						testguy.vx+=1;
					} else if (testguy.vx > 4)  {
						testguy.vx-=1;
					} else {
						testguy.vx = -4;
					}
				} else if (topkey == Keyboard.RIGHT) {
					if (testguy.vx < -4) {
						testguy.vx+=1;
					} else if (testguy.vx > 4)  {
						testguy.vx-=1;
					} else {
               			testguy.vx = 4;
					}
				} else if (topkey == Keyboard.SPACE && ( (testguy.canJump && testguy.hashitwall)||testguy.boost > 0)) {
					if (testguy.boost > 0) {
						testguy.boost--;
					}
					storekey.pop();
					testguy.jumpCounter++;
					testguy.vy = -15;
					if(/*!testguy.isslide &&*/ testguy.boost == 0) {
					testguy.canJump = false;
					}
					if(testguy.isslide) {
						testguy.vx = 10;
						justWallJumped = true;
					}
				}
			}
		}
		//END GAME ENGINE CODE
		
		
		private function reload() { //callback to curfunction, should reload game
			clear();
			curfunction.numDeath++;
			curfunction.startLevel();
		}
		
		private function loadnextlevel(hitgoal:Boolean) { //callback to curfunction, next
			clear();
			curfunction.nextLevel(hitgoal);
		}
		
		private function clear() { //clears all from stage and removes keylisteners, called when player dies or otherwise ending game
			trace("gameengine end");
			while(main.numChildren > 0) {
    			main.removeChildAt(0);
			}
			timer.stop();
			main.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			main.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		[Embed(source='..//img//button//menu.png')]
		private var mb1:Class;
		private var menubuttonimg:Bitmap = new mb1;
		
		[Embed(source='..//img//button//back.png')]
		public static var mb2:Class;
		public static var backbuttonimg:Bitmap = new mb2;
		
		[Embed(source='..//img//button//skip.png')]
		private var mb3:Class;
		private var skipbuttonimg:Bitmap = new mb3;
		
		[Embed(source='..//img//button//leveldisplay.png')]
		private var mb4:Class;
		private var leveldisplayimg:Bitmap = new mb4;

	}
	
}
