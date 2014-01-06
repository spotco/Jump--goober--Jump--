package  {
	import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import flash.geom.Rectangle;
	import flash.media.Microphone;
	
	public class Guy extends Sprite {
		
		var vx:Number;
		var vy:Number;
		var boost:Number;
		var canJump:Boolean;
			
		public function Guy(initx:Number, inity:Number) {
			boost = 0;
			animcounter = 0;
			isslide = false;
			canJump = false;
			this.x = initx;
			this.y = inity;
			vx = 0; vy = 0;
			addChild(guy);
		}
		
		public function changePos(chx:Number, chy:Number) {
			this.x = chx;
			this.y = chy;
		}
		
		var isslide:Boolean; //is it sliding along a wall? (eyes closed)
		
		public function update(walls:Array) { //checks wall collisions and updates position based on velocity, the most wizardry here
			var isItSlide:Boolean = false;
			this.y = this.y + vy;
			updateImg();
			for(var i = 0; i < walls.length; i++) { //try moving vy in y direction
				if (hitTestObject(walls[i].hitbox)) {
					boost = 0;
					canJump = true;
					this.y = this.y - vy;
					vy = -vy/1.1;
					if (hitTestObject(walls[i].hitbox)) {
						recursiveOut(walls,1);
						return;
					}
				}
			}
			
			this.x = this.x + vx;
			for(i = 0; i < walls.length; i++) { //try moving vx, same process as with y
				if (hitTestObject(walls[i].hitbox)) {
					boost = 0;
					isItSlide = true;
					canJump = true;
					this.x = this.x - vx;
					vx = -vx/1.1;
					if (hitTestObject(walls[i].hitbox)) {
						recursiveOut(walls,1);
						return;
					}
				}
			}
			isslide = isItSlide;
			vx*=.97;//friction
			vy*=.99;
			vy+=1;
		}
		
		private function recursiveOut(walls:Array,dist:Number) {
			trace("enterrecurse"+dist);
			this.x += dist;
			//regular
			if (!checkCollision(walls)) {
				trace("exit x+"+dist);
				return;
			}
			this.x -= dist;
			
			this.y += dist;
			if (!checkCollision(walls)) {
				trace("exit y+"+dist);
				return;
			}
			this.y -= dist;
			
			this.x -= dist;
			if (!checkCollision(walls)) {
				trace("exit x-"+dist);
				return;
			}
			this.x += dist;
			
			this.y -= dist;
			if (!checkCollision(walls)) {
				trace("exit y-"+dist);
				return;
			}
			this.y += dist;
			
			recursiveOut(walls,dist+1);
		}
		
		
		private function checkCollision(walls:Array):Boolean {
			for each(var w:Wall in walls) {
				if (Math.abs(w.y-this.y) < 700 && hitTestObject(w.hitbox)) {
					return true;
				}
			}
			return false;
		}
		
		var animcounter:Number;
		private function updateImg() {//updates animation
			animcounter++;
			if (animcounter < 5) {
				return;
			} else {
				animcounter = 0;
			}
			while(numChildren > 0) {
    			removeChildAt(0);
			}
			//trace("vx:"+vx+" vy:"+vy);
			vy = -vy;
			if (!canJump) {
				addChild(guyhop);
			} else if (isslide) {
				addChild(guyclose);
			} else if (vx < -2) {
				if (vy < -.5) {
					addChild(guydownleft);
				} else if (vy > 1.4) {
					addChild(guyupleft);
				} else {
					addChild(guyleft);
				}
			} else if (vx > 2) {
				if (vy < -.5) {
					addChild(guydownright);
				} else if (vy > 1.4) {
					addChild(guyupright);
				} else {
					addChild(guyright);
				}
			} else if (vy > 1.9) {
				addChild(guyup);
			} else if (vy < -.5) {
				addChild(guydown);
			} else {
				addChild(guy);
			}
			
			
			vy = -vy;
		}
		
		var explodetimer:Timer;
		var exanimarray:Array;
		var animframe:Number;
		
		public function explode() {//when called, does self-contained explode animation using particle class
			ex0.x = -8; ex0.y = -8; ex1.x = -8; ex1.y = -8; ex2.x = -8; ex2.y = -8; ex3.x = -8; ex3.y = -8;
			while(numChildren > 0) {
    			removeChildAt(0);
			}
			exanimarray = new Array(ex0,ex1,ex2,ex3);
			explodetimer = new Timer(40);
            explodetimer.addEventListener(TimerEvent.TIMER, animupdate);
            explodetimer.start();
			animframe = 0;
		}
		
		public function animupdate(e:TimerEvent) {
			if (this.stage == null) {
				explodetimer.stop();
			}
			vx = 0;
			vy = 0;
			if (animframe < 4) {
				while(numChildren > 0) {
					removeChildAt(0);
				}
				addChild(exanimarray[animframe]);
				animframe++;
			} else {
				if (animframe == 4) {
					while(numChildren > 0) {
						removeChildAt(0);
					}
					animframe++;
					exanimarray = new Array();
					for (var i = 0; i < 24; i++) {
						var particle = new Particle;
						var randSpd = Math.random()*10;
						particle.graphics.beginFill(0x76C346);
						particle.graphics.drawCircle(0,0,2);
						particle.x = 14; particle.y = 12;
						particle.vx = Math.sin(i*(Math.PI/12))*randSpd;
						particle.vy = Math.cos(i*(Math.PI/12))*randSpd;
						exanimarray.push(particle);
						addChild(particle);
					}
				} else {
					for each (var p:Particle in exanimarray) {
						p.x += p.vx;
						p.y += p.vy;
					}
				}
				
			}
		}
		
		[Embed(source='img//guyexplode//0.png')]
		private var e0:Class;
		private var ex0:Bitmap = new e0();
		
		[Embed(source='img//guyexplode//1.png')]
		private var e1:Class;
		private var ex1:Bitmap = new e1();
		
		[Embed(source='img//guyexplode//2.png')]
		private var e2:Class;
		private var ex2:Bitmap = new e2();
		
		[Embed(source='img//guyexplode//3.png')]
		private var e3:Class;
		private var ex3:Bitmap = new e3();
		
		
		
		[Embed(source='img//guystand.png')]
		private var g1:Class;
		private var guy:Bitmap = new g1();
		
		[Embed(source='img//guydown.png')]
		private var g2:Class;
		private var guydown:Bitmap = new g2();
		
		[Embed(source='img//guydownleft.png')]
		private var g3:Class;
		private var guydownleft:Bitmap = new g3();
		
		[Embed(source='img//guyleft.png')]
		private var g4:Class;
		private var guyleft:Bitmap = new g4();
		
		[Embed(source='img//guyupleft.png')]
		private var g5:Class;
		private var guyupleft:Bitmap = new g5();
		
		[Embed(source='img//guyup.png')]
		private var g6:Class;
		private var guyup:Bitmap = new g6();
		
		[Embed(source='img//guyupright.png')]
		private var g7:Class;
		private var guyupright:Bitmap = new g7();
		
		[Embed(source='img//guyright.png')]
		private var g8:Class;
		private var guyright:Bitmap = new g8();
		
		[Embed(source='img//guydownright.png')]
		private var g9:Class;
		private var guydownright:Bitmap = new g9();
		
		[Embed(source='img//guyclose.png')]
		private var g10:Class;
		private var guyclose:Bitmap = new g10();
		
		[Embed(source='img//guyhop.png')]
		private var g11:Class;
		private var guyhop:Bitmap = new g11();
		
	}
	
	
	
}