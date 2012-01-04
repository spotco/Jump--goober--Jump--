package misc {
	import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
		import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	import flash.text.*;
	
	public class LevelSelectButton extends Sprite {
		
		public var clvl:Number;
		public var text:TextField;
		public var clickArea:Particle = new Particle;
		
		private static var gamefont:TextFormat = JumpDieCreateMain.getTextFormat(24,2);
		
		public function LevelSelectButton(x:Number, y:Number, clvl:Number) {
			this.x = x;
			this.y = y;
			this.clvl = clvl;
			
			if (clvl == 11) {
				this.text = makeLevelSelectText(0,0,"Level "+this.clvl+" (boss)");
			} else {
				this.text = makeLevelSelectText(0,0,"Level "+this.clvl);
			}
			this.addChild(this.text);
			
			clickArea.buttonmaster = this;
			
			clickArea.graphics.beginFill(0x00FF00,0);
			clickArea.graphics.drawRect(0,0,this.text.width,this.text.height);
			this.addChild(clickArea);
		}
		
		public static function makeLevelSelectText(x:Number,y:Number,text:String):TextField {
			var s:TextField = new TextField();
			s.text = text;
			s.x = x;
			s.y = y;
			s.selectable = false;
			s.embedFonts = true;
			s.antiAliasType = AntiAliasType.ADVANCED;
			s.defaultTextFormat = gamefont;
			s.setTextFormat(gamefont);
			s.autoSize = TextFieldAutoSize.LEFT;
			return s;
		}
		
	}
	
}
