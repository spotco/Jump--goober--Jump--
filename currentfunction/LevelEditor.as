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
	import mx.core.ByteArrayAsset;
		import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	import flash.text.Font;
	import flash.text.AntiAliasType;
	
	//this is a monster
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
		
		public var bggrid:Sprite = new Sprite;
		
		public var bg:Number = 1;
		
		public static var WALL:Number = 0;
		public static var DEATHBLOCK:Number = 1;
		public static var BOOST:Number = 2;
		public static var GOAL:Number = 3;
		public static var TEXT:Number = 4;
		public static var DELETE:Number = 5;
		public static var MOVE:Number = 6;
		public static var BOOSTFRUIT:Number = 7;
		public static var TRACK:Number = 8;
		public static var TRACKWALL:Number = 9;
		public static var TRACKBLADE:Number = 10;
		public static var FLOWERBOSS:Number = 11;
		public static var CLOUDBOSS:Number = 12;
		public static var ROCKETLAUNCHER:Number = 13;
		public static var LASERCW:Number = 14;
		public static var LASERCCW:Number = 15;
		public static var ACTIVATETRACKWALL:Number = 16;
		public static var ROCKETBOSS:Number = 17;
		
		public var currenttype:Number;
		
		private var gamefont:TextFormat = JumpDieCreateMain.getTextFormat(11);
		
		private var ingame:Boolean = false;
		
		
		public function LevelEditor(main:JumpDieCreateMain) {
			currenttype = 0; 
			main.addChild(this);
			graphics.beginFill(0x000000);
			graphics.drawRect(0,0,500,520);
			graphics.endFill();
			
			graphics.beginFill(0x202020);
			graphics.drawRect(0,500,500,40);
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
			main.addChildAt(bggrid,main.getChildIndex(this)+1);
			drawGrid();
			
			this.moveplaceimg.x = 400;
			
		}
				
		[Embed(source="..//misc//blank.xml", mimeType="application/octet-stream")]
		public static var loadThis:Class;
		
		private function drawGrid() {
			bggrid.graphics.clear();
			while(bggrid.numChildren > 0) {
				bggrid.removeChildAt(0);
			}
			bggrid.graphics.lineStyle(1,0xFFFFFF,0.3);
			for(var i = Math.floor(currenty/50)*50 + 520; i >= this.currenty; i-= 50) {
				bggrid.graphics.moveTo(0,i);
				bggrid.graphics.lineTo(500,i);
				var s:TextField = new TextField();
				s.textColor = 0xFFFFFF;
				s.text = -(i-520)+"px";
				s.x = 1;
				s.y = i;
				s.alpha = 0.3;
				s.selectable = false;
				s.embedFonts = true;
				s.antiAliasType = AntiAliasType.ADVANCED;
				s.defaultTextFormat = gamefont;
				s.setTextFormat(gamefont);
				bggrid.addChild(s);
			}
			for (i = 0; i <= 500; i+= 50) {
				bggrid.graphics.moveTo(i,currenty);
				bggrid.graphics.lineTo(i,currenty+520);
			}
		}
		
		
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
				} else if (e.name() == "track") {
					addblock = new Track(e.@x,e.@y,e.@width,e.@height);
				} else if (e.name() == "trackwall") {
					addblock = new TrackWall(e.@x,e.@y,e.@width,e.@height);
				} else if (e.name() == "trackblade") {
					addblock = new TrackBlade(e.@x,e.@y);
				} else if (e.name() == "flowerboss") {
					addblock = new FlowerBoss(e.@y);
				} else if (e.name() == "cloudboss") {
					addblock = new CloudBoss();
				} else if (e.name() == "rocketlauncher") {
					addblock = new RocketLauncher(e.@x,e.@y);
				} else if (e.name() == "bossactivate") {
					addblock = new BossActivate(e.@x,e.@y,e.@width,e.@height,e.@hp);
				} else if (e.name() == "laserlauncher") {
					addblock = new LaserLauncher(e.@x,e.@y,e.@dir);
				} else {
					continue;
				}
				rectList.push(addblock);
				main.addChild(addblock);
			}
			unmakeui();
			makeui();
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
			
			if (currenttype == WALL || currenttype == DEATHBLOCK || currenttype == BOOST || currenttype == GOAL || currenttype == TRACK || currenttype == TRACKWALL || currenttype == ACTIVATETRACKWALL || currenttype == ROCKETBOSS && !keydown) {
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
			if (main.stage.mouseY > 500) {
				return;
			}
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
		
		public function onMouseUp(e:MouseEvent) { //this method is not structured well, lol
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
				if (currenttype == TRACKBLADE) {
					var newtrackbladej:TrackBlade = new TrackBlade(cboxx,cboxy);
					xmllist.push('<trackblade x="'+cboxx+'" y="'+ststo+'"></trackblade>');
					main.addChild(newtrackbladej);
					rectList.push(newtrackbladej);
				}
				if (currenttype == FLOWERBOSS) {
					var newflowerboss:FlowerBoss = new FlowerBoss(cboxy);
					xmllist.push('<flowerboss y="'+ststo+'"></flowerboss>');
					main.addChild(newflowerboss);
					rectList.push(newflowerboss);
				}
				if (currenttype == CLOUDBOSS) {
					var newcloudboss:CloudBoss = new CloudBoss(false);
					xmllist.push('<cloudboss></cloudboss>');
					main.addChild(newcloudboss);
					rectList.push(newcloudboss);
				}
				if (currenttype == ROCKETLAUNCHER) {
					var newrl:RocketLauncher = new RocketLauncher(cboxx,cboxy);
					xmllist.push('<rocketlauncher x="'+cboxx+'" y="'+ststo+'" ></rocketlauncher>');
					main.addChild(newrl);
					rectList.push(newrl);
				}
				if (currenttype == LASERCW) {
					var newllcw:LaserLauncher = new LaserLauncher(cboxx,cboxy,0);
					newllcw.launcherContainer.rotation = -90;
					xmllist.push('<laserlauncher x="'+cboxx+'" y="'+ststo+'" dir="3"></laserlauncher>');
					main.addChild(newllcw);
					rectList.push(newllcw);
				}
				if (currenttype == LASERCCW) {
					var newllccw:LaserLauncher = new LaserLauncher(cboxx,cboxy,0);
					newllccw.launcherContainer.rotation = 90;
					xmllist.push('<laserlauncher x="'+cboxx+'" y="'+ststo+'" dir="-3"></laserlauncher>');
					main.addChild(newllccw);
					rectList.push(newllccw);
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
						if (draggingBlock is LaserLauncher) {
							if ((draggingBlock as LaserLauncher).launcherContainer.rotation == 90) {
								xmllist[draggingBlockIndex] = '<'+draggingBlock.type()+' x="'+draggingBlock.x+'" y="'+(draggingBlock.y+currenty)+'" dir="-3"></'+draggingBlock.type()+'>';
							} else {
								xmllist[draggingBlockIndex] = '<'+draggingBlock.type()+' x="'+draggingBlock.x+'" y="'+(draggingBlock.y+currenty)+'" dir="3"></'+draggingBlock.type()+'>';
							}
						} else if (draggingBlock is BossActivate) {
							xmllist[draggingBlockIndex] = '<'+draggingBlock.type()+' x="'+draggingBlock.x+'" y="'+(draggingBlock.y+currenty)+'" width="'+draggingBlock.w+'" height="'+draggingBlock.h+'" hp="6"></'+draggingBlock.type()+'>';
						} else if (draggingBlock is Textdisplay) {
							xmllist[draggingBlockIndex] = '<'+draggingBlock.type()+' x="'+draggingBlock.x+'" y="'+(draggingBlock.y+currenty)+'" text="'+draggingBlock.internaltext()+'"></'+draggingBlock.type()+'>';
						} else {
							xmllist[draggingBlockIndex] = '<'+draggingBlock.type()+' x="'+draggingBlock.x+'" y="'+(draggingBlock.y+currenty)+'" width="'+draggingBlock.w+'" height="'+draggingBlock.h+'"></'+draggingBlock.type()+'>';
						}
						
					}
				}
				if ( Math.abs((main.stage.mouseX-cboxx)) < 10 || Math.abs(((main.stage.mouseY+currenty)-ststo)) < 10) { //creates boxes, adds to rectlist and main.stage, when makes xml representation and adds it
					//trace("too thin");
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
				} else if (currenttype==TRACK) {
					var newtrackh:Track = new Track(cboxx,cboxy,main.stage.mouseX-cboxx,main.stage.mouseY-cboxy);
					xmllist.push('<track x="'+cboxx+'" y="'+ststo+'" width="'+(main.stage.mouseX-cboxx)+'" height="'+((main.stage.mouseY+currenty)-ststo)+'"></track>');
					main.addChild(newtrackh);
					rectList.push(newtrackh);
				} else if (currenttype == TRACKWALL) {
					var newtrackwalli:TrackWall = new TrackWall(cboxx,cboxy,main.stage.mouseX-cboxx,main.stage.mouseY-cboxy);
					xmllist.push('<trackwall x="'+cboxx+'" y="'+ststo+'" width="'+(main.stage.mouseX-cboxx)+'" height="'+((main.stage.mouseY+currenty)-ststo)+'"></trackwall>');
					main.addChild(newtrackwalli);
					rectList.push(newtrackwalli);
				} else if (currenttype == ACTIVATETRACKWALL) {
					var newatrackwalli:ActivateTrackWall = new ActivateTrackWall(cboxx,cboxy,main.stage.mouseX-cboxx,main.stage.mouseY-cboxy);
					xmllist.push('<activatetrackwall x="'+cboxx+'" y="'+ststo+'" width="'+(main.stage.mouseX-cboxx)+'" height="'+((main.stage.mouseY+currenty)-ststo)+'"></activatetrackwall>');
					main.addChild(newatrackwalli);
					rectList.push(newatrackwalli);					
				} else if (currenttype == ROCKETBOSS) {
					var newrboss:BossActivate = new BossActivate(cboxx,cboxy,main.stage.mouseX-cboxx,main.stage.mouseY-cboxy);
					xmllist.push('<bossactivate x="'+cboxx+'" y="'+ststo+'" width="'+(main.stage.mouseX-cboxx)+'" height="'+((main.stage.mouseY+currenty)-ststo)+'" hp="6" explode="no"></bossactivate>');
					main.addChild(newrboss);
					rectList.push(newrboss);
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
			bggrid.y+=n;
			drawGrid();
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
			trace(outputXML("new_level").toXMLString());
			
			this.starttime = new Date;
			
			if (!this.ingame) { //for continuous music playing
				this.ingame = true;
				main.stop();
				main.playSpecific(JumpDieCreateMain.ONLINE);
			}
			currentgame = new GameEngine(main,this,outputXML("new_level"),"new level",true);
		}
		
		
		public function remake() { //called after game is over (either backbutton or no to submit), remakes ui and re-add all to main.stage
			this.ingame = false;
			this.starttime = null;
			main.addChild(this);
			main.addChild(mousePreviewDrawer);
			for each (var s:Sprite in rectList) {
				main.addChild(s);
			}
			main.addChild(playerspawn);
			main.addChildAt(bggrid,main.getChildIndex(this)+1);
			editorKeyListeners();
			makeui();
			main.playSpecific(JumpDieCreateMain.LEVELEDITOR_MUSIC);
		}
		
		public function outputXML(name:String):XML {
			var textout = '<level name="'+name+'" bg="'+this.bg+'">';
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
		public var bgbutton:Sprite;
		
		public var moveplaceindicator:Sprite;
		
		var gB:ButtonMessage = new ButtonMessage("",this);
		//note, keep this order the same as the constant numbers
		var iconBitmap:Array = new Array(gB.blue,
										 gB.red,
										 gB.yellow,
										 gB.green,
										 gB.texticon,
										 gB.deleteicon,
										 gB.moveicon,
										 gB.boostfruiticon,
										 gB.trackicon,
										 gB.trackwallicon,
										 gB.trackbladeicon,
										 gB.bossplanticon,
										 gB.bosscloudicon,
										 gB.rocketlaunchericon,
										 gB.lasercwicon,
										 gB.laserccwicon,
										 gB.activatetrackwallicon,
										 gB.rocketbossicon
								);
		
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
										
			bgbutton = new Sprite;
			bgbutton.addChild(makeBitmapWrapper(bgbuttonimg));
			bgbutton.x = 144; bgbutton.y = 502;
			main.addChild(bgbutton);
			bgbutton.getChildAt(0).addEventListener(MouseEvent.CLICK,function(){
											clearButtonMessage();
											helpbutton.addChild( new ButtonMessage("bg",passhelper));
										});
			
			this.moveplaceindicator = new Sprite;
			this.moveplaceindicator.addChild(this.moveplaceimg);
			main.addChild(this.moveplaceindicator);
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
			
			main.removeChild(this.moveplaceindicator);
			
			menubutton = null;
			playbutton = null;
			undobutton = null;
			selectorbutton = null;
			infobutton = null;
			helpbutton = null;
			
		}
		
		public override function destroy() { //return to main menu
			clear();
			var newtextobject:ConfirmationWindow = new ConfirmationWindow("Are you sure you want to quit and erase all your work?",this,
				function(){ //yes
					main.removeChild(newtextobject);
					main.curfunction = new JumpDieCreateMenu(main);
					gcfinalize();
				},
				function(){ //no
					remake();
					main.removeChild(newtextobject);
					newtextobject = null;
				}
			);
			main.addChild(newtextobject);
		}
		
		private function gcfinalize() {
			this.main = null;
			this.playerspawn = null;
			this.xmllist = null;
			this.currentgame = null;
			this.mousePreviewAnimateTimer = null;
			this.mousePreviewDrawer = null;
			this.rectList = null;
			this.bggrid = null;
			this.gB = null;
			this.iconBitmap = null;
		}
		
		public function clear() { //remove all from stage, remove all listeners
			JumpDieCreateMain.clearDisplay(main);
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
				var time:Number = (new Date).time - this.starttime.time;
				trace("time: "+time);
				var submitmenu:SubmitMenu = new SubmitMenu(this,time); //will eventually call back remake()
			}
		}
		
		private function colorByType(currenttype:Number):uint { //helper for finding ghost fill color
			if (currenttype == WALL || currenttype == TRACK || currenttype == TRACKWALL || currenttype == ACTIVATETRACKWALL) {
				return 0x0000FF;
			} else if (currenttype == DEATHBLOCK || currenttype == TRACKBLADE || currenttype == FLOWERBOSS || currenttype == ROCKETBOSS || currenttype == ROCKETLAUNCHER || currenttype == LevelEditor.LASERCCW || currenttype == LevelEditor.LASERCW) {
				return 0xFF0000;
			} else if (currenttype == BOOST || currenttype == BOOSTFRUIT) {
				return 0xFFFF00;
			} else if (currenttype == GOAL) {
				return 0x008000;
			} else if (currenttype == TRACK) {
				return 0x5f95b1;
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
			} else if (t == "track") {
				return TRACK;
			} else if (t == "trackwall") {
				return TRACKWALL;
			} else if (t == "trackblade") {
				return TRACKBLADE;
			} else if (t == "flowerboss") {
				return FLOWERBOSS;
			} else if (t == "bossactivate") {
				return ROCKETBOSS;
			} else if (t == "activatetrackwall") {
				return ACTIVATETRACKWALL;
			} else if (t == "rocketlauncher") {
				return ROCKETLAUNCHER;
			} else if (t == "laserlauncher") {
				return LASERCW;
			} else {
				//trace("error in convertToType(string), this is a LevelEditor Function");
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
		
		[Embed(source='..//img//button//bg.png')]
		private var mb7:Class;
		private var bgbuttonimg:Bitmap = new mb7;
		
		[Embed(source='..//img//misc//moveplacesign.png')]
		private var mb8:Class;
		private var moveplaceimg:Bitmap = new mb8;
		
	}
	
}
