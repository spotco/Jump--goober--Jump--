package misc {
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
			}

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
				if (b.type() == "wall") {
					blockcount[0]++;
				} else if (b.type() == "deathwall") {
					blockcount[1]++;
				} else if (b.type() == "boost") {
					blockcount[2]++;
				} else if (b.type() == "goal") {
					blockcount[3]++;
				}
			}
			msg.text = "TotalObj:"+leveleditor.xmllist.length+"\n   Blue:"+blockcount[0]+"\n   Red:"+blockcount[1]+"\n   Yellow:"+blockcount[2]+"\n   Green:"+blockcount[3]+" \nCurrentHeight:"+(-leveleditor.currenty)+"px";
		}
		
		public function selector(){
			var s0:Sprite = leveleditor.makeBitmapWrapper(blue);
			s0.x = 10; s0.y = 10;
			s0.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.WALL;leveleditor.unmakeui();leveleditor.makeui();});
			addChild(s0);
			
			var s1:Sprite = leveleditor.makeBitmapWrapper(red);
			s1.x = 25; s1.y = 10;
			s1.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.DEATHBLOCK;leveleditor.unmakeui();leveleditor.makeui();});
			addChild(s1);
			
			var s2:Sprite = leveleditor.makeBitmapWrapper(yellow);
			s2.x = 40; s2.y = 10;
			s2.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.BOOST;leveleditor.unmakeui();leveleditor.makeui();});
			addChild(s2);
			
			var s3:Sprite = leveleditor.makeBitmapWrapper(green);
			s3.x = 55; s3.y = 10;
			s3.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.GOAL;leveleditor.unmakeui();leveleditor.makeui();});
			addChild(s3);
			
			var s4:Sprite = leveleditor.makeBitmapWrapper(texticon);
			s4.x = 70; s4.y = 10;
			s4.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.TEXT;leveleditor.unmakeui();leveleditor.makeui();});
			addChild(s4);
			
			var s5:Sprite = leveleditor.makeBitmapWrapper(deleteicon);
			s5.x = 70; s5.y = 25;
			s5.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.DELETE;leveleditor.unmakeui();leveleditor.makeui();});
			addChild(s5);
			
			var s6:Sprite = leveleditor.makeBitmapWrapper(moveicon);
			s6.x = 55; s6.y = 25;
			s6.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.MOVE;leveleditor.unmakeui();leveleditor.makeui();});
			addChild(s6);
			
			var s7:Sprite = leveleditor.makeBitmapWrapper(boostfruiticon);
			s7.x = 10; s7.y = 25;
			s7.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.BOOSTFRUIT;leveleditor.unmakeui();leveleditor.makeui();});
			addChild(s7);
			
			var s8:Sprite = leveleditor.makeBitmapWrapper(trackicon);
			s8.x = 10; s8.y = 40;
			s8.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.TRACK;leveleditor.unmakeui();leveleditor.makeui();});
			addChild(s8);
			
			var s9:Sprite = leveleditor.makeBitmapWrapper(trackwallicon);
			s9.x = 25; s9.y = 40;
			s9.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.TRACKWALL;leveleditor.unmakeui();leveleditor.makeui();});
			addChild(s9);
			
			var s10:Sprite = leveleditor.makeBitmapWrapper(trackbladeicon);
			s10.x = 40; s10.y = 40;
			s10.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.TRACKBLADE;leveleditor.unmakeui();leveleditor.makeui();});
			addChild(s10);
			
			var s11:Sprite = leveleditor.makeBitmapWrapper(bossplanticon);
			s11.x = 55; s11.y = 40;
			s11.addEventListener(MouseEvent.CLICK,function(){leveleditor.currenttype = LevelEditor.FLOWERBOSS;leveleditor.unmakeui();leveleditor.makeui();});
			addChild(s11);
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
		
		
		
	}
	
}
