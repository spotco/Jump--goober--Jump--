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
	
	public class SubmitMenu extends Sprite {
		private var STOP:Boolean = false;
		
		private var leveleditor:LevelEditor;
		private var bg:Sprite = new Sprite;
		
		private var displayarea:Sprite = new Sprite;
		
		private var errordisplayarea:TextField = new TextField;
		private var levelnameentry:TextField = new TextField;
		private var nameentry:TextField = new TextField;
		
		private var okbutton:Sprite;
		private var time:Number;
		
		public function SubmitMenu(leveleditor:LevelEditor,time:Number) {
			this.leveleditor = leveleditor;
			this.leveleditor.main.addChild(this);
			this.leveleditor.main.addChild(displayarea);
			this.time = time;
			makebg();
			makeasksubmit();
		}
		
		private function makeasksubmit() {
			displayarea.addChild(maketextdisplay(140,150,"Level Complete! Submit to online database?",10));
			var yesbutton:Sprite = new Sprite; yesbutton.x = 188; yesbutton.y = 300;
			yesbutton.addChild(TextWindow.yesbutton);
			yesbutton.addEventListener(MouseEvent.CLICK, function(){
									   		cleardisplayarea();
											makeinfoentry();
									   });
			JumpDieCreateMain.add_mouse_over(yesbutton);
			var nobutton:Sprite = new Sprite; nobutton.x = 288; nobutton.y = 300;
			nobutton.addChild(TextWindow.nobutton);
			nobutton.addEventListener(MouseEvent.CLICK, function() {
									  	leveleditor.clear();
										leveleditor.remake();
									  });
			JumpDieCreateMain.add_mouse_over(nobutton);
			displayarea.addChild(yesbutton);
			displayarea.addChild(nobutton);
		}
		
		private function makeinfoentry() {
			displayarea.addChild(maketextdisplay(155,156,"Enter the name of your level.\n(3-16 characters long, A-Z and 0-9 only)",10,195,43));
			displayarea.addChild(maketextdisplay(155,236,"Enter your name(optional, same rules as above)",10,195,28));
			
			errordisplayarea = maketextdisplay(145,305,"",12,165,45);
			errordisplayarea.textColor = 0xFF0000;
			displayarea.addChild(errordisplayarea);
			
			levelnameentry = maketextentryfield(155,201,10);
			displayarea.addChild(levelnameentry);
			nameentry = maketextentryfield(155,268,10);
			displayarea.addChild(nameentry);
			
			okbutton = new Sprite;
			okbutton.addChild(TextWindow.okbutton);
			okbutton.x = 309; okbutton.y = 317;
			okbutton.addEventListener(MouseEvent.CLICK, function(){
									  		okbutton.visible = false;
									  		errordisplayarea.text = "Verifying text";
											verifydata();
									  });
			JumpDieCreateMain.add_mouse_over(okbutton);
			displayarea.addChild(okbutton);
		}
		
		private function verifydata() {
			var levelname:String = levelnameentry.text;
			var creatorname:String = nameentry.text;
			if (creatorname.length == 0) {
				creatorname = "Anonymous";
			}
			var verify:RegExp = /^[a-zA-Z0-9]{3,16}$/;
			
			if (!verify.test(levelname)) {
				okbutton.visible = true;
				errordisplayarea.text = "Error with your level name.";
				return;
			} else if (!verify.test(creatorname)) {
				okbutton.visible = true;
				errordisplayarea.text = "Error with your user name.";
				return;
			} else if (this.time < 5000) {
				okbutton.visible = true;
				errordisplayarea.text = "Level is too short. Make it longer.";
				return;				
			}
			
			errordisplayarea.text = "Submitting...";
			submitdata(levelname,creatorname,leveleditor.outputXML(levelname).toXMLString());
		}
		
		private var httpstatus:Number = 0;
		
		private function submitdata(levelname:String,creatorname:String,levelcontents:String) {
			var urlvars:URLVariables = new URLVariables();
			urlvars.level_name = levelname;
			urlvars.creator_name = creatorname;
			urlvars.level_data = levelcontents;
			urlvars.pass = "jumpdiecreatesubmit";
			
			var request:URLRequest= new URLRequest(JumpDieCreateMain.ONLINE_DB_URL+'submit.php');
			request.data = urlvars;
			request.method = URLRequestMethod.POST;
			
			var loader:URLLoader = new URLLoader();
			configureErrors(loader);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, function(e:HTTPStatusEvent) {
				httpstatus = e.status;
				trace(e.status);
				if (e.status == 200) {
					loader.addEventListener(Event.COMPLETE,uploadcomplete);
				} else if (e.status == 406) {
					errordisplayarea.text = "DB error: Name already used or duplicate exists.";
				}
			});
    		loader.load(request);
		}
		
		private function uploadcomplete(e:Event) {
			cleardisplayarea();
			displayarea.addChild(maketextdisplay(140,150,e.target.data,10));
			var okbutton:Sprite = new Sprite; okbutton.x = 229; okbutton.y = 300;
			okbutton.addChild(TextWindow.okbutton);
			okbutton.addEventListener(MouseEvent.CLICK, function() {
				leveleditor.clear();
				leveleditor.main.curfunction = new JumpDieCreateMenu(leveleditor.main);
			});
			
			leveleditor.main.localdata.data["submitted_level"] = true;
			leveleditor.main.mochimanager.update_achievements_submit();
									  
			displayarea.addChild(okbutton);
		}
		
		private function configureErrors(dispatcher:IEventDispatcher) {
			dispatcher.addEventListener(NetStatusEvent.NET_STATUS, errorhandle);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorhandle);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR,errorhandle);
		}
		
		private function errorhandle(e:Event) {
			if (httpstatus != 406) {
				errordisplayarea.text = "Network error: "+httpstatus;
			}
			okbutton.visible = true;
		}
		
		private function cleardisplayarea() {
			while(displayarea.numChildren > 0) {
				displayarea.removeChildAt(0);
			}
		}
		
		private function maketextentryfield(x:Number,y:Number,fontSize:Number):TextField {
			var displaytext:TextField = maketextdisplay(x,y,"",fontSize,195,20);
			displaytext.selectable = true;
			displaytext.border = true;
			displaytext.type = "input";
			return displaytext;
		}
		
		public static function maketextdisplay(x:Number,y:Number,t:String,fontSize:Number,width:Number = 240, height:Number = 400):TextField {
			var displaytext:TextField = new TextField();
			displaytext.embedFonts = true;displaytext.antiAliasType = AntiAliasType.ADVANCED;
			displaytext.x=x;displaytext.y=y;displaytext.wordWrap = true;
			displaytext.width=width;displaytext.height=height;
			displaytext.text = t;
			displaytext.selectable=false;
			displaytext.setTextFormat(JumpDieCreateMain.getTextFormat(fontSize));
			displaytext.defaultTextFormat = JumpDieCreateMain.getTextFormat(fontSize)
			return displaytext;
		}
		
		private function makebg() {
			bg.addChild(new JumpDieCreateMenu.t1c as Bitmap);
			var spbubble:Bitmap = JumpDieCreateMenu.getTextBubble();
			spbubble.alpha = 0.8;
			bg.addChild(spbubble);
			var backbutton:Sprite = new Sprite;
			backbutton.addChild(GameEngine.backbuttonimg);
			backbutton.y = 503;
			backbutton.addEventListener(MouseEvent.CLICK,function() {
											leveleditor.clear();
											leveleditor.remake();
										});
			JumpDieCreateMain.add_mouse_over(backbutton);
			bg.addChild(backbutton);
			this.addChild(bg);
		}
		
		
		
	}
	
}
