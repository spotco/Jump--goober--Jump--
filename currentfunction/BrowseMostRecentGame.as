package currentfunction {
    import flash.display.*;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import flash.utils.Timer;
    import flash.events.*;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.geom.Rectangle;
	import flash.net.*;
	import flash.xml.*;
	import flash.media.Sound;
		import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	import flash.text.engine.SpaceJustifier;
	import flash.sampler.NewObjectSample;
	
	public class BrowseMostRecentGame extends BrowseMostPlayedGame {
		
		public function BrowseMostRecentGame(main:JumpDieCreateMain) {
			super(main);
		}
		
		public override function getXMLListURL():String {
			return 'http://spotcos.com/jumpdiecreate/dbscripts/getrecent.php';
		}
		
		public override function getSelectionDisplayMode():Boolean {
			return true;
		}
		

	}
	
}
