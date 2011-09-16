﻿package currentfunction {
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
	import mx.core.ByteArrayAsset;
		import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class LevelEditor extends CurrentFunction {
		public var main:JumpDieCreateMain;
		public var playerspawn:Guy;
		public var xmllist:Array; //stores array of string representation of xml at time of creation
		public var currentgame:GameEngine; //test playthrough, started and addchild'd with startlevel()
		
		public var mousePreviewDrawer:Sprite; //draws ghost mouse over when create
		public var mousePreviewAnimateTimer:Timer;
		
		public var rectList:Array; //array of all created blocks, assert that they are all children of main
		public var currenty:Number; //current extra height
		public var keydown:Boolean;
		
		public var cboxx:Number; //x position when mousedown the first time
		public var cboxy:Number; //y position when mousedown
		
		public static var WALL:Number = 0;
		public static var DEATHBLOCK:Number = 1;
		public static var BOOST:Number = 2;
		public static var GOAL:Number = 3;
		public static var TEXT:Number = 4;
		public static var DELETE:Number = 5;
		public static var MOVE:Number = 6;
		public static var BOOSTFRUIT:Number = 7;
		public var currenttype:Number; //0-wall,1-deathbox,2-boost,3-goal,4-text,5-delete,6-move,7-boostfruit
		
		
		public function LevelEditor(main:JumpDieCreateMain) {
			currenttype = 0; 
			main.addChild(this);
			graphics.beginFill(0x000000);
			graphics.drawRect(0,0,500,520);
			graphics.endFill();
			
			graphics.beginFill(0x202020);
			graphics.drawRect(0,500,500,20);
			graphics.endFill();
			
			xmllist = new Array();
			currenty = 0;
			this.main = main;
			main.stop();
			makeui();
			
			playerspawn = new Guy(250,250);
			main.addChild(playerspawn);
			
			rectList = new Array();
			editorKeyListeners();
			
			mousePreviewDrawer = new Sprite;
			main.addChild(mousePreviewDrawer);
			
			//loadFromEmbedXML();
			
			main.playSpecific(JumpDieCreateMain.LEVELEDITOR_MUSIC);
		}
				
		[Embed(source="..//misc//world_1//level3.xml", mimeType="application/octet-stream")]
		public static var loadThis:Class;
		
		
		private function loadFromEmbedXML() {
			var ba:ByteArrayAsset = ByteArrayAsset(new loadThis);
   			var xml:XML = new XML( ba.readUTFBytes( ba.length ));
			loadFromXML(xml);
		}
		
		private function loadFromXML(xml:XML) {
			var list:XMLList = xml.children();
			for each (var e:XML in list) {
				xmllist.push(e.toXMLString());
				var addblock:BaseBlock = null;
				if (e.name() == "wall") {
					addblock = new Wall(e.@x,e.@y,e.@width,e.@height);
				} else if (e.name() == "textfield") {
					addblock = new Textdisplay(e.@x,e.@y,e.@text);
				} else if (e.name() == "deathwall") {
					addblock = new FalldownBlock(e.@x,e.@y,e.@width,e.@height);
				} else if (e.name() == "boost") {
					addblock = new Boost(e.@x,e.@y,e.@width,e.@height);
				} else if (e.name() == "goal") {
					addblock = new Goal(e.@x,e.@y,e.@width,e.@height);
				} else if (e.name() == "boostfruit") {
					addblock = new BoostFruit(e.@x,e.@y);
				}
				rectList.push(addblock);
				main.addChild(addblock);
			}
		}
		
		public function editorKeyListeners() {
			main.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			main.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			main.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			main.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		public function onMouseDown(e:MouseEvent) {
			cboxx = main.stage.mouseX;
			cboxy = main.stage.mouseY;
			ststo = main.stage.mouseY+currenty;
			
			if (currenttype == WALL || currenttype == DEATHBLOCK || currenttype == BOOST || currenttype == GOAL && !keydown) {
				mousePreviewAnimateTimer = new Timer(20);
				mousePreviewAnimateTimer.addEventListener(TimerEvent.TIMER,mousePreviewCreate);
				mousePreviewAnimateTimer.start();
			}
			keydown = true;
			if (currenttype == MOVE) {
				draggingBlock = getTopMouseOverBlock();
				if (draggingBlock != null) {
					mousePreviewAnimateTimer = new Timer(20);
					mousePreviewAnimateTimer.addEventListener(TimerEvent.TIMER,mousePreviewMove);
					mousePreviewAnimateTimer.start();
				}
			}
		}
		
		private var draggingBlock:BaseBlock;
		private var draggingBlockIndex:Number;
		private var draggingBlockOffsetX:Number;
		private var draggingBlockOffsetY:Number;
		private function getTopMouseOverBlock():BaseBlock { //find which block in rectlist to move
			for (var i = rectList.length-1; i >= 0; i--) {
				if (rectList[i].hitTestPoint(main.stage.mouseX,main.stage.mouseY)){
					draggingBlockOffsetX = main.stage.mouseX - rectList[i].x;
					draggingBlockOffsetY = main.stage.mouseY - rectList[i].y;
					draggingBlockIndex = i;
					return rectList[i];
				}
			}
			return null;
		}
		
		private function mousePreviewCreate(e:TimerEvent) { //ghost animator for creating
			mousePreviewDrawer.graphics.clear();
			mousePreviewDrawer.graphics.beginFill(colorByType(currenttype));
			mousePreviewDrawer.graphics.drawRect(cboxx,cboxy,main.stage.mouseX-cboxx,main.stage.mouseY-cboxy);
			mousePreviewDrawer.graphics.endFill();
		}
		
		private function mousePreviewMove(e:TimerEvent) { //ghost animator for moving
			mousePreviewDrawer.graphics.clear();
			mousePreviewDrawer.graphics.beginFill(colorByType(convertToType(draggingBlock.type())));
			mousePreviewDrawer.graphics.drawRect(main.stage.mouseX-draggingBlockOffsetX,main.stage.mouseY-draggingBlockOffsetY,draggingBlock.w,draggingBlock.h);
			mousePreviewDrawer.graphics.endFill();
		}
		
		public function onMouseUp(e:MouseEvent) {
			if (mousePreviewAnimateTimer != null) {
				mousePreviewAnimateTimer.stop();
			}
			mousePreviewDrawer.graphics.clear();
			keydown = false;
			if (hitButtonMessage()) { //if clicking on a button message, stopall
				return;
			}
			if (main.stage.mouseY <= 500) { //not in the bottom ui bar
				if (currenttype==TEXT) { //keep this here, don't care about toothin
					clearlisteners(); 
					var newtextobject:TextWindow = new TextWindow("What text would you like to be displayed?",this,
																  function(){
																	  if (newtextobject.entryfield.text.length > 0) {
																		  var pattern:RegExp = /[\<\>\"\/]/g;
																		  var sanitizedText:String = newtextobject.entryfield.text.replace(pattern,"?");
																		  xmllist.push('<textfield x="'+cboxx+'" y="'+ststo+'" text="'+sanitizedText+'" ></textfield>');
																		  var s:Textdisplay = new Textdisplay(cboxx,cboxy,sanitizedText);
																		  main.addChild(s);
																		  rectList.push(s);
																		  editorKeyListeners();
																		  main.removeChild(newtextobject);
																	  } else {
																		  main.removeChild(newtextobject);
																		  editorKeyListeners();
																	  }
																  });
					main.addChild(newtextobject);
					return;
				}
				if (currenttype==BOOSTFRUIT) {
					var newfruit:BoostFruit = new BoostFruit(cboxx,cboxy);
					xmllist.push('<boostfruit x="'+cboxx+'" y="'+ststo+'"></boostfruit>');
					main.addChild(newfruit);
					rectList.push(newfruit);
				}
				if (currenttype == DELETE) {
					for(var i = 0; i<rectList.length;i++) {
						if (rectList[i].hitTestPoint(main.stage.mouseX,main.stage.mouseY)) {
							main.removeChild(rectList[i]);
							rectList.splice(i,1);
							xmllist.splice(i,1);
							i = 0;
						}
					}
				} else if (currenttype == MOVE) { //moves the stagechild, then edits xml string array
					if (draggingBlock != null) {
						draggingBlock.x = main.stage.mouseX - draggingBlockOffsetX;
						draggingBlock.y = main.stage.mouseY - draggingBlockOffsetY;
						xmllist[draggingBlockIndex] = '<'+draggingBlock.type()+' x="'+draggingBlock.x+'" y="'+(draggingBlock.y+currenty)+'" width="'+draggingBlock.w+'" height="'+draggingBlock.h+'" text="'+draggingBlock.internaltext()+'"></'+draggingBlock.type()+'>';
					}
				}
				if ( Math.abs((main.stage.mouseX-cboxx)) < 10 || Math.abs(((main.stage.mouseY+currenty)-ststo)) < 10) { //creates boxes, adds to rectlist and main.stage, when makes xml representation and adds it
					trace("too thin");
				} else if (currenttype==WALL) {
					var newwall:Wall = new Wall(cboxx,cboxy,main.stage.mouseX-cboxx,main.stage.mouseY-cboxy);
					xmllist.push('<wall x="'+cboxx+'" y="'+ststo+'" width="'+(main.stage.mouseX-cboxx)+'" height="'+((main.stage.mouseY+currenty)-ststo)+'"></wall>');
					main.addChild(newwall);
					rectList.push(newwall);
				} else if (currenttype==DEATHBLOCK) {
					var newwallf:FalldownBlock = new FalldownBlock(cboxx,cboxy,main.stage.mouseX-cboxx,main.stage.mouseY-cboxy);
					xmllist.push('<deathwall x="'+cboxx+'" y="'+ststo+'" width="'+(main.stage.mouseX-cboxx)+'" height="'+((main.stage.mouseY+currenty)-ststo)+'"></deathwall>');
					main.addChild(newwallf);
					rectList.push(newwallf);
				} else if (currenttype==BOOST) {
					var newwallb:Boost = new Boost(cboxx,cboxy,main.stage.mouseX-cboxx,main.stage.mouseY-cboxy);
					xmllist.push('<boost x="'+cboxx+'" y="'+ststo+'" width="'+(main.stage.mouseX-cboxx)+'" height="'+((main.stage.mouseY+currenty)-ststo)+'"></boost>');
					main.addChild(newwallb);
					rectList.push(newwallb);
				} else if (currenttype==GOAL) {
					var newwallg:Goal = new Goal(cboxx,cboxy,main.stage.mouseX-cboxx,main.stage.mouseY-cboxy);
					xmllist.push('<goal x="'+cboxx+'" y="'+ststo+'" width="'+(main.stage.mouseX-cboxx)+'" height="'+((main.stage.mouseY+currenty)-ststo)+'"></goal>');
					main.addChild(newwallg);
					rectList.push(newwallg);
				}
				main.removeChild(playerspawn);
				main.addChild(playerspawn);
				unmakeui();
				makeui();
			} //note: refreshes ui after every click above the bottom bar
		}
		
		var ststo:Number;
		public function onKeyPress(e:KeyboardEvent) { //for moving up and down extra position
			clearButtonMessage();
			if (e.keyCode == Keyboard.UP && !keydown) {
				levelEditorScroll(5);
			} else if (e.keyCode == Keyboard.DOWN && !keydown) {
				levelEditorScroll(-5);
			} else if (e.keyCode == Keyboard.PAGE_UP && !keydown) {
				levelEditorScroll(25);
			} else if (e.keyCode == Keyboard.PAGE_DOWN && !keydown) {
				levelEditorScroll(-25);
			}
		}
		
		private function levelEditorScroll(n:Number) {
			currenty-=n;
			for each(var i:DisplayObject in rectList) {
				i.y+=n;
			}
			playerspawn.y+=n;
		}
		
		public function onKeyUp(e:KeyboardEvent) {
			if (e.keyCode == Keyboard.Z) {
				undo();
			} else if (e.keyCode == Keyboard.P) {
				startLevel();
			}
		}
		
		public override function startLevel() { //converts to xml, then runs gameengine with it
			clear();
			main.stop();
			trace(outputXML("new_level").toXMLString());
			currentgame = new GameEngine(main,this,outputXML("new_level"),"new level",true);
		}
		
		
		public function remake() { //called after game is over (either backbutton or no to submit), remakes ui and re-add all to main.stage
			main.addChild(this);
			main.addChild(mousePreviewDrawer);
			for each (var s:Sprite in rectList) {
				main.addChild(s);
			}
			main.addChild(playerspawn);
			editorKeyListeners();
			makeui();
			main.playSpecific(JumpDieCreateMain.LEVELEDITOR_MUSIC);
		}
		
		public function outputXML(name:String):XML {
			var textout = '<level name="'+name+'">';
			for each (var s:String in xmllist) {
					textout += s;
			}
			textout += "</level>";
			try {
				var output:XML= new XML(textout);
			} catch (e:TypeError) {
				trace(textout);
				remake();
			}
			return output;
		}
		
		public function undo() {
			if (rectList.length <= 0) {
					return;
				}
			main.removeChild(rectList.pop());
			xmllist.pop();
		}
		
		public var menubutton:Sprite;
		public var playbutton:Sprite;
		public var undobutton:Sprite;
		
		public var selectorbutton:Sprite;
		public var infobutton:Sprite;
		public var helpbutton:Sprite;
		
		public function makeui() {//every _button is a wrapper, first child(0) is button (always there), second child(1) is buttonmessage(if exist)
			menubutton = new Sprite;
			menubutton.addChild(menubuttonimg);
			menubutton.x = 458; menubutton.y = 502;
			main.addChild(menubutton);
			menubutton.addEventListener(MouseEvent.CLICK,function(){destroy();});
			
			playbutton = new Sprite;
			playbutton.addChild(playbuttonimg);
			playbutton.x = 410; playbutton.y = 502;
			main.addChild(playbutton);
			playbutton.addEventListener(MouseEvent.CLICK,function(){startLevel();});
			
			undobutton = new Sprite;
			undobutton.addChild(undobuttonimg);
			undobutton.x = 362; undobutton.y = 502;
			main.addChild(undobutton);
			undobutton.addEventListener(MouseEvent.CLICK,function(){undo();});
			
			var passhelper:LevelEditor = this;
			
			var gB:ButtonMessage = new ButtonMessage("",this);
			var iconBitmap:Array = new Array(gB.blue,gB.red,gB.yellow,gB.green,gB.texticon,gB.deleteicon,gB.moveicon,gB.boostfruiticon);
			
			selectorbutton = new Sprite;
			var selectorbuttonelements:Sprite = new Sprite;
			selectorbuttonelements.addChild(makeBitmapWrapper(blankbuttonimg));			
			selectorbutton.x = 0; selectorbutton.y =502;
			main.addChild(selectorbutton);
			selectorbuttonelements.addEventListener(MouseEvent.CLICK,function(){
												clearButtonMessage();
												selectorbutton.addChild(new ButtonMessage("selector",passhelper));
											});
			selectorbuttonelements.addChild(makeBitmapWrapper(iconBitmap[currenttype]));
			selectorbuttonelements.getChildAt(1).x = 16; selectorbuttonelements.getChildAt(1).y = 4; 
			selectorbutton.addChild(selectorbuttonelements);
			
			infobutton = new Sprite;
			infobutton.addChild(makeBitmapWrapper(infobuttonimg));
			infobutton.x = 48; infobutton.y =502;
			main.addChild(infobutton);
			infobutton.getChildAt(0).addEventListener(MouseEvent.CLICK,function(){
											clearButtonMessage();
											infobutton.addChild(new ButtonMessage("info",passhelper));
										});
			
			
			helpbutton = new Sprite;
			helpbutton.addChild(makeBitmapWrapper(helpbuttonimg));
			helpbutton.x = 96; helpbutton.y =502;
			main.addChild(helpbutton);
			helpbutton.getChildAt(0).addEventListener(MouseEvent.CLICK,function(){
											clearButtonMessage();
											helpbutton.addChild( new ButtonMessage("help",passhelper));
										});
			main.stage.focus = main.stage;
			
		}
		
		public function clearButtonMessage() {
			for each (var s:Sprite in (new Array(selectorbutton,infobutton,helpbutton))) {
				if (s.numChildren > 1) {
					s.removeChildAt(1);
				}
			}
		}
		
		public function hitButtonMessage() {
			for each (var s:Sprite in (new Array(selectorbutton,infobutton,helpbutton))) {
				if (s.numChildren > 1 && s.getChildAt(1).hitTestPoint(main.stage.mouseX,main.stage.mouseY)) {
					return true;
				}
			}
			return false;
		}
		
		public function makeBitmapWrapper(img:Bitmap):Sprite {
			var s:Sprite = new Sprite;
			s.addChild(img)
			return s;
		}
		
		public function unmakeui() {
			main.removeChild(menubutton);
			main.removeChild(playbutton);
			main.removeChild(undobutton);
			
			main.removeChild(selectorbutton);
			main.removeChild(infobutton);
			main.removeChild(helpbutton);
			
		}
		
		public override function destroy() { //return to main menu
			clear();
			main.curfunction = new JumpDieCreateMenu(main);
		}
		
		public function clear() { //remove all from stage, remove all listeners
			while(main.numChildren > 0) {
    			main.removeChildAt(0);
			}
			clearlisteners();
		}
		
		public function clearlisteners() {
			main.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			main.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			main.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			main.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		public override function nextLevel(hitgoal:Boolean) {
			if (!hitgoal) {
				remake();
			} else {
				var submitmenu:SubmitMenu = new SubmitMenu(this); //will eventually call back remake()
			}
		}
		
		private function colorByType(currenttype:Number):uint { //helper for finding ghost fill color
			if (currenttype == WALL) {
				return 0x0000FF;
			} else if (currenttype == DEATHBLOCK) {
				return 0xFF0000;
			} else if (currenttype == BOOST || currenttype == BOOSTFRUIT) {
				return 0xFFFF00;
			} else if (currenttype == GOAL) {
				return 0x008000;
			} else {
				return 0xFFFFFF;
			}
		}
		
		private function convertToType(t:String):Number { //helper for finding ghost fill color
			if (t == "wall") {
				return WALL;
			} else if (t == "boost") {
				return BOOST;
			} else if (t == "deathwall") {
				return DEATHBLOCK;
			} else if (t == "goal") {
				return GOAL;
			} else if (t == "textfield") {
				return TEXT;
			} else if (t == "boostfruit") {
				return BOOSTFRUIT;
			} else {
				trace("error in convertToType(string)");
				return -999;
			}
		}
		
		[Embed(source='..//img//button//menu.png')]
		private var mb1:Class;
		private var menubuttonimg:Bitmap = new mb1;
		
				[Embed(source='..//img//button//play.png')]
		private var mb2:Class;
		private var playbuttonimg:Bitmap = new mb2;
		
						[Embed(source='..//img//button//undo.png')]
		private var mb3:Class;
		private var undobuttonimg:Bitmap = new mb3;
		
						[Embed(source='..//img//button//blank.png')]
		private var mb4:Class;
		private var blankbuttonimg:Bitmap = new mb4;
		
						[Embed(source='..//img//button//info.png')]
		private var mb5:Class;
		private var infobuttonimg:Bitmap = new mb5;
		
						[Embed(source='..//img//button//help.png')]
		private var mb6:Class;
		private var helpbuttonimg:Bitmap = new mb6;
		
	}
	
}
