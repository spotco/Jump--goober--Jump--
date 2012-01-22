package misc {
	import flash.display.*;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
	import flash.text.TextFieldType;
    import flash.geom.Rectangle;
	import flash.net.*;
	import flash.xml.*;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.events.HTTPStatusEvent;
	import flash.events.*;
	import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	import flash.errors.IOError;
	
	public class ReviewSubmitMenu extends Sprite {
		
		var caller:CurrentFunction;
		var callback:Function;
		var main:JumpDieCreateMain;
		var currentlevelinfo:Object;
		
		var loadingmessagedisplay:TextField;
		var stararray:Array = new Array;
		var ui:Sprite;
		
		public function ReviewSubmitMenu(caller:CurrentFunction,callback:Function,main:JumpDieCreateMain,currentlevelinfo:Object) {
			this.caller = caller;
			this.callback = callback;
			this.main = main;
			this.currentlevelinfo = currentlevelinfo;
			submitplaycount();
			main.playSpecific(JumpDieCreateMain.ONLINEEND,false);
			initbg();
			initratingui();
		}
		
		private function submitplaycount() {
			var urlRequest:URLRequest = new URLRequest(JumpDieCreateMain.ONLINE_DB_URL+'updateplaycount.php');
			var vars:URLVariables = new URLVariables;
			vars.nocache = new Date().getTime(); 
			vars["level"] = currentlevelinfo.id;
			vars["checksum"] = JumpDieCreateMain.getChecksum("updateplaycount",currentlevelinfo.id);
			urlRequest.data = vars;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, function(e) {
				trace(e.target.data);
			});
			urlLoader.load(urlRequest);
		}
		
		private function submitrating(r:Number) {
			var urlRequest:URLRequest = new URLRequest(JumpDieCreateMain.ONLINE_DB_URL+'submitreview.php');
			var vars:URLVariables = new URLVariables;
			vars.nocache = new Date().getTime(); 
			vars["level"] = currentlevelinfo.id;
			vars["rating"] = r;
			vars["checksum"] = JumpDieCreateMain.getChecksum("submitreview",currentlevelinfo.id);
			urlRequest.data = vars;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, function(e) {
				trace(e.target.data);
			});
			urlLoader.load(urlRequest);
			var dispinfo:String = "Rating submitted!\n\n";
			dispinfo+="Level Name: "+currentlevelinfo.level_name+"\n";
			dispinfo+="Creator Name: "+currentlevelinfo.creator_name+"\n";
			dispinfo+="Created: "+currentlevelinfo.date_created+"\n\n";
			dispinfo+="Total plays: "+currentlevelinfo.playcount+"\n";
			dispinfo+="Avg Rating: "+currentlevelinfo.ratingavg+"\n";
			dispinfo+="(from "+currentlevelinfo.ratingcount+" ratings)\n";
			
			loadingmessagedisplay.text = dispinfo;
			
			ui = new Sprite;
			var skip:Sprite = new Sprite;
			skip.addChild(new TextWindow.mb3 as Bitmap);
			skip.x = 240;
			skip.y = 330;
			skip.addEventListener(MouseEvent.CLICK, function() {
				callback.call(caller);  
			});
			ui.addChild(skip);
			main.addChild(ui);
		}
		
		private function initratingui() {
			ui = new Sprite;
			for(var i = 1; i <= 5; i++) {
				var s:ReviewStar = new ReviewStar;
				s.val = i;
				s.fill = new starfill as Bitmap;
				s.empty = new starempty as Bitmap;
				s.addChild(s.fill);
				s.addChild(s.empty);
				s.fill.visible = false;
				s.x = 90+i*32;
				s.y = 250;
				ui.addChild(s);
				stararray[i] = s;
				s.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
					main.removeChild(ui);
					submitrating(e.target.val);
				});
				s.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent) {
					for (var j = 1; j <= 5; j++) {
						if (j <= e.target.val) {
							stararray[j].empty.visible = false;
							stararray[j].fill.visible = true;
						} else {
							stararray[j].empty.visible = true;
							stararray[j].fill.visible = false;
						}
					}
				});
			}
			var skip:Sprite = new Sprite;
			skip.addChild(new GameEngine.mb3 as Bitmap);
			skip.x = 340;
			skip.y = 355;
			skip.addEventListener(MouseEvent.CLICK, function() {
				callback.call(caller);  
			});
			ui.addChild(skip);
			main.addChild(ui);
		}
		
		
		
		private function initbg() {
			var dispinfo:String = "Level Complete!\n\n";
			dispinfo+="Level Name: "+currentlevelinfo.level_name+"\n";
			dispinfo+="Creator Name: "+currentlevelinfo.creator_name+"\n";
			dispinfo+="Created: "+currentlevelinfo.date_created+"\n\n";
			dispinfo+="Rate it!";
			
			var bg:Sprite = new Sprite;
			bg.addChild(new JumpDieCreateMenu.t1c as Bitmap);
			var spbubble:Bitmap = JumpDieCreateMenu.getTextBubble();
			spbubble.alpha = 0.8;
			bg.addChild(spbubble);
			var backbutton:Sprite = new Sprite;
			bg.addChild(backbutton);
			loadingmessagedisplay = SubmitMenu.maketextdisplay(118,135,dispinfo,13,276,243);
			loadingmessagedisplay.wordWrap = true;
			bg.addChild(loadingmessagedisplay);			
			bg.addChild(backbutton);
			
			var backbutton:Sprite = new Sprite;
			backbutton.addChild(GameEngine.backbuttonimg);
			backbutton.y = 503;
			backbutton.addEventListener(MouseEvent.CLICK,function() {
				caller.destroy();
			});
			bg.addChild(backbutton);
			
			main.addChild(bg);
		}
		
		[Embed(source='..//img//misc//starfill.png')]
		public static var starfill:Class;
		
		[Embed(source='..//img//misc//starempty.png')]
		public static var starempty:Class;
		
	}
	
}
