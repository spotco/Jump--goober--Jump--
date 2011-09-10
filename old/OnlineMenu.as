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
	
	
	public class OnlineMenu extends CurrentFunction {
		private var main:JumpDieCreateMain;
		private var POSX0:Number = 131;
		private var POSY0:Number = 240;
		private var POSX1:Number = 156;
		private var POSY1:Number = 282;
		private var POSX2:Number = 115;
		private var POSY2:Number = 326;
		private var POSX3:Number = 177;
		private var POSY3:Number = 374;
		[Embed(source='img//onlinemenu.png')]
		private var t1c:Class;
		private var titlescr1:Bitmap = new t1c();
		[Embed(source='snd//beep.mp3')] 		 
		private var MySound : Class;
		private var sound : Sound;
		
		private var mousearea0:Wall;
		private var mousearea1:Wall;
		private var mousearea2:Wall;
		private var mousearea3:Wall;
		
		private var menupos:Number;
		private var cursor:Guy;
		
		public function OnlineMenu(main:JumpDieCreateMain) {
			this.main = main;
			sound = (new MySound) as Sound;
			menupos = 0;
			
			makemousearea();
			
			main.addChild(titlescr1);
			graphics.beginFill(0xFFF00);
			cursor = new Guy(POSX0,POSY0);
			main.addChild(cursor);
			main.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			var test:Sprite = new Sprite();
			test.x = 0;
			test.y = 0;
			test.width = 50;
			test.height = 50;
			main.addChild(test);
			
			
		}
		
		public function keyPressed(e:KeyboardEvent) {
			if (e.keyCode == Keyboard.DOWN && menupos != 3) {
				menupos++;
				updatePointer();
			} else if (e.keyCode == Keyboard.UP && menupos != 0) {
				menupos--;
				updatePointer();
			} else if (e.keyCode == Keyboard.SPACE) {
				destroy();
				if (menupos == 0) {
					main.currentfunction = new RandomOnlineGame(main); //CHANGE TO BASED ON RATING
				} else if (menupos == 1) {
					main.currentfunction = new RandomOnlineGame(main);
				} else if (menupos == 2) {

				} else if (menupos == 3) {
					main.menuStart(menupos);
				}
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
			} else if (menupos == 3) {
				cursor.changePos(POSX3,POSY3);
			}
		}
		
		public override function destroy() {
			while(main.numChildren > 0) {
    			main.removeChildAt(0);
			}
			main.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
		}
		
		//do this function before adding bg image
		public function makemousearea() {
			mousearea0 = new Wall(172,235,150,24,true);
			mousearea1 = new Wall(188,278,110,24,true);
			mousearea2 = new Wall(145,320,210,24,true);
			mousearea3 = new Wall(203,368,80,20,true);
			
			mousearea0.addEventListener(MouseEvent.MOUSE_OVER,function(){menupos=0;updatePointer();});
			mousearea1.addEventListener(MouseEvent.MOUSE_OVER,function(){menupos=1;updatePointer();});
			mousearea2.addEventListener(MouseEvent.MOUSE_OVER,function(){menupos=2;updatePointer();});
			mousearea3.addEventListener(MouseEvent.MOUSE_OVER,function(){menupos=3;updatePointer();});
			
			mousearea0.addEventListener(MouseEvent.CLICK,function(){destroy();main.currentfunction = new RandomOnlineGame(main);}); //CHANGE TO BASED ON RATING
			mousearea1.addEventListener(MouseEvent.CLICK,function(){destroy();main.currentfunction = new RandomOnlineGame(main);});
			mousearea2.addEventListener(MouseEvent.CLICK,function(){destroy();main.currentfunction = new TypeNameGame(main);});
			mousearea3.addEventListener(MouseEvent.CLICK,function(){destroy();main.menuStart(menupos);});
			
			main.addChild(mousearea0);
			main.addChild(mousearea1);
			main.addChild(mousearea2);
			main.addChild(mousearea3);
		}
		
	}
	
}
