package misc{
	import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	
	public class Fireworks extends Sprite {
		
		var particles:Array = new Array;
		var animtimer:Timer = new Timer(30);
		var recycle:Array = new Array;
		var firecounter:Number = 30;
		
		public function Fireworks() {
			animtimer.addEventListener(TimerEvent.TIMER,update);
			animtimer.start()
		}
		
		private function update(e:TimerEvent) {
			for each(var p:Particle in particles) {
				p.x += p.vx;
				p.y += p.vy;
				p.vy += p.ay;
				p.rotationX+=p.rx;
				p.rotationY+=p.ry;
				p.rotationZ+=p.rz;
				p.alpha-=0.01;
				if (p.alpha <= 0) {
					this.removeChild(p);
					particles.splice(particles.indexOf(p),1);
					p.graphics.clear();
					p.alpha = 1;
					recycle.push(p);
				}
			}
			if (firecounter > 0) {
				generateParticle(-5,250,1);
				generateParticle(505,250,-1);
				firecounter--;
			} else if (this.numChildren == 0 || this.stage == null) {
				animtimer.stop();
				particles = null;
				recycle = null;
				animtimer = null;
			}
		}
		
		private function generateParticle(x:Number, y:Number, vx:Number) {
			var newp:Particle;
			if (recycle.length == 0) {
				newp = new Particle;
			} else {
				newp = recycle.pop();
			}
			
			newp.x = x;
			newp.y = y;
			newp.vy = (-12+Math.random()*5);
			newp.vx = (2+Math.random()*3)*vx;
			newp.ay = 0.2;
			
			newp.rx = Math.random()*3;
			newp.ry = Math.random()*3;
			newp.rx = Math.random()*3;
			
			newp.rotationX = Math.random()*360-180;
			newp.rotationY = Math.random()*360-180;
			newp.rotationZ = Math.random()*360-180;
			
			var size = Math.random()*5+3;
			newp.graphics.lineStyle(0.5,0x222222);
			newp.graphics.lineTo(size,0);
			newp.graphics.lineTo(size,size);
			newp.graphics.lineTo(0,size);
			newp.graphics.lineTo(0,0);
			
			var color = Math.floor(Math.random()*3);
			if (color == 1) {
				newp.graphics.beginFill(0xFFFF00,0.8);
			} else if (color == 2) {
				newp.graphics.beginFill(0xFFA500,0.8);
			} else {
				newp.graphics.beginFill(0x00FF00,0.8);
			}
			
			
			newp.graphics.drawRect(0,0,size,size);
			newp.graphics.endFill();
			this.addChild(newp);
			particles.push(newp);
		}
		
		
		
		
	}
	
}
