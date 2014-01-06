package misc {
	import mochi.as3.*;
	import flash.display.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.net.SharedObject;
	import currentfunction.TutorialGame;
	
	public class MochiManager {
		
		private var id:String;
		private var main:JumpDieCreateMain;
		
		private var mochi_pane:Sprite = new Sprite;
		
		private var t:Timer;
		
		public var panel_showing:Boolean = false;
		private var game_achievements:Object = new Object;
		private var localdata:SharedObject;
		
		
		public function MochiManager(id:String,main:JumpDieCreateMain,localdata:SharedObject) {
			this.id = id;
			this.main = main;
			this.localdata = localdata;
			
			if (!JumpDieCreateMain.MOCHI_ENABLED) {
				return;
			}
			
			main.cstage.addChild(mochi_pane);
			MochiServices.connect(id,mochi_pane,connect_error);
			
			MochiEvents.setNotifications( {
				format: MochiEvents.FORMAT_LONG,
				align: MochiEvents.ALIGN_TOP_RIGHT
			} );
			
			MochiEvents.addEventListener( MochiEvents.ACHIEVEMENTS_OWNED, get_user_ach);
			MochiEvents.addEventListener( MochiEvents.ACHIEVEMENT_NEW, update_user_ach);
						
			t = new Timer(1000);
			t.addEventListener(TimerEvent.TIMER, update);
			t.start();
		}
		
		private function get_user_ach(o:Object) {
			for each(var a:Object in o) {
				game_achievements[id] = true;
			}
		}
		
		private function update_user_ach(o:Object) {
			game_achievements[id] = true;
		}
		
		public function unlock_achievement(s:String) {
			if (!JumpDieCreateMain.MOCHI_ENABLED) {
				return;
			}
			MochiEvents.unlockAchievement( { id: s } );
		}
		
		public function update_achievements_menu() {
			check_world_complete();
			check_world_perfect();
		}
		
		public function update_achievements_rating() {
			check_rate();
		}
		
		public function update_achievements_onlinecount() {
			check_online_play();
		}
		
		public function update_achievements_submit() {
			check_submit();
		}
		
		private function check_submit() {
			if (!game_achievements[MochiManager.submit_1] && main.localdata.data["submitted_level"]) {
				unlock_achievement(MochiManager.submit_1);
			}
		}
		
		private function check_online_play() {
			if (main.localdata.data["online_levels_played"] == null) {
				return;
			}
			if (!game_achievements[MochiManager.play_1_online] && main.localdata.data["online_levels_played"] > 0) {
				trace("enter1");
				unlock_achievement(MochiManager.play_1_online);
			}
			if (!game_achievements[MochiManager.play_10_online] && main.localdata.data["online_levels_played"] > 10) {
				trace("enter10");
				unlock_achievement(MochiManager.play_10_online);
			}
			if (!game_achievements[MochiManager.play_20_online] && main.localdata.data["online_levels_played"] > 20) {
				trace("enter20");
				unlock_achievement(MochiManager.play_20_online);
			}
		}
		
		private function check_rate() {
			if (!game_achievements[MochiManager.rate_1] && main.localdata.data["1star"]) {
				unlock_achievement(MochiManager.rate_1);
			}
			if (!game_achievements[MochiManager.rate_5] && main.localdata.data["5star"]) {
				unlock_achievement(MochiManager.rate_5);
			}
		}
		
		private function check_world_complete() {
			if (!game_achievements[MochiManager.world_1_complete] && localdata.data.world1 >= 12) {
				unlock_achievement(MochiManager.world_1_complete);
			}
			if (!game_achievements[MochiManager.world_2_complete] && localdata.data.world2 >= 12) {
				unlock_achievement(MochiManager.world_2_complete);
			}
			if (!game_achievements[MochiManager.world_3_complete] && localdata.data.world3 >= 12) {
				unlock_achievement(MochiManager.world_3_complete);
			}
		}
		
		private function check_world_perfect() {
			if (!game_achievements[MochiManager.world_1_perfect] && check_world(1)) {
				unlock_achievement(MochiManager.world_1_perfect);
			}
			
			if (!game_achievements[MochiManager.world_2_perfect] && check_world(2)) {
				unlock_achievement(MochiManager.world_2_perfect);
			}
			
			if (!game_achievements[MochiManager.world_3_perfect] && check_world(3)) {
				unlock_achievement(MochiManager.world_3_perfect);
			}
		}
		
		private function check_world(world:Number):Boolean {
			for(var i = 1; i <= 11; i++) {
				var key:String = world+"-"+i;
				var val = localdata.data[key];
				if (val == null) {
					//trace("at "+world+"-"+i+" null");
					return false;
				} else {
					val = TutorialGame.parsetime(val);
				}
				if (TutorialGame.parserank(val,world,i,main.rankdata) != "A") {
					trace("at "+world+"-"+i+" time failed:"+TutorialGame.parserank(val,world,i,main.rankdata));
					return false;
				}
			}
			trace("world "+world+" time suc");
			return true;
		}
		
		public function show_awards() {
			if (!JumpDieCreateMain.MOCHI_ENABLED) {
				return;
			}
			MochiEvents.showAwards();
		}
		
		private function update(e:Event) {
			if (main.curfunction is currentfunction.JumpDieCreateMenu) {
				main.cstage.setChildIndex(mochi_pane,main.cstage.numChildren-1);   
			} 
			
		}
		
		public function show_panel() {
			if (!JumpDieCreateMain.MOCHI_ENABLED) {
				return;
			}
			panel_showing = true;
			MochiSocial.showLoginWidget({x:305, y:490 });
		}
		
		public function hide_panel() {
			if (!JumpDieCreateMain.MOCHI_ENABLED) {
				return;
			}
			panel_showing = false;
			MochiSocial.hideLoginWidget();
		}
		
		public function connect_error(status:String):void {
			trace("couldn't connect to mochi");
		}
	
		public static const world_1_complete:String = "191e4444a5ca125c";
		public static const world_2_complete:String = "cccd80651f589ebd";
		public static const world_3_complete:String = "b5ec55b166369fd7";
		
		public static const world_1_perfect:String = "2530ae01ac303dca";
		public static const world_2_perfect:String = "16a5285031d0043e";
		public static const world_3_perfect:String = "26155ea148409486";
		
		public static const rate_1:String = "8e0a9c1b09ad9f8c";
		public static const rate_5:String = "9d211b0c407f9fb2";
		
		public static const play_1_online:String = "d8f9fc843de257a0";
		public static const play_10_online:String = "fae7554ceaffefa4";
		public static const play_20_online:String = "94479567b4d9b5bd";
		
		public static const submit_1:String = "601540b086540920";
	}
	
}
