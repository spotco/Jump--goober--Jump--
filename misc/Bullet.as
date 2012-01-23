package misc {
	import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
		import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class Bullet extends FalldownBlock {
		
		public var vx:Number;
		public var vy:Number;
		
		public function Bullet(x:Number,y:Number,vx:Number,vy:Number) {
			super(0,0,0,0);
			graphics.clear();
			this.x = x;
			this.y = y;
			this.vx = vx;
			this.vy = vy;
			bullet.x = -.5*bullet.width;
			bullet.y = -.5*bullet.height;
			addChild(bullet);
		}
		
		public override function update(g:GameEngine):Boolean {
			this.x += vx;
			this.y -= vy;
			
			if (this.x < -100 || this.x > 600 || this.y < -100) {
				if (g.deathwall.indexOf(this) >= 0) {
					g.deathwall.splice(g.deathwall.indexOf(this),1);
				} else {
					trace("bullet not part of array");
				}
				if (this.stage != null) {
					g.main.removeChild(this);
					g.bulletsreuse.push(this);
					//trace("bullet removed");
				}
				//this.visible = false;
			}
			
			return super.update(g);
		}
		
						[Embed(source='..//img//boss//flowershot.png')]
		private var imgfhead:Class;
		private var bullet:Bitmap = (new imgfhead) as Bitmap;
		
		
	}
	
}
