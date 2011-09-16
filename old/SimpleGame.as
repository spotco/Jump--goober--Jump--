package currentfunction {
	import flash.display.*;
	import flash.xml.*;
		import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class SimpleGame extends CurrentFunction {
		
		var currentgame:GameEngine;
		var main:JumpDieCreateMain;
		
		var xml:XML;
		var lname:String;
		
		public function SimpleGame(main:JumpDieCreateMain,xml:String,name:String) {
			this.main = main;
			this.xml = new XML(xml);
			this.lname = name;
		}
		
		public override function destroy() {
			this.currentgame = null;
			main.currentfunction = new JumpDieCreateMenu(main);
		}
		
		public override function startLevel() {
			trace(main);
			trace(this);
			trace(this.xml);
			trace(this.lname);
			currentgame = new GameEngine(main,this,this.xml,this.lname);
		}
		
		public override function nextLevel(hitgoal:Boolean) {
			destroy();
		}

	}
	
}
