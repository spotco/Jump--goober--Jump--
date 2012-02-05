package blocks {
		import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	import flash.media.SoundTransform;
	
	public class Boost extends BaseBlock {
		
		public var animarray:Array;
		public var animframe:Number;
		public var animslowtimer:Number;
		
		public var frame:Sprite = new Sprite;

		public function Boost(x:Number,y:Number,w:Number,h:Number) {
			//boost pad that accelerates upward (used to provide extra jumps)
			this.x = x;
			this.y = y;
			if (w < 0) {
				this.x += w;
				this.w = Math.abs(w);
			} else {
				this.w = w;
			}
			if (h < 0) {
				this.y += h;
				this.h = Math.abs(h);
			} else {
				this.h = h;
			}
			animframe = 0;
			animslowtimer = 0;
			animarray = [makeBitmap(yellowblock0), makeBitmap(yellowblock1),makeBitmap(yellowblock2),makeBitmap(yellowblock3),makeBitmap(yellowblock4)];
			graphics.beginBitmapFill(animarray[0]);
			graphics.drawRect(0, 0, this.w,this.h);
			graphics.endFill();
			this.alpha = 0.8;
			
			frame.graphics.lineStyle(2,0xFFAA33);
			frame.graphics.lineTo(this.w,0);
			frame.graphics.lineTo(this.w,this.h);
			frame.graphics.lineTo(0,this.h);
			frame.graphics.lineTo(0,0);
			addChild(frame);
		}
		
		var playstatus = false;
		var playcooldown = 0;
		static var t:SoundTransform = new SoundTransform(0.5);
		
		public override function update(g:GameEngine):Boolean {
			if (this.stage != null) {
				g.main.setChildIndex(this,g.main.getChildIndex(g.bg)+1);
			}
			this.updateAnimation();
			if (playcooldown > 0) {
				playcooldown--;
			}
			var hit = g.testguy.hitTestObject(this);
			if (hit) {
				if (!playstatus && playcooldown == 0) {
					g.main.playsfx(JumpDieCreateMain.boostsound,t);
					playcooldown = 35;
				}
				if (g.testguy.vy > -20) {
					g.testguy.vy -= 3;
				}
				g.testguy.jumpCounter+=4;
			}
			playstatus = hit;
			return false;
		}
		
		public function updateAnimation() {
			if (this.y < -1000 || this.y > 700) {
				return;
			}
			if (animslowtimer > 5) {
				graphics.clear();
				graphics.beginBitmapFill(animarray[animframe]);
				graphics.drawRect(0, 0, this.w,this.h);
				graphics.endFill();
				animframe++;
				if (animframe > animarray.length-1) {
					animframe = 0;
				}
				animslowtimer = 0;
			}
			animslowtimer++;
			
		}
		
		[Embed(source='..//img//block//yellowblock0.png')]
		private var t0:Class;
		private var yellowblock0:Bitmap = new t0();
		
		[Embed(source='..//img//block//yellowblock1.png')]
		private var tt:Class;
		private var yellowblock1:Bitmap = new tt();
		
				[Embed(source='..//img//block//yellowblock2.png')]
		private var t2:Class;
		private var yellowblock2:Bitmap = new t2();
		
				[Embed(source='..//img//block//yellowblock3.png')]
		private var t3:Class;
		private var yellowblock3:Bitmap = new t3();
		
				[Embed(source='..//img//block//yellowblock4.png')]
		private var t4:Class;
		private var yellowblock4:Bitmap = new t4();

		public override function type():String {
			return "boost";
		}

	}
	
}
