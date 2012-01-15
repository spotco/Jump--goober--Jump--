package blocks  {
		import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import flash.text.TextField;
    import flash.text.TextFormat;
	import flash.display.BitmapData;
	import flash.text.AntiAliasType;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class Textdisplay extends BaseBlock {
		//text display with bug and speech bubble, TODO - fix left/right side positioning problems
		public var text:TextField;
		public var message:String;
		
		public var bugcontainer:Sprite;
		public var buganimationtimer:Number;
		public var buganimationphase:Number;
		
		public var textcontainer:Sprite;
		
		[Embed(source='..//img//block//textbug//textbug1.png')]
		private var t0:Class;
		private var bug0:Bitmap = new t0;
		
		[Embed(source='..//img//block//textbug//textbug2.png')]
		private var t1:Class;
		private var bug1:Bitmap = new t1();
		
				[Embed(source='..//img//block//textbug//speechbubble.png')]
		public static var t2:Class;
		private var spbubble:Bitmap = new t2();
		
			  	[Embed(source='..//misc//Bienvenu.ttf', embedAsCFF="false", fontName='Game', fontFamily="Game", mimeType='application/x-font')] 
      	public var bar:String;
		
		private var tb1:Bitmap = new Bitmap();
		private var tb2:Bitmap = new Bitmap();
		

		public function Textdisplay(x:Number,y:Number,text:String) {
			this.w = 156; this.h = 70;
			this.x = x;
            this.y = y;
			message = text;
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "Game";
            textFormat.size = 10;
			
			textcontainer = new Sprite;
			
			textcontainer.addChild(spbubble);
			
			this.text = new TextField();
			this.text.embedFonts = true;
            this.text.antiAliasType = AntiAliasType.ADVANCED;
			this.text.x = 5; this.text.y = 3;
            this.text.width = 145;
			this.text.height = 45;
			this.text.text = text;
			this.text.wordWrap = true;
			this.text.selectable=false;
			//this.text.background = true;
			//this.text.backgroundColor = 0xFF00FF;
			this.text.setTextFormat(textFormat);
			textcontainer.addChild(this.text);
			
			this.addChild(textcontainer);
			
			bugcontainer = new Sprite;
			bugcontainer.addChild(bug0);
			this.addChild(bugcontainer);
			
			
			if (x > 250) {
				bug0.scaleX = -1;
				bug0.x += bug0.width;
				bug1.scaleX = -1;
				bug1.x += bug1.width;
				spbubble.scaleX = -1;
				spbubble.x += spbubble.width;
				bugcontainer.y += 62;
				bugcontainer.x += 148;
			} else {
				bugcontainer.y += 47;
				bugcontainer.x -= 15;
			}
			
			buganimationtimer = 0;
			buganimationphase = 0;
		}
		
		public override function update(g:GameEngine):Boolean {
			this.animate(g);
			if (this.stage != null) {
				g.main.setChildIndex(this,g.main.numChildren-1);
			}
			return false;
		}
		
		public function animate(g:GameEngine):Boolean {
			var testguy:Guy = g.testguy;
			if (this.y < -200 || this.y > 700) {
				return false;
			}
			buganimationtimer++;
			if (buganimationtimer > 5 && bugcontainer.numChildren > 0) {
				buganimationtimer = 0;
				bugcontainer.removeChildAt(0);
				if (buganimationphase == 0) {
					buganimationphase++;
					bugcontainer.addChild(bug0);
				} else if (buganimationphase == 1) {
					buganimationphase = 0;
					bugcontainer.addChild(bug1);
				}
			}
			var cx:Number = x + (156/2);
			var cy:Number = y + (70/2);
			var dist:Number = Math.sqrt(Math.pow(cx-testguy.x,2)+Math.pow(cy-testguy.y,2));
			
			if (dist < 110) {
				textcontainer.alpha = (110-(110-dist))/110;
			} else {
				textcontainer.alpha = 1;
			}
			return false;
		}
		
		public override function type():String {
			return "textfield";
		}
		
		public override function internaltext():String {
			return message;
		}
		

	}
	
}
