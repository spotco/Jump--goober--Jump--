package misc {
	import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
		import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	import flash.text.TextField;
	
	public class OnlineBrowseSelection extends Sprite {
		
		public var info:Object;
		private var mode:Boolean = false;
		
		public function OnlineBrowseSelection(x:Number, y:Number, info:Object,mode:Boolean) {
			this.x = x;
			this.y = y;
			this.info = info;
			draw(0);
			this.mode = mode;
			inittext();
			
		}
		
		private function inittext() {
			var namedisplay:TextField = SubmitMenu.maketextdisplay(0,-8,info.level_name,23,355,60);
			this.addChild(namedisplay);
			
			var creatordisplay:TextField = SubmitMenu.maketextdisplay(0,42,"Created by: "+info.creator_name,12,200,20);
			this.addChild(creatordisplay);
			
			var topleftdisplay:TextField;
			if (mode) {
				topleftdisplay = SubmitMenu.maketextdisplay(207,0,"\tDate created:\n"+info.date_created,12,200,50);
			} else {
				topleftdisplay = SubmitMenu.maketextdisplay(230,0,"Play count: "+info.playcount,12,200,20);
			}
			this.addChild(topleftdisplay);
			
			var ratingavg:Number = Math.round(Number(info.ratingavg));
			for (var i = 1; i <= 5; i++) {
				var star:Sprite = new Sprite;
				if (i <= ratingavg) {
					star.addChild(new ReviewSubmitMenu.starfill as Bitmap);
				} else {
					star.addChild(new ReviewSubmitMenu.starempty as Bitmap);
				}
				star.x = 164+31*i;
				star.y = 31;
				this.addChild(star);
			}
		}
		
		public function draw(a:Number) {
			this.graphics.lineStyle(2,0x000000);
			this.graphics.lineTo(355,0);
			this.graphics.lineTo(355,60);
			this.graphics.lineTo(0,60);
			this.graphics.lineTo(0,0);
			
			this.graphics.beginFill(0x000000,a);
			this.graphics.drawRect(0,0,355,60);
		}
		
	}
	
}
