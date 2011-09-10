﻿package core {
	import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import flash.geom.Rectangle;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class Guy extends Sprite {
		
		public var vx:Number;
		public var vy:Number;
		public var boost:Number;
		public var canJump:Boolean;
		public var jumpCounter:Number;
		
			
		public function Guy(initx:Number, inity:Number) {
			jumpCounter = 0;
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
		var hashitwall:Boolean = false;
		
		//note: do not include gameengine here, or that will force preloader to include all main game files
		public function update(walls:Array,justWallJumped:Boolean = false) { //checks wall collisions and updates position based on velocity, the most wizardry here
			var isItSlide:Boolean = false;
			updateImg();
			vx*=.99;//friction
			vy*=.99;
			vy+=1;
			
			var checkDepth:Number = 5;
			for (var i = 0; i < Math.abs(vy); i+=checkDepth) { //move y by vy, break into chunks of 1 and remainder
				this.y += SIG_ONE(vy-i,checkDepth);
				if (checkCollision(walls)) {
					if (boost > 0) {
						boost--;
					}
					break;
				}
			}
			
			var yhit:Boolean = false;
			for(var i = 0; i < walls.length; i++) { 
				if (hitTestObject(walls[i].hitbox)) { //if hitting a wall
					canJump = true;
					yhit = true;
					this.y = roundDec(this.y,1); //round position to one decimal
					while (hitTestObject(walls[i].hitbox) && vy != 0) {  //move reverse direction in increments of vy until not hit
						this.y = this.y - SIG(vy);
					}
					if (hitTestObject(walls[i].hitbox)) { //only for spawning inside block, I think
						recursiveOut(walls,1);
						return;
					}
				}
			}
			if (yhit) { //note: do the reverse outside the loop (else will break 2 block case, block1.y = 310, block2.y = 311)
				vy = 0;
				vx = vx/1.2;
			}
			
			for (var i = 0; i < Math.abs(vx); i+=checkDepth) { //move y by vy, break into chunks of 1 and remainder
				this.x += SIG_ONE(vx-i,checkDepth);
				if (checkCollision(walls)) {
					if (boost > 0) {
						boost--;
					}
					break;
				}
			}
			
			var xhit:Boolean = false;
			for(i = 0; i < walls.length; i++) {
				if (hitTestObject(walls[i].hitbox)) {
					isItSlide = true;
					if (!justWallJumped) {
						canJump = true;
					}
					xhit = true;
					this.x = roundDec(this.x,1);
					while (hitTestObject(walls[i].hitbox) && vx != 0) {
						this.x = this.x - SIG(vx);
					}
					if (hitTestObject(walls[i].hitbox)) { //if stuck inside object, recursive out
						recursiveOut(walls,1);
						return;
					}
				}
			}
			if (xhit) {
				vx = -vx/1.1;
			}
			hashitwall = (xhit || yhit);
			isslide = isItSlide; //for walljumping
			if (Math.abs(vx) < 0.01) {
				vx = 0;
			}
		}
				
		private function checkCollision(walls:Array):Boolean {
			for each(var w:Wall in walls) {
				if (Math.abs(w.y-this.y) < 700 && hitTestObject(w.hitbox)) {
					return true;
				}
			}
			return false;
		}
		
		public var animcounter:Number;
		public var toggle:Boolean = false;
		
		private function updateImg() {//updates animation
			animcounter++;
			if (animcounter < 5) {
				return;
			} else {
				animcounter = 0;
				toggle = !toggle;
			}
			while(numChildren > 0) {
    			removeChildAt(0);
			}
			vy = -vy;
			/*if (!canJump) {
				addChild(guyhop);
			} else */if (isslide) {
				if (vx > 0) {
					addChild(guyslideright);
				} else {
					addChild(guyslideleft);
				}
			} else if (vx < -2) {
				if (vy < -.5) {
					addChild(guydownleft);
				} else if (vy > 1.4) {
					addChild(guyupleft);
				} else {
					if (toggle) {
						addChild(guyleft);
					} else {
						addChild(guyleft2);
					}
				}
			} else if (vx > 2) {
				if (vy < -.5) {
					addChild(guydownright);
				} else if (vy > 1.4) {
					addChild(guyupright);
				} else {
					if (toggle) {
						addChild(guyright);
					} else {
						addChild(guyright2);
					}
					
				}
			} else if (vy > .5) {
				addChild(guyup);
			} else if (vy < -.5) {
				addChild(guydown);
			} else {
				addChild(guy);
			}
			
			
			vy = -vy;
		}
		
		public var explodetimer:Timer;
		public var exanimarray:Array;
		public var animframe:Number;
		
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
		
		private function SIG(n:Number):Number {
			if (n < 0) {
				return -.1;
			} else if (n > 0) {
				return .1;
			} else {
				return 0;
			}
		}
		
		public static function roundDec(numIn:Number, decimalPlaces:int):Number {
			var nExp:int = Math.pow(10,decimalPlaces) ;
			var nRetVal:Number = Math.round(numIn * nExp) / nExp
			return nRetVal;
		} 
		
		private function SIG_ONE(n:Number,tar:Number):Number {
			if (Math.abs(n) > tar) {
				if (n < 0) {
					return -tar;
				} else if (n > 0) {
					return tar;
				} else {
					return 0;
				}
			} else {
				return n;
			}
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
		
		[Embed(source='..//img//guyexplode//0.png')]
		private var e0:Class;
		private var ex0:Bitmap = new e0();
		
		[Embed(source='..//img//guyexplode//1.png')]
		private var e1:Class;
		private var ex1:Bitmap = new e1();
		
		[Embed(source='..//img//guyexplode//2.png')]
		private var e2:Class;
		private var ex2:Bitmap = new e2();
		
		[Embed(source='..//img//guyexplode//3.png')]
		private var e3:Class;
		private var ex3:Bitmap = new e3();
		
		
		
		[Embed(source='..//img//guystand.png')]
		private var g1:Class;
		private var guy:Bitmap = new g1();
		
		[Embed(source='..//img//guydown.png')]
		private var g2:Class;
		private var guydown:Bitmap = new g2();
		
		[Embed(source='..//img//guydownleft.png')]
		private var g3:Class;
		private var guydownleft:Bitmap = new g3();
		
		[Embed(source='..//img//guyleft.png')]
		private var g4:Class;
		private var guyleft:Bitmap = new g4();
		
		[Embed(source='..//img//guyupleft.png')]
		private var g5:Class;
		private var guyupleft:Bitmap = new g5();
		
		[Embed(source='..//img//guyup.png')]
		private var g6:Class;
		private var guyup:Bitmap = new g6();
		
		[Embed(source='..//img//guyupright.png')]
		private var g7:Class;
		private var guyupright:Bitmap = new g7();
		
		[Embed(source='..//img//guyright.png')]
		private var g8:Class;
		private var guyright:Bitmap = new g8();
		
		[Embed(source='..//img//guydownright.png')]
		private var g9:Class;
		private var guydownright:Bitmap = new g9();
		
		[Embed(source='..//img//guyslideleft.png')]
		private var g10:Class;
		private var guyslideleft:Bitmap = new g10();
		
		[Embed(source='..//img//guyslideright.png')]
		private var g11:Class;
		private var guyslideright:Bitmap = new g11();
		
		
				[Embed(source='..//img//guyleft2.png')]
		private var g12:Class;
		private var guyleft2:Bitmap = new g12();
		
		[Embed(source='..//img//guyright2.png')]
		private var g13:Class;
		private var guyright2:Bitmap = new g13();
	}
	
	
	
}