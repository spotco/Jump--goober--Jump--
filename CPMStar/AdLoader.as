package CPMStar {
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	
	public class AdLoader extends flash.display.Sprite {
		
		public var cpmstarLoader:Loader;
		public var contentspotid:String;
		public var container:DisplayObjectContainer;
		public function AdLoader(contentspotid:String) {
			this.contentspotid = contentspotid;
			addEventListener(Event.ADDED, addedHandler);
		}
		private function addedHandler(event:Event):void {
			removeEventListener(Event.ADDED, addedHandler);			
			Security.allowDomain("server.cpmstar.com");
			var cpmstarViewSWFUrl:String = "http://server.cpmstar.com/adviewas3.swf";
			container = parent;
			cpmstarLoader = new Loader();
			cpmstarLoader.contentLoaderInfo.addEventListener(Event.INIT, dispatchHandler);
			cpmstarLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, dispatchHandler);
			cpmstarLoader.load(new URLRequest(cpmstarViewSWFUrl + "?contentspotid="+contentspotid));
			addChild(cpmstarLoader);
		}
		private function dispatchHandler(event:Event):void {
			dispatchEvent(event);
		}
	}
}
