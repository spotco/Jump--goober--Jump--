﻿package misc {
		import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import flash.text.TextField;
    import flash.text.TextFormat;
	import flash.text.AntiAliasType;
		import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class ButtonMessage extends Sprite {
		
		public var leveleditor:LevelEditor;
		public var textFormat:TextFormat;
		
		public function ButtonMessage(type:String, leveleditor:LevelEditor , helpphase:Number = 0) {
			//message that appears when a button in the leveleditor is clicked, add this as a child to the button
			//specify which button in param, helpphase optional is for help button cycling through help text array
			textFormat= new TextFormat();
			textFormat.font = "Game";
            textFormat.size = 10;
			
			this.leveleditor = leveleditor;
			this.y = -113;
			if(type == "selector") {
				this.x = 0;
				addChild(messagebgL);
				selector();
			} else if (type == "info") {
				this.x = -47;
				addChild(messagebgM);
				info();
			} else if (type == "help") {
				this.x = -95;
				addChild(messagebgR);
				help(helpphase);
			} else if (type == "bg") {
				this.x = -48;
				addChild(messagebgR);
				bg();
			}

		}
		
		public function bg() {
			var s0:Sprite = leveleditor.makeBitmapWrapper(this.bg1sel);
			s0.x = 10; s0.y = 5;
			s0.addEventListener(MouseEvent.CLICK,function(){leveleditor.bg = 1;leveleditor.unmakeui();leveleditor.makeui();});
			addChild(s0);
			
			var s1:Sprite = leveleditor.makeBitmapWrapper(this.bg2sel);
			s1.x = 64; s1.y = 5;
			s1.addEventListener(MouseEvent.CLICK,function(){leveleditor.bg = 2;leveleditor.unmakeui();leveleditor.makeui();});
			addChild(s1);
			
			var s2:Sprite = leveleditor.makeBitmapWrapper(this.bg3sel);
			s2.x = 118; s2.y = 5;
			s2.addEventListener(MouseEvent.CLICK,function(){leveleditor.bg = 3;leveleditor.unmakeui();leveleditor.makeui();});
			addChild(s2);
			
			var drawbox:Sprite;
			var boxgrafix:Sprite = new Sprite;
			if (leveleditor.bg == 2) {
				drawbox = s1;
			} else if (leveleditor.bg == 3) {
				drawbox = s2;
			} else {
				drawbox = s0;
			}
			drawbox.addChild(boxgrafix);
			var w = drawbox.width;
			var h = drawbox.height;
			boxgrafix.graphics.lineStyle(4,0x000000);
			boxgrafix.graphics.lineTo(w,0);
			boxgrafix.graphics.lineTo(w,h);
			boxgrafix.graphics.lineTo(0,h);
			boxgrafix.graphics.lineTo(0,0);
		}
		
		public function help(helpphase:Number){
			var msg:TextField = new TextField();
			msg.embedFonts = true; msg.selectable = false; msg.x = 5; msg.y = 5; msg.antiAliasType = AntiAliasType.ADVANCED; msg.width = 150; msg.height = 100;
			msg.text = helpmessages[helpphase];
			msg.wordWrap = true;
			msg.defaultTextFormat = textFormat;msg.setTextFormat(textFormat);
			this.addChild(msg);
			
			if(helpphase < helpmessages.length-1) {
				var nextbutton:Sprite = leveleditor.makeBitmapWrapper(nexthelp);
				nextbutton.x = 125, nextbutton.y = 75;
				nextbutton.addEventListener(MouseEvent.CLICK, function() {
												leveleditor.clearButtonMessage();
												leveleditor.helpbutton.addChild(new ButtonMessage("help",leveleditor,helpphase+1));
											});
				addChild(nextbutton);
			}
		}
		
		public function info(){
			var msg:TextField = new TextField();
			msg.embedFonts = true; msg.selectable = false; msg.x = 5; msg.y = 5; msg.antiAliasType = AntiAliasType.ADVANCED;msg.width = 150; msg.height = 100;
			msg.defaultTextFormat = textFormat;msg.setTextFormat(textFormat);
			this.addChild(msg);
			var blockcount:Array = new Array(0,0,0,0,0); //0 wall, 1 death, 2 boost, 3 goal, 4 text
			for each(var b:BaseBlock in leveleditor.rectList) {
				if (b is Wall) {
					blockcount[0]++;
				} else if (b is FalldownBlock) {
					blockcount[1]++;
				} else if (b is Boost) {
					blockcount[2]++;
				} else if (b is Goal) {
					blockcount[3]++;
				}
			}
			msg.text = "Total Objects:"+leveleditor.xmllist.length+"\n   Blue:"+blockcount[0]+"\n   Red:"+blockcount[1]+"\n   Yellow:"+blockcount[2]+"\n   Green:"+blockcount[3]+" \nCurrentHeight:"+(-leveleditor.currenty)+"px";
		}
		
		public function selector(){
			var msg:TextField = new TextField();
			msg.embedFonts = true; msg.selectable = false; msg.x = 10; msg.y = 75; msg.antiAliasType = AntiAliasType.ADVANCED;msg.width = 156; msg.height = 14;
			msg.defaultTextFormat = textFormat;msg.setTextFormat(textFormat); msg.wordWrap = true;
			msg.text = "";
			this.addChild(msg);
			
			var setx = 10;
			var sety = 10;
			var incrx = 23;
			var incry = 23;
			
			var s0:Sprite = leveleditor.makeBitmapWrapper(blue);
			s0.x = setx; s0.y = sety;
			s0.scaleX = 1.5; s0.scaleY = 1.5;
			s0.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.WALL;leveleditor.unmakeui();leveleditor.makeui();});
			s0.addEventListener(MouseEvent.MOUSE_OVER,function(){msg.text="Wall";});
			addChild(s0);
			
			setx+=incrx;
			
			var s1:Sprite = leveleditor.makeBitmapWrapper(red);
			s1.x = setx; s1.y = sety;
			s1.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.DEATHBLOCK;leveleditor.unmakeui();leveleditor.makeui();});
			s1.addEventListener(MouseEvent.MOUSE_OVER,function(){msg.text="Spikey Vines";});
			addChild(s1);
			
			setx+=incrx;
			
			var s2:Sprite = leveleditor.makeBitmapWrapper(yellow);
			s2.x = setx; s2.y = sety;
			s2.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.BOOST;leveleditor.unmakeui();leveleditor.makeui();});
			s2.addEventListener(MouseEvent.MOUSE_OVER,function(){msg.text="Boost Pad";});
			addChild(s2);
			
			setx+=incrx;
			
			var s3:Sprite = leveleditor.makeBitmapWrapper(green);
			s3.x = setx; s3.y = sety;
			s3.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.GOAL;leveleditor.unmakeui();leveleditor.makeui();});
			s3.addEventListener(MouseEvent.MOUSE_OVER,function(){msg.text="Goal";});
			addChild(s3);
			
			setx+=incrx;
			
			var s4:Sprite = leveleditor.makeBitmapWrapper(texticon);
			s4.x = setx; s4.y = sety;
			s4.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.TEXT;leveleditor.unmakeui();leveleditor.makeui();});
			s4.addEventListener(MouseEvent.MOUSE_OVER,function(){msg.text="Text Bug";});
			addChild(s4);
			
			setx+=incrx;
			
			var s5:Sprite = leveleditor.makeBitmapWrapper(deleteicon);
			s5.x = setx; s5.y = sety;
			s5.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.DELETE;leveleditor.unmakeui();leveleditor.makeui();});
			s5.addEventListener(MouseEvent.MOUSE_OVER,function(){msg.text="Delete";});
			addChild(s5);
			
			setx+=incrx;
			
			var s6:Sprite = leveleditor.makeBitmapWrapper(moveicon);
			s6.x = setx; s6.y = sety;
			s6.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.MOVE;leveleditor.unmakeui();leveleditor.makeui();});
			s6.addEventListener(MouseEvent.MOUSE_OVER,function(){msg.text="Move";});
			addChild(s6);
			
			setx=10;
			sety+=incry; //2nd row
			
			var s7:Sprite = leveleditor.makeBitmapWrapper(boostfruiticon);
			s7.x = setx; s7.y = sety;
			s7.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.BOOSTFRUIT;leveleditor.unmakeui();leveleditor.makeui();});
			s7.addEventListener(MouseEvent.MOUSE_OVER,function(){msg.text="Jump Fruit";});
			addChild(s7);
			
			setx+=incrx;
			
			var s8:Sprite = leveleditor.makeBitmapWrapper(trackicon);
			s8.x = setx; s8.y = sety;
			s8.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.TRACK;leveleditor.unmakeui();leveleditor.makeui();});
			s8.addEventListener(MouseEvent.MOUSE_OVER,function(){msg.text="Moving Track";});
			addChild(s8);
			
			setx+=incrx;
			
			var s9:Sprite = leveleditor.makeBitmapWrapper(trackwallicon);
			s9.x = setx; s9.y = sety;
			s9.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.TRACKWALL;leveleditor.unmakeui();leveleditor.makeui();});
			s9.addEventListener(MouseEvent.MOUSE_OVER,function(){msg.text="Moving Wall";});
			addChild(s9);
			
			setx+=incrx;
			
			var s10:Sprite = leveleditor.makeBitmapWrapper(trackbladeicon);
			s10.x = setx; s10.y = sety;
			s10.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.TRACKBLADE;leveleditor.unmakeui();leveleditor.makeui();});
			s10.addEventListener(MouseEvent.MOUSE_OVER,function(){msg.text="Moving Blade";});
			addChild(s10);
			
			setx+=incrx;
			
			var s11:Sprite = leveleditor.makeBitmapWrapper(bossplanticon);
			s11.x = setx; s11.y = sety;
			s11.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.FLOWERBOSS;leveleditor.unmakeui();leveleditor.makeui();});
			s11.addEventListener(MouseEvent.MOUSE_OVER,function(){msg.text="World 1 Boss";});
			addChild(s11);
			
			setx+=incrx;
			
			var s12:Sprite = leveleditor.makeBitmapWrapper(bosscloudicon);
			s12.x = setx; s12.y = sety;
			s12.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.CLOUDBOSS;leveleditor.unmakeui();leveleditor.makeui();});
			s12.addEventListener(MouseEvent.MOUSE_OVER,function(){msg.text="World 2 Boss";});
			addChild(s12);
			
			setx+=incrx;
			
			var s17:Sprite = leveleditor.makeBitmapWrapper(rocketbossicon);
			s17.x = setx; s17.y = sety;
			s17.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.ROCKETBOSS;leveleditor.unmakeui();leveleditor.makeui();});
			s17.addEventListener(MouseEvent.MOUSE_OVER,function(){msg.text="World 3 Boss";});
			addChild(s17);
			
			setx=10;
			sety+=incry;
			
			var s13:Sprite = leveleditor.makeBitmapWrapper(rocketlaunchericon);
			s13.x = setx; s13.y = sety;
			s13.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.ROCKETLAUNCHER;leveleditor.unmakeui();leveleditor.makeui();});
			s13.addEventListener(MouseEvent.MOUSE_OVER,function(){msg.text="Rocket Launcher";});
			addChild(s13);
			
			setx+=incrx;
			
			var s14:Sprite = leveleditor.makeBitmapWrapper(lasercwicon);
			s14.x = setx; s14.y = sety;
			s14.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.LASERCW;leveleditor.unmakeui();leveleditor.makeui();});
			s14.addEventListener(MouseEvent.MOUSE_OVER,function(){msg.text="Clockwise Laser";});
			addChild(s14);
			
			setx+=incrx;
			
			var s15:Sprite = leveleditor.makeBitmapWrapper(laserccwicon);
			s15.x = setx; s15.y = sety;
			s15.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.LASERCCW;leveleditor.unmakeui();leveleditor.makeui();});
			s15.addEventListener(MouseEvent.MOUSE_OVER,function(){msg.text="Counterclockwise Laser";});
			addChild(s15);
			
			setx+=incrx;
			
			var s16:Sprite = leveleditor.makeBitmapWrapper(activatetrackwallicon);
			s16.x = setx; s16.y = sety;
			s16.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.ACTIVATETRACKWALL;leveleditor.unmakeui();leveleditor.makeui();});
			s16.addEventListener(MouseEvent.MOUSE_OVER,function(){msg.text="Mobile Wall";});
			addChild(s16);
			
			for (var i = 0; i < this.numChildren; i++) {
				if (this.getChildAt(i) is Sprite) {
					this.getChildAt(i).scaleX = 1.5;
					this.getChildAt(i).scaleY = 1.5;
				}
			}
		}
		
		private var message1:String = "Welcome to the level editor! To start placing blocks, select the type with the button to the far left. Pick your type from the menu.";
		private var message2:String = "To place your block, click and drag. Your block needs to be at least 10x10 pixels to be saved";
		private var message3:String = "Delete tiles with the trashcan tool in the selector, move them with the move tool.";
		private var message4:String = "Or, use the undo(z) button to remove your last block.";
		private var message5:String = "Move up using the arrow keys, or use pageup and page down to move faster."
		private var message6:String = "Press play(p) to test your level out! To submit your level, reach the goal(the green square) and follow the instructions.";
		private var helpmessages:Array = new Array(message1,message2,message3,message4,message5,message6);
		
		[Embed(source='..//misc//Bienvenu.ttf', embedAsCFF="false", fontName='Game', fontFamily="Game", mimeType='application/x-font')] 
      	public var bar:String;
		
		[Embed(source='..//img//editoricon//editorwindowL.png')]
		private var mb1:Class;
		private var messagebgL:Bitmap = new mb1;
		
		[Embed(source='..//img//editoricon//editorwindowM.png')]
		private var mb2:Class;
		private var messagebgM:Bitmap = new mb2;
		
		[Embed(source='..//img//editoricon//editorwindowR.png')]
		private var mb3:Class;
		private var messagebgR:Bitmap = new mb3;
		
		[Embed(source='..//img//editoricon//nexthelp.png')]
		private var mb4:Class;
		private var nexthelp:Bitmap = new mb4;
		
		[Embed(source='..//img//editoricon//blue.png')]
		public var i1:Class;
		public var blue:Bitmap = new i1;
		
		[Embed(source='..//img//editoricon//red.png')]
		public var i2:Class;
		public var red:Bitmap = new i2;
		
		[Embed(source='..//img//editoricon//yellow.png')]
		public var i3:Class;
		public var yellow:Bitmap = new i3;
		
		[Embed(source='..//img//editoricon//green.png')]
		public var i4:Class;
		public var green:Bitmap = new i4;
		
		[Embed(source='..//img//editoricon//delete.png')]
		public var i5:Class;
		public var deleteicon:Bitmap = new i5;
		
		[Embed(source='..//img//editoricon//move.png')]
		public var i6:Class;
		public var moveicon:Bitmap = new i6;
		
		[Embed(source='..//img//editoricon//text.png')]
		public var i7:Class;
		public var texticon:Bitmap = new i7;
		
		[Embed(source='..//img//editoricon//boostfruit.png')]
		private var mb7:Class;
		public var boostfruiticon:Bitmap = new mb7;
		
		[Embed(source='..//img//editoricon//track.png')]
		private var mb8:Class;
		public var trackicon:Bitmap = new mb8;
		
		[Embed(source='..//img//editoricon//trackwall.png')]
		private var mb9:Class;
		public var trackwallicon:Bitmap = new mb9;
		
		[Embed(source='..//img//editoricon//trackblade.png')]
		private var mb10:Class;
		public var trackbladeicon:Bitmap = new mb10;
		

		[Embed(source='..//img//editoricon//bossplant.png')]
		private var mb11:Class;
		public var bossplanticon:Bitmap = new mb11;
		
		[Embed(source='..//img//editoricon//bosscloud.png')]
		private var mb12:Class;
		public var bosscloudicon:Bitmap = new mb12;
		
		[Embed(source='..//img//editoricon//rocketlauncher.png')]
		private var mb13:Class;
		public var rocketlaunchericon:Bitmap = new mb13;
		
		[Embed(source='..//img//editoricon//lasercw.png')]
		private var mb14:Class;
		public var lasercwicon:Bitmap = new mb14;
		
		[Embed(source='..//img//editoricon//laserccw.png')]
		private var mb15:Class;
		public var laserccwicon:Bitmap = new mb15;
		
		[Embed(source='..//img//editoricon//activatetrackwall.png')]
		private var mb16:Class;
		public var activatetrackwallicon:Bitmap = new mb16;
		
		[Embed(source='..//img//editoricon//rocketboss.png')]
		private var mb17:Class;
		public var rocketbossicon:Bitmap = new mb17;
		
		[Embed(source='..//img//editoricon//bg1sel.png')]
		private var mb18:Class;
		public var bg1sel:Bitmap = new mb18;
		
		[Embed(source='..//img//editoricon//bg2sel.png')]
		private var mb19:Class;
		public var bg2sel:Bitmap = new mb19;
		
		[Embed(source='..//img//editoricon//bg3sel.png')]
		private var mb20:Class;
		public var bg3sel:Bitmap = new mb20;
		
	}
	
}
