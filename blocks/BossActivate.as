package blocks {
		import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class BossActivate extends BaseBlock {
		
		private var hp:Number;
		private var maxhp:Number;
		private var hpbar:Sprite = new Sprite;
		private var hpinnerbar:Sprite = new Sprite;
		private var initialfillcounter:Number = 0;
		
		private var startbattle:Boolean = false;
		private var startbattledoneanim:Boolean = false;
		
		private var init:Boolean = false;
		
		private var battlelaunchers:Array = new Array;
		private var showafter:Array = new Array;
		private var theboss:RocketBoss;
		private var timer:Number = 150;
		
		private var doExplode:Boolean = false;
		
		
		public function BossActivate(x:Number,y:Number,w:Number,h:Number,hp:Number = 6,doExplode:String = "no") {
			this.x = x;
			this.y = y;
			this.w = w;
			this.h = h;
			this.graphics.beginFill(0xFF0000,0.5);
			this.graphics.drawRect(0,0,w,h);
			this.hp = hp;
			this.maxhp = hp;
			
			if (doExplode == "yes") {
				trace("explode");
				this.doExplode = true;
			}
		}
		
		public override function update(g:GameEngine):Boolean {
			if (!init) {
				init = true;
				ingameinit(g);
			}
			if (!startbattle && this.hitTestObject(g.testguy)) {
				this.startbattle = true;
				initbattle(g);
			}
			if (initialfillcounter > 0) {
				initialfillcounter--;
				hpinnerbar.scaleX = (70-initialfillcounter)/70;
			}
			if (initialfillcounter == 0 && startbattle && hp > 0) {
				var tarscale:Number = this.hp / this.maxhp;
				if (hpinnerbar.scaleX > tarscale) {
					hpinnerbar.scaleX -= 0.02;
				}
			}
			if (this.hp == 0 && !startbattledoneanim) {
				trace("end");
				startbattledoneanim = true;
				endbattle(g);
			}
			return false;
		}
		
		public function addShowAfter(g:GameEngine) {
			g.main.removeChild(hpbar);
			for each (var bf:BoostFruit in showafter) {
				bf.visible = true;
				bf.activated = true;
				bf.initgrowth = 20;
			}
			g.main.removeChild(this);
			g.particles.splice(g.particles.indexOf(this),1);
		}
		
		private function endbattle(g:GameEngine) {
			hpinnerbar.scaleX = 0;
			for each (var b:FalldownBlock in battlelaunchers) {
				(b as RocketLauncher).range = 2;
			}
			for each (var r:FalldownBlock in g.deathwall) {
				if (r is Rocket) {
					(r as Rocket).explode(g);
				}
			}
			g.main.playsfx(JumpDieCreateMain.rocketbossdiesound);
			theboss.tempdeathanim();
		}
		
		public function hit() {
			this.hp--;
		}
		
		private function initbattle(g:GameEngine) {
			trace("activate");
			hpbar.graphics.lineStyle(3,0xFF0000,0.7);
			hpbar.graphics.moveTo(25,15);
			hpbar.graphics.lineTo(475,15);
			hpbar.graphics.lineTo(475,50);
			hpbar.graphics.lineTo(25,50);
			hpbar.graphics.lineTo(25,15);
			g.main.addChild(hpbar);
			
			hpbar.addChild(hpinnerbar);
			hpinnerbar.graphics.beginFill(0xFF0000,0.7);
			hpinnerbar.x = 30; hpinnerbar.y = 20;
			hpinnerbar.graphics.drawRect(0,0,440,25);
			hpinnerbar.scaleX = 0;
			this.initialfillcounter = 70;
			theboss = new RocketBoss(-99,250);
			if (g.testguy.x > 250) {
				theboss.side = RocketBoss.RIGHT;
			} else {
				theboss.side = RocketBoss.LEFT;
			}
			
			theboss.activatecontroller = this;
			if (this.doExplode) {
				theboss.doExplode = true;
			}
			g.main.addChild(theboss);
			g.deathwall.push(theboss);
			
			for each (var b:FalldownBlock in battlelaunchers) {
				(b as RocketLauncher).range = 450;
			}
		}
		
		private function ingameinit(g:GameEngine) {
			for each (var b:FalldownBlock in g.deathwall) {
				if (b is RocketLauncher && this.hitTestObject(b)) {
					battlelaunchers.push(b as RocketLauncher);
					(b as RocketLauncher).range = 2;
				}
			}
			for each (var bf:BoostFruit in g.boostfruits) {
				if (this.hitTestObject(bf)) {
					showafter.push(bf);
					bf.visible = false;
					bf.activated = false;
				}
			}
			this.graphics.clear();
			this.graphics.beginFill(0x0000FF,0);
			this.graphics.drawRect(0,0,w,h);
			assertfound();
		}
		
		private function assertfound() {
			if (battlelaunchers.length == 0 || showafter.length == 0) {
				trace("could not find launcher or showafter");
			} else {
				trace("found success");
			}
		}
		
		public override function type():String {
			return "bossactivate";
		}

	}
	
}
