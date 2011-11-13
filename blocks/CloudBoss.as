package blocks {
	import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class CloudBoss extends FalldownBlock {
		
		var cloudcontainer:Sprite = new Sprite;
		var cloudbody:Sprite = new Sprite;
		var thunderbody:Sprite = new Sprite;
		var thunderhitbox:Sprite = new Sprite;
		
		var backgroundcontainer:Sprite = new Sprite;
		var particlesarray:Array = new Array;
		var backgroundfill:Sprite = new Sprite;
		
		var followtime:Number = 75;
		var flashtime:Number = 50;
		var snowspeed:Number = 2;
		
		var trackingtimer:Number = followtime;
		var tracking:Boolean = true;
		
		var hitbox_opacity = 0.0;
		
		public function CloudBoss() {
			super(0,0,0,0);
			thunderhitbox.graphics.beginFill(0x00FF00,hitbox_opacity);
			thunderhitbox.graphics.drawRect(0,0,28,520);
			cloudcontainer.addChild(thunderhitbox);
			thunderbody.addChild(cloudthunder);
			thunderbody.x = -25;
			thunderbody.y = 25;
			cloudcontainer.addChild(thunderbody);
			thunderbody.visible = false;
			cloudbody.x = -144;
			cloudbody.y = -75;
			cloudbody.addChild(cloud1);
			cloudbody.addChild(cloud2);
			cloudbody.addChild(cloud3);
			cloudcontainer.addChild(cloudbody);
			this.addChild(backgroundcontainer);
			this.addChild(cloudcontainer);
			backgroundfill.graphics.beginFill(0x000000);
			backgroundfill.graphics.drawRect(0,0,500,520);
			backgroundfill.alpha = 0.1;
			backgroundcontainer.addChild(backgroundfill);
		}
		
		public override function type():String {
			return "cloudboss";
		}
		
		public override function update(g:GameEngine):Boolean {
			if (this.stage != null) {
				g.main.setChildIndex(this,g.main.numChildren-1);
			}
			backgroundupdate();
			if (tracking) {
				cloudflash(0);
				cloudtrack(g.testguy.x,7);
				
				trackingtimer--;
				if (trackingtimer <= 0) {
					if (Math.abs(cloudcontainer.x - g.testguy.x) > 5) {
						trackingtimer=1;
						return;
					}
					trackingtimer = flashtime;
					tracking = false;
				}
			} else {
				if (trackingtimer > 10) { //50-10 flash
					cloudflash(trackingtimer%10);
					trackingtimer--;
				} else { //thunder
					thunderbody.visible = true;
					if (trackingtimer > 5) {
						thunderbody.alpha = ((10-trackingtimer)/5);
					} else {
						thunderbody.alpha = ((trackingtimer)/5);
					}
					trackingtimer--;
					if (trackingtimer == 5) {
						harder();
					}
					if (trackingtimer <= 0) {
						thunderbody.visible = false;
						tracking = true;
						trackingtimer = followtime;
					}
					if (thunderbody.alpha > 0.3) {
						return checkhit(g);
					}
				}
			}
			//thunderbody.visible = true;
		}
		
		private function harder() {
			if (snowspeed < 10) {
				snowspeed++;
			}
			if (backgroundfill.alpha < 0.6) {
				backgroundfill.alpha += 0.03;
				//trace(backgroundfill.alpha);
			}
			if (followtime > 25) {
				followtime-=5;
			}
			/*if (flashtime > 25) {
				flashtime-=2;
			}*/
			
		}
		
		private function checkhit(g:GameEngine):Boolean {
			if (g.testguy.hitTestObject(thunderhitbox)) {
				thunderbody.alpha = 1;
				g.main.setChildIndex(g.testguy,g.main.numChildren-1);
				return guyhit(g);
			}
		}
		
		private function backgroundupdate() {
			//trace(particlesarray.length + " " + backgroundcontainer.numChildren);
			
			for (var i = 1; i < (Math.random()*snowspeed); i++) {
				var newp:Particle = new Particle;
				newp.vx = 7;
				newp.vy = 5;
				if (Math.round(Math.random()*10)>5) {
					newp.x = 500*Math.random();
				} else {
					newp.y = 500*Math.random();
				}
				newp.graphics.beginFill(0xFFFFFF);
				newp.graphics.drawCircle(0,0,1);
				backgroundcontainer.addChild(newp);
				particlesarray.push(newp);
			}
			for each(var p:Particle in particlesarray) {
				p.x+=p.vx;
				p.y+=p.vy;
				if ((p.x > 500 || p.y > 520)&& p.stage != null ) {
					backgroundcontainer.removeChild(p);
					particlesarray.splice(particlesarray.indexOf(p),1);
				}
			}
		}
		
		private function cloudtrack(tarx:Number,spd:Number) {
			if (Math.abs(tarx-cloudcontainer.x) < spd) {
				spd = Math.abs(tarx-cloudcontainer.x);
			}
			if(tarx > cloudcontainer.x) {
			   cloudcontainer.x += spd;
			} else if (tarx < cloudcontainer.x) {
				cloudcontainer.x -= spd;
			}
		}
		
		private function cloudflash(t:Number) {
			if (t > 7) {
				cloud1.visible = true; cloud2.visible = false; cloud3.visible = false;
			} else if (t > 3) {
				cloud1.visible = false; cloud2.visible = true; cloud3.visible = false;
			} else {
				cloud1.visible = false; cloud2.visible = false; cloud3.visible = true;
			}
		}
		
		public override function gameScroll(scroll_spd:Number) {
			return;
		}
		
				[Embed(source='..//img//boss//cloud1.png')]
		private var imgfhead:Class;
		private var cloud1:Bitmap = (new imgfhead) as Bitmap;
		
						[Embed(source='..//img//boss//cloud2.png')]
		private var imgfhead2:Class;
		private var cloud2:Bitmap = (new imgfhead2) as Bitmap;
		
						[Embed(source='..//img//boss//cloud3.png')]
		private var imgfhead3:Class;
		private var cloud3:Bitmap = (new imgfhead3) as Bitmap;
		
						[Embed(source='..//img//boss//cloudthunder.png')]
		private var imgfstem:Class;
		private var cloudthunder:Bitmap = (new imgfstem) as Bitmap;
		
	}
	
}
