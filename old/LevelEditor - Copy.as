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
	
	public class LevelEditor extends CurrentFunction {
		var main:JumpDieCreateMain;
		var playerspawn:Guy;
		var xmllist:Array;
		var numobjdisplay:TextField;
		var currentgame:GameEngine;
		
		var rectList:Array;
		var currenty:Number;
		var keydown:Boolean;
		
		var cboxx:Number;
		var cboxy:Number;
		
		var currenttype:Number;
		
		public function LevelEditor(main:JumpDieCreateMain) {
			xmllist = new Array();
			currenty = 0;
			this.main = main;
			main.stop();
			makeui();
			
			playerspawn = new Guy(250,250);
			main.addChildAt(playerspawn,0);
			currenttype = 0; //0-wall,1-deathbox,2-boost,3-goal, 4-text
			
			
			rectList = new Array();
			editorKeyListeners();
		}
		
		public function editorKeyListeners() {
			main.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			main.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			main.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			main.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		public function onMouseDown(e:MouseEvent) {
			keydown = true;
			cboxx = main.stage.mouseX;
			cboxy = main.stage.mouseY;
			ststo = main.stage.mouseY+currenty;
		}
		
		public function onMouseUp(e:MouseEvent) {
			keydown = false;
			if (main.stage.mouseY <= 500) {
				if (currenttype==4) {
					clearlisteners(); 
					var newtextobject:TextWindow = new TextWindow("What text would you like to be displayed?",this,
																  function(){
																	  if (newtextobject.entryfield.text.length > 0) {
																		  xmllist.push('<textfield x="'+cboxx+'" y="'+ststo+'" text="'+newtextobject.entryfield.text+'" ></textfield>');
																		  var s:Textdisplay = new Textdisplay(cboxx,cboxy,newtextobject.entryfield.text);
																		  main.addChildAt(s,0);
																		  rectList.push(s);
																		  editorKeyListeners();
																		  main.removeChild(newtextobject);
																		  update_numobjdisplay();
																	  } else {
																		  main.removeChild(newtextobject);
																		  editorKeyListeners();
																	  }
																  });
					main.addChild(newtextobject);
					return;
				}
				if ( Math.abs((main.stage.mouseX-cboxx)) < 8 || Math.abs(((main.stage.mouseY+currenty)-ststo)) < 8) {
					trace("too thin");
					return;
				}
				if (currenttype==0) {
					var newwall:Wall = new Wall(cboxx,cboxy,main.stage.mouseX-cboxx,main.stage.mouseY-cboxy);
					xmllist.push('<wall x="'+cboxx+'" y="'+ststo+'" width="'+(main.stage.mouseX-cboxx)+'" height="'+((main.stage.mouseY+currenty)-ststo)+'"></wall>');
					main.addChildAt(newwall,0);
					rectList.push(newwall);
					//trace("ending box: "+stage.mouseX+","+(stage.mouseY+currenty));
				} else if (currenttype==1) {
					var newwallf:FalldownBlock = new FalldownBlock(cboxx,cboxy,main.stage.mouseX-cboxx,main.stage.mouseY-cboxy);
					xmllist.push('<deathwall x="'+cboxx+'" y="'+ststo+'" width="'+(main.stage.mouseX-cboxx)+'" height="'+((main.stage.mouseY+currenty)-ststo)+'"></deathwall>');
					main.addChildAt(newwallf,0);
					rectList.push(newwallf);
					//trace("ending box: "+stage.mouseX+","+(stage.mouseY+currenty));
				} else if (currenttype==2) {
					var newwallb:Boost = new Boost(cboxx,cboxy,main.stage.mouseX-cboxx,main.stage.mouseY-cboxy);
					xmllist.push('<boost x="'+cboxx+'" y="'+ststo+'" width="'+(main.stage.mouseX-cboxx)+'" height="'+((main.stage.mouseY+currenty)-ststo)+'"></boost>');
					main.addChildAt(newwallb,0);
					rectList.push(newwallb);
					//trace("ending box: "+stage.mouseX+","+(stage.mouseY+currenty));
				} else if (currenttype==3) {
					var newwallg:Goal = new Goal(cboxx,cboxy,main.stage.mouseX-cboxx,main.stage.mouseY-cboxy);
					xmllist.push('<goal x="'+cboxx+'" y="'+ststo+'" width="'+(main.stage.mouseX-cboxx)+'" height="'+((main.stage.mouseY+currenty)-ststo)+'"></goal>');
					main.addChildAt(newwallg,0);
					rectList.push(newwallg);
				}
			}
			update_numobjdisplay();
		}
		
		var ststo:Number;
		public function onKeyPress(e:KeyboardEvent) {
			if (e.keyCode == Keyboard.UP && !keydown) {
				currenty-=5;
				//trace(currenty);
				for each(var i:DisplayObject in rectList) {
					i.y+=5;
				}
				playerspawn.y+=5;
			} else if (e.keyCode == Keyboard.DOWN && !keydown) {
				currenty+=5;
				//trace(currenty);
				for each(var i:DisplayObject in rectList) {
					i.y-=5;
				}
				playerspawn.y-=5;
			}
			update_numobjdisplay();
		}
		
		public function onKeyUp(e:KeyboardEvent) {
			if (e.keyCode == Keyboard.Z) {
				undo();
			} else if (e.keyCode == Keyboard.P) {
				//trace(outputXML().toXMLString());
				startLevel();
			}
		}
		
		public override function startLevel() {
			clear();
			trace(outputXML("new_level").toXMLString());
			currentgame = new GameEngine(main,this,outputXML("new_level"),"new_level");
			currentgame.skipbuttontext.text = "BACK";
		}
		
		
		public function remake() {
			makeui();
			main.addChild(playerspawn);
			for each (var s:Sprite in rectList) {
				main.addChildAt(s,0);
			}
			editorKeyListeners();
		}
		
		public function outputXML(name:String):XML {
			var textout = '<level name="'+name+'">';
			for each (var s:String in xmllist) {
					textout += s;
			}
			textout += "</level>";
			var output:XML= new XML(textout);
			return output;
		}
		
		public function undo() {
			if (rectList.length <= 0) {
					return;
				}
			main.removeChild(rectList.pop());
			xmllist.pop();
			update_numobjdisplay();
		}
		
		var menubutton:Boost;
		var menubuttontext:TextField;
		var playbutton:Boost;
		var playbuttontext:TextField;
		var undobutton:Boost;
		var undobuttontext:TextField;
		
		var blueselector:Wall;
		var redselector:FalldownBlock;
		var yellowselector:Boost;
		var greenselector:Goal;
		var textboxselector:Wall;
		var textboxselectortext:TextField;
		
		public function makeui() {
			var yellow:TextFormat = new TextFormat();
            yellow.size = 10;
			yellow.color = 0xFFFF00;
			var black:TextFormat = new TextFormat();
            black.size = 10;
			black.color = 0x000000;
			
			menubutton = new Boost(460,500,40,20);
			main.addChild(menubutton);
			menubuttontext = new TextField();
			menubuttontext.x=465;
			menubuttontext.defaultTextFormat=black;
			menubuttontext.y=503;
			menubuttontext.width=40;
			menubuttontext.selectable=false;
			menubuttontext.text="MENU";
			main.addChild(menubuttontext);
			menubutton.addEventListener(MouseEvent.CLICK,function(){destroy();});
			menubuttontext.addEventListener(MouseEvent.CLICK,function(){destroy();});
			
			playbutton = new Boost(410,500,40,20);
			main.addChild(playbutton);
			playbuttontext = new TextField();
			playbuttontext.x=409;
			playbuttontext.defaultTextFormat=black;
			playbuttontext.y=503;
			playbuttontext.width=50;
			playbuttontext.selectable=false;
			playbuttontext.text="PLAY(P)";
			main.addChild(playbuttontext);
			playbutton.addEventListener(MouseEvent.CLICK,function(){startLevel();});
			playbuttontext.addEventListener(MouseEvent.CLICK,function(){startLevel();});
			
			undobutton = new Boost(360,500,40,20);
			main.addChild(undobutton);
			undobuttontext = new TextField();
			undobuttontext.x=358;
			undobuttontext.defaultTextFormat=black;
			undobuttontext.y=503;
			undobuttontext.width=50;
			undobuttontext.selectable=false;
			undobuttontext.text="UNDO(Z)";
			main.addChild(undobuttontext);
			undobutton.addEventListener(MouseEvent.CLICK,function(){undo();});
			undobuttontext.addEventListener(MouseEvent.CLICK,function(){undo();});
			
			blueselector = new Wall(0,500,20,20);
			blueselector.addEventListener(MouseEvent.CLICK,function(){currenttype = 0;});
			redselector = new FalldownBlock(25,500,20,20);
			redselector.addEventListener(MouseEvent.CLICK,function(){currenttype = 1;});
			yellowselector = new Boost(50,500,20,20);
			yellowselector.addEventListener(MouseEvent.CLICK,function(){currenttype = 2;});
			greenselector = new Goal(75,500,20,20);
			greenselector.addEventListener(MouseEvent.CLICK,function(){currenttype = 3;});
			
			main.addChild(blueselector);
			main.addChild(redselector);
			main.addChild(yellowselector);
			main.addChild(greenselector);
			
			textboxselector = new Wall(0,0,0,0);
			textboxselector.whitemode(100,500,20,20);
			main.addChild(textboxselector);
			textboxselectortext = new TextField();
			textboxselectortext.x=105;
			textboxselectortext.defaultTextFormat=black;
			textboxselectortext.y=503;
			textboxselectortext.width=40;
			textboxselectortext.selectable=false;
			textboxselectortext.text="T";
			main.addChild(textboxselectortext);
			textboxselector.addEventListener(MouseEvent.CLICK,function(){currenttype = 4;});
			textboxselectortext.addEventListener(MouseEvent.CLICK,function(){currenttype = 4;});
			
			numobjdisplay = new TextField();
			numobjdisplay.x=125;
			numobjdisplay.defaultTextFormat=yellow;
			numobjdisplay.y=503;
			numobjdisplay.width=200;
			numobjdisplay.selectable=false;
			update_numobjdisplay();
			main.addChild(numobjdisplay);
		}
		
		public function update_numobjdisplay() {
			numobjdisplay.text = "TOTAL_OBJS: "+xmllist.length+" YPOS: "+(-currenty);
		}
		
		public override function destroy() {
			clear();
			main.currentfunction = new JumpDieCreateMenu(main);
		}
		
		public function clear() {
			while(main.numChildren > 0) {
    			main.removeChildAt(0);
			}
			clearlisteners();
		}
		
		public function clearlisteners() {
			main.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			main.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			main.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			main.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		var confirmsave:TextWindow;
		
		public override function nextLevel(hitgoal:Boolean) {
			if (!hitgoal) {
				remake();
			} else {
				confirmsave = new TextWindow("", this, function(){});
				confirmsave.yesnobox("Level Completed. Save and send to server?", function(){entername();}, function(){main.removeChild(confirmsave);remake();});
				main.addChild(confirmsave);
			}
		}
		
		private function entername() {
			main.removeChild(confirmsave);
			var msg:String = "Enter the name of your level. It needs to be 3 or more but no greater than 16 letters , using capital or lowercase letters and numbers only. The server will also check if the name is available.";
			confirmsave = new TextWindow(msg,this,function(){verify(confirmsave.entryfield.text);});
			main.addChild(confirmsave);
		}
		
		var timeouttimer:Timer;
		var success:Boolean;
		var sname:String;
		
		private function verify(name:String) {
			sname = name;
			main.removeChild(confirmsave);
			confirmsave = new TextWindow("",this,function(){});
			confirmsave.messagebox("sending...");
			main.addChild(confirmsave);
			if (name.length > 16 || name.length < 3) {
				verifyfail("Your name length is either too long or too short. Retry sending?");
				return;
			}
			for each (var node:XML in outputXML("testoutput").goal) {
				if (node.@y > -100) {
					verifyfail("Your goal(green) squares need to be at least 300 pixels away from the spawn. Try making your level longer. Retry sending?");
					return;
				}
			}
			timeouttimer = new Timer(6000,1);
			success = false;
			timeouttimer.addEventListener(TimerEvent.TIMER,function() {
										  		if (!success) {
													timeouttimer.stop();
													timeouttimer = null;
													verifyfail("Request timed out. Retry?");
												}
										  });
			timeouttimer.start();
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, uploadcomplete);
    		var request:URLRequest= new URLRequest("send.php"+'?name='+name+'&pass='+"upload");
    		request.contentType = "text/xml";
   			request.data = outputXML(name).toXMLString(); // convert to a string
    		request.method = URLRequestMethod.POST;     
    		loader.load(request); 
			//trace(name);
		}
		
		function uploadcomplete(event:Event):void {
			main.removeChild(confirmsave);
			success = true;
			confirmsave = new TextWindow("",this,function(){});
			var message:String = "";
			var suc:Boolean = false;
			
			var response:String = event.target.data;
			if (response.indexOf("SUCCESS") != -1) {
				message = "Successfully uploaded as "+sname+".xml! Type \""+sname+"\" in online mode to play your level.  Now go play some levels!"
				suc = true;
			} else if (response.indexOf("ERROR01") != -1) {
				message = "Verification failed. Retry?";
			} else if(response.indexOf("ERROR02") != -1) {
				message = "Invalid character(s) in your name. Retry?";
			} else if (response.indexOf("ERROR03") != -1) {
				message = "Name taken. Retry?";
			} else {
				message = "Invalid request or invalid character in your name. Retry?";
			}
			if (suc) {
				confirmsave.okbox(message,function(){destroy();});
			} else {
				confirmsave.yesnobox(message,function(){entername();},function(){main.removeChild(confirmsave);remake();});
			}
			main.addChild(confirmsave);
			trace(event.target.data);
		}
		
		private function verifyfail(message:String) {
			main.removeChild(confirmsave);
			confirmsave = new TextWindow("",this,function(){});
			confirmsave.yesnobox(message,function(){entername();},function(){clear();remake();});
			main.addChild(confirmsave);
		}

	}
	
}
