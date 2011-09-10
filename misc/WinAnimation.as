package misc {
	import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
		import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class WinAnimation extends Sprite {
		public var animarray:Array;
		public var animphase:Number;
		
		public function WinAnimation() {
			animarray = new Array(f1,f2,f3,f4,f5,f6,f7,f8,f9);
			animphase = 0;
			addChild(animarray[animphase]);
		}
		
		//this code makes me laught and it should make you too
		public function start() {
			var animtimer:Timer = new Timer(70,animarray.length);
			animtimer.addEventListener(TimerEvent.TIMER,function() {
									   			removeChildAt(0);
												addChild(animarray[animphase]);
												animphase++;
									   });
			animtimer.addEventListener(TimerEvent.TIMER_COMPLETE,function() {
									   			animarray = new Array(f9,b1,f9,b2);
												animphase = 0;
												animtimer = new Timer(250);
												animtimer.addEventListener(TimerEvent.TIMER,function(){
																		   		if (numChildren < 0) {
																		   			removeChildAt(0);
																				}
																				addChild(animarray[animphase]);
																				animphase++;
																				if (animphase == animarray.length) {
																					animphase = 0;
																				}
																				if (stage == null) {
																					animtimer.stop();
																				}
																		   });
												animtimer.start();
									   });
			animtimer.start();
		}
		
		[Embed(source='..//img//guywin//1.png')]
		private var d1:Class;
		private var f1:Bitmap = new d1;
		
		[Embed(source='..//img//guywin//2.png')]
		private var d2:Class;
		private var f2:Bitmap = new d2;
		
				[Embed(source='..//img//guywin//3.png')]
		private var d3:Class;
		private var f3:Bitmap = new d3;
		
				[Embed(source='..//img//guywin//4.png')]
		private var d4:Class;
		private var f4:Bitmap = new d4;
		
				[Embed(source='..//img//guywin//5.png')]
		private var d5:Class;
		private var f5:Bitmap = new d5;
		
				[Embed(source='..//img//guywin//6.png')]
		private var d6:Class;
		private var f6:Bitmap = new d6;
		
				[Embed(source='..//img//guywin//7.png')]
		private var d7:Class;
		private var f7:Bitmap = new d7;
		
				[Embed(source='..//img//guywin//8.png')]
		private var d8:Class;
		private var f8:Bitmap = new d8;
		
		[Embed(source='..//img//guywin//9.png')]
		private var d9:Class;
		private var f9:Bitmap = new d9;
		
		[Embed(source='..//img//guywin//blink1.png')]
		private var d10:Class;
		private var b1:Bitmap = new d10;
		
		[Embed(source='..//img//guywin//blink2.png')]
		private var d11:Class;
		private var b2:Bitmap = new d11;
		
		
		
	}
	
}
