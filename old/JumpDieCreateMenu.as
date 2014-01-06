package  {
	import flash.display.*;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.geom.Rectangle;
	import flash.net.*;
	import flash.xml.*;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.net.*;
	import flash.xml.*;
	import flash.media.Sound;
	
	
	public class JumpDieCreateMenu extends CurrentFunction {
		private var main:JumpDieCreateMain;
		private var POSX0:Number = 144;
		private var POSY0:Number = 240;
		private var POSX1:Number = 160;
		private var POSY1:Number = 282;
		private var POSX2:Number = 119;
		private var POSY2:Number = 326;
		[Embed(source='img//misc//menubg0.png')]
		private var t1c:Class;
		private var titlescr1:Bitmap = new t1c();
		
		[Embed(source='img//soundon.png')]
		private var mb1:Class;
		private var muteoff:Bitmap = new mb1();
		
		[Embed(source='img//soundoff.png')]
		private var mb2:Class;
		private var muteon:Bitmap = new mb2();
		
		[Embed(source='snd//beep.mp3')] 		 
		private var MySound : Class;
		private var sound : Sound;
		
		private var mousearea0:Wall;
		private var mousearea1:Wall;
		private var mousearea2:Wall;
		private var mutebutton;
		
		private var menupos:Number;
		private var cursor:Guy;
		
		public function JumpDieCreateMenu(main:JumpDieCreateMain) {
			
			this.main = main;
			sound = (new MySound) as Sound;
			menupos = 0;
			main.playMenu();
			makemousearea();
			
			main.addChild(titlescr1);
			graphics.beginFill(0xFFF00);
			cursor = new Guy(POSX0,POSY0);
			main.addChild(cursor);
			main.cstage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			main.cstage.focus = main.cstage;
			makemutebutton();
		}
		
		public function makemutebutton() {
			mutebutton = new Sprite();
			changemutebuttonicon();
			mutebutton.addEventListener(MouseEvent.CLICK, function(){
										main.stop();
										main.mute = !main.mute; 
										changemutebuttonicon();
										if (!main.mute) {
											main.playMenu();
										}
										});
			main.addChild(mutebutton);
		}
		
		public function changemutebuttonicon() {
			while(mutebutton.numChildren > 0) {
    			mutebutton.removeChildAt(0);
			}
			if (main.mute) {
				mutebutton.addChild(muteon);
			} else {
				mutebutton.addChild(muteoff);
			}
		}
		
		public function keyPressed(e:KeyboardEvent) {
			if (e.keyCode == Keyboard.DOWN && menupos != 2) {
				menupos++;
				updatePointer();
			} else if (e.keyCode == Keyboard.UP && menupos != 0) {
				menupos--;
				updatePointer();
			} else if (e.keyCode == Keyboard.SPACE) {
				destroy();
				main.menuStart(menupos);
			}
		}
		
		public function updatePointer() {
			if (!main.mute) {
				sound.play(0,1);
			}
			if (menupos == 0) {
				cursor.changePos(POSX0,POSY0);
			} else if (menupos == 1) {
				cursor.changePos(POSX1,POSY1);
			} else if (menupos == 2) {
				cursor.changePos(POSX2,POSY2);
			}
		}
		
		public override function destroy() {
			while(main.numChildren > 0) {
    			main.removeChildAt(0);
			}
			main.cstage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
		}
		
		//do this function before adding bg image
		public function makemousearea() {
			mousearea0 = new Wall(172,235,150,24,true);
			mousearea1 = new Wall(188,278,110,24,true);
			mousearea2 = new Wall(145,320,210,24,true);
			
			mousearea0.addEventListener(MouseEvent.MOUSE_OVER,function(){menupos=0;updatePointer();});
			mousearea1.addEventListener(MouseEvent.MOUSE_OVER,function(){menupos=1;updatePointer();});
			mousearea2.addEventListener(MouseEvent.MOUSE_OVER,function(){menupos=2;updatePointer();});
			
			mousearea0.addEventListener(MouseEvent.CLICK,function(){destroy();main.menuStart(menupos);});
			mousearea1.addEventListener(MouseEvent.CLICK,function(){destroy();main.menuStart(menupos);});
			mousearea2.addEventListener(MouseEvent.CLICK,function(){destroy();main.menuStart(menupos);});
			
			main.addChild(mousearea0);
			main.addChild(mousearea1);
			main.addChild(mousearea2);
			

		}
		
	}
	
}
