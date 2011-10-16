package blocks {
		import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import flash.text.TextField;
    import flash.text.TextFormat;
	import flash.display.BitmapData;
	import flash.text.AntiAliasType;
    import flash.utils.Timer;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class BoostFruit extends BaseBlock {
		
		public var hitbox:Sprite = new Sprite;
		public var trailbox:Sprite = new Sprite;
		public var ready:Boolean;
		public var animphase:Number = 0;
		public var eatAtCounter:Number;
		
		public function BoostFruit(x:Number, y:Number) {
			this.w = 24; this.h = 28;
			this.x = x; this.y = y;
			hitbox.addChild(fruit);
			//fruit.smoothing = true;
			addChild(hitbox);
			addChild(trailbox);
			ready = true;
			fruit.x = -.5*hitbox.width;
			fruit.y = -.5*hitbox.height;
		}
		
		public function eat(ge:GameEngine) {
			ready = false;
			eatAtCounter = ge.testguy.jumpCounter;
		}
		
		var fadeTimer:Timer;
		
		public override function update(g:GameEngine):Boolean {
			this.animate(g);
			if (this.ready && g.testguy.hitTestObject(this.hitbox)) {
				g.testguy.boost = 3;
				g.testguy.canJump = true;
				this.eat(g);
			}
			return false;
		}
		
		public function animate(ge:GameEngine):Boolean {
			var thisref:BoostFruit = this;
			if (trailbox.alpha == 1 && !ready && stage != null) {
				trailbox.graphics.beginFill(0xFFFF00);
				trailbox.graphics.drawCircle((ge.testguy.x+13) - x, (ge.testguy.y+12) - y, 4*ge.testguy.boost);
				trailbox.graphics.endFill();
				if (ge.testguy.boost == 0 || ge.testguy.jumpCounter >= eatAtCounter+3 && fadeTimer == null) {
					fadeTimer = new Timer(40);
					trailbox.alpha -= 0.001;
					fadeTimer.addEventListener(TimerEvent.TIMER,
						function() {
							ready = true;
							trailbox.alpha = roundDec(trailbox.alpha,1);
							trailbox.alpha-=0.1;
							if (trailbox.alpha <= 0) {
								trailbox.graphics.clear();
								trailbox.alpha = 1;
								fadeTimer.stop();
								fadeTimer = null;
							}
							updateAnimation();
						});
					fadeTimer.start();
				}
			}
			updateAnimation();
			return false;
		}
		
		var animcounter:Number = 0;
		var rotatepos:Boolean = true;
		
		private function updateAnimation() {
			hitbox.scaleX = 1-trailbox.alpha;
			hitbox.scaleY = 1-trailbox.alpha;
			if (trailbox.alpha == 1) {
				hitbox.scaleX = 1;
				hitbox.scaleY = 1;
			}
			if (ready) {
				hitbox.visible = true;
			} else {
				hitbox.visible = false;
			}
			if (rotatepos) {
				hitbox.rotation++;
				if (hitbox.rotation >= 30) {
					rotatepos = false;
				}
			} else {
				hitbox.rotation--;
				if (hitbox.rotation <= -30) {
					rotatepos = true;
				}
			}
			
		}
		
		private function clear() {
			while(hitbox.numChildren > 0) {
				hitbox.removeChildAt(0);
			}
		}
		
		private function roundDec(numIn:Number, decimalPlaces:int):Number {
			var nExp:int = Math.pow(10,decimalPlaces) ;
			var nRetVal:Number = Math.round(numIn * nExp) / nExp
			return nRetVal;
		} 
		
		
		public override function type():String {
			return "boostfruit";
		}
		
		[Embed(source='..//img//block//fruit//fruit.png')]
		private var t0:Class;
		private var fruit:Bitmap = new t0;
	}
	
}
