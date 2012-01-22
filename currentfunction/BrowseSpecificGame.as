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
	import flash.text.*;
	import flash.sampler.NewObjectSample;
	
	public class BrowseSpecificGame extends BrowseMostPlayedGame {
		
		var entryfield:TextField;
		var okbutton:Sprite;
		var searchquery:String;
		
		public function BrowseSpecificGame(main:JumpDieCreateMain) {
			super(main,true);
			this.loadingdisplay.x = 120;
			this.loadingdisplay.y = 80;
			this.loadingdisplay.width = 300;
			this.loadingdisplay.text = "Please enter a name or partial name to search for.";
			
			entryfield = new TextField();
			entryfield.embedFonts = true; entryfield.antiAliasType = AntiAliasType.ADVANCED;
			entryfield.x = 120; entryfield.y = 190;entryfield.width=270;entryfield.height=28;
			entryfield.border = true;entryfield.type = "input";entryfield.text = "";
			entryfield.defaultTextFormat = JumpDieCreateMain.getTextFormat(18);
			entryfield.setTextFormat(JumpDieCreateMain.getTextFormat(18));
			main.addChild(entryfield);
			
			okbutton = new Sprite;
			okbutton.x = 355; okbutton.y = 230;
			okbutton.addChild(new TextWindow.mb3 as Bitmap);
			okbutton.addEventListener(MouseEvent.CLICK,start);
			main.addChild(okbutton);
			
		}
		
		private function start(e) {
			searchquery = entryfield.text;
			while(main.numChildren > 0) {
				main.removeChildAt(0);
			}
			initbg();
			loaddisplay();
		}
		
		public override function getXMLListURL():String {
			return 'http://spotcos.com/jumpdiecreate/dbscripts/getbyname.php';
		}
		
		public override function addURLParam(a:URLVariables):URLVariables {
			a.targetname = this.searchquery;
			return a;
		}
		
		public override function getSelectionDisplayMode():Boolean {
			return true;
		}
		

	}
	
}
