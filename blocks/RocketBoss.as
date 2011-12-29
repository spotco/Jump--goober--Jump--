package blocks {
		import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class RocketBoss extends FalldownBlock {
		
		private var animtimer:Number = 0;
		
		public function RocketBoss(x:Number,y:Number) {
			super(0,0,0,0);
			this.x = x;
			this.y = y;
			this.addChild(bodyimg);
			
			rp1.x = 52-29; rp1.y = 104;
			rp2.x = 52-29; rp2.y = 104;
			rp3.x = 52-29; rp3.y = 104;
			
			rp1.visible = true;
			rp2.visible = false;
			rp3.visible = false;
			
			this.addChild(rp1);
			this.addChild(rp2);
			this.addChild(rp3);
		}
		
		public override function update(g:GameEngine):Boolean {
			animtimer++;
			if (animtimer > 3) {
				animtimer = 0;
				if (rp1.visible) {
					rp1.visible = false; rp2.visible = true; rp3.visible = false;
				} else if (rp2.visible) {
					rp1.visible = false; rp2.visible = false; rp3.visible = true;
				} else if (rp3.visible) {
					rp1.visible = true; rp2.visible = false; rp3.visible = false;
				}
			}
			return false;
		}
		
		[Embed(source='..//img//boss//rocketboss.png')]
		private var imgfstem:Class;
		private var bodyimg:Bitmap = (new imgfstem) as Bitmap;
		
				[Embed(source='..//img//boss//rocketpropeller1.png')]
		private var rp1d:Class;
		private var rp1:Bitmap = (new rp1d) as Bitmap;
		
				[Embed(source='..//img//boss//rocketpropeller2.png')]
		private var rp2d:Class;
		private var rp2:Bitmap = (new rp2d) as Bitmap;
		
				[Embed(source='..//img//boss//rocketpropeller3.png')]
		private var rp3d:Class;
		private var rp3:Bitmap = (new rp3d) as Bitmap;
		
	}
	
}
