﻿package misc {
	import flash.display.*;
    import flash.events.*;
	import flash.utils.*;
		import blocks.*;
	import core.*;
	import currentfunction.*;
	import misc.*;
	
	public class RankData {
		
		public static function initrankdata():Object {
			var rankdata:Object = new Object;
			initrank_world1(rankdata);
			initrank_world2(rankdata);
			initrank_world3(rankdata);
			return rankdata;
		}
		
		private static function initrank_world1(rankdata:Object) {
			rankdata["world1_level1_A"] = "0:12:000";
			rankdata["world1_level1_B"] = "0:20:500";
			rankdata["world1_level1_C"] = "0:30:500";
			
			rankdata["world1_level2_A"] = "0:13:000";
			rankdata["world1_level2_B"] = "0:20:000";
			rankdata["world1_level2_C"] = "0:30:000";
			
			rankdata["world1_level3_A"] = "0:12:00";
			rankdata["world1_level3_B"] = "0:22:00";
			rankdata["world1_level3_C"] = "0:30:00";
			
			rankdata["world1_level4_A"] = "0:9:000";
			rankdata["world1_level4_B"] = "0:15:000";
			rankdata["world1_level4_C"] = "0:25:000";
			
			rankdata["world1_level5_A"] = "0:16:000";
			rankdata["world1_level5_B"] = "0:25:000";
			rankdata["world1_level5_C"] = "0:35:000";
			
			rankdata["world1_level6_A"] = "0:17:000";
			rankdata["world1_level6_B"] = "0:25:000";
			rankdata["world1_level6_C"] = "0:35:000";
			
			rankdata["world1_level7_A"] = "0:20:000";
			rankdata["world1_level7_B"] = "0:30:000";
			rankdata["world1_level7_C"] = "0:40:000";
			
			rankdata["world1_level8_A"] = "0:16:000";
			rankdata["world1_level8_B"] = "0:26:000";
			rankdata["world1_level8_C"] = "0:34:000";
			
			rankdata["world1_level9_A"] = "0:19:000";
			rankdata["world1_level9_B"] = "0:25:000";
			rankdata["world1_level9_C"] = "0:34:000";
			
			rankdata["world1_level10_A"] = "0:20:000";
			rankdata["world1_level10_B"] = "0:30:000";
			rankdata["world1_level10_C"] = "0:40:000";
			
			rankdata["world1_level11_A"] = "0:30:000";
			rankdata["world1_level11_B"] = "0:35:000";
			rankdata["world1_level11_C"] = "0:43:000";
		}
		
		
		private static function initrank_world2(rankdata:Object) {
			rankdata["world2_level1_A"] = "0:26:500";
			rankdata["world2_level1_B"] = "0:33:000";
			rankdata["world2_level1_C"] = "0:40:000";
			
			rankdata["world2_level2_A"] = "0:22:500";
			rankdata["world2_level2_B"] = "0:27:500";
			rankdata["world2_level2_C"] = "0:34:500";
			
			rankdata["world2_level3_A"] = "0:22:500";
			rankdata["world2_level3_B"] = "0:28:000";
			rankdata["world2_level3_C"] = "0:34:000";
			
			rankdata["world2_level4_A"] = "0:24:500";
			rankdata["world2_level4_B"] = "0:29:000";
			rankdata["world2_level4_C"] = "0:34:000";
			
			rankdata["world2_level5_A"] = "0:32:000";
			rankdata["world2_level5_B"] = "0:39:000";
			rankdata["world2_level5_C"] = "0:48:000";
			
			rankdata["world2_level6_A"] = "0:23:000";
			rankdata["world2_level6_B"] = "0:29:000";
			rankdata["world2_level6_C"] = "0:35:000";
			
			rankdata["world2_level7_A"] = "0:23:000";
			rankdata["world2_level7_B"] = "0:29:000";
			rankdata["world2_level7_C"] = "0:37:000";
			
			rankdata["world2_level8_A"] = "0:31:000";
			rankdata["world2_level8_B"] = "0:38:000";
			rankdata["world2_level8_C"] = "0:45:000";
			
			rankdata["world2_level9_A"] = "0:39:000";
			rankdata["world2_level9_B"] = "0:45:000";
			rankdata["world2_level9_C"] = "0:53:000";
			
			rankdata["world2_level10_A"] = "0:32:500";
			rankdata["world2_level10_B"] = "0:39:000";
			rankdata["world2_level10_C"] = "0:46:000";
			
			rankdata["world2_level11_A"] = "0:41:000";
			rankdata["world2_level11_B"] = "0:52:000";
			rankdata["world2_level11_C"] = "0:59:000";
		}
		
		

		private static function initrank_world3(rankdata:Object) {
			rankdata["world3_level1_A"] = "0:20:000";
			rankdata["world3_level1_B"] = "0:27:000";
			rankdata["world3_level1_C"] = "0:35:000";
			
			rankdata["world3_level2_A"] = "0:23:000";
			rankdata["world3_level2_B"] = "0:30:000";
			rankdata["world3_level2_C"] = "0:36:000";
			
			rankdata["world3_level3_A"] = "0:45:000";
			rankdata["world3_level3_B"] = "0:50:000";
			rankdata["world3_level3_C"] = "0:57:000";
			
			rankdata["world3_level4_A"] = "0:30:000";
			rankdata["world3_level4_B"] = "0:36:000";
			rankdata["world3_level4_C"] = "0:44:000";
			
			rankdata["world3_level5_A"] = "0:30:000";
			rankdata["world3_level5_B"] = "0:37:000";
			rankdata["world3_level5_C"] = "0:43:000";
			
			rankdata["world3_level6_A"] = "0:29:000";
			rankdata["world3_level6_B"] = "0:35:000";
			rankdata["world3_level6_C"] = "0:42:000";
			
			rankdata["world3_level7_A"] = "0:32:000";
			rankdata["world3_level7_B"] = "0:38:000";
			rankdata["world3_level7_C"] = "0:46:000";
			
			rankdata["world3_level8_A"] = "0:26:000";
			rankdata["world3_level8_B"] = "0:33:000";
			rankdata["world3_level8_C"] = "0:40:000";
			
			rankdata["world3_level9_A"] = "0:32:000";
			rankdata["world3_level9_B"] = "0:40:000";
			rankdata["world3_level9_C"] = "0:49:000";
			
			rankdata["world3_level10_A"] = "0:42:000";
			rankdata["world3_level10_B"] = "0:49:000";
			rankdata["world3_level10_C"] = "0:56:000";
			
			rankdata["world3_level11_A"] = "1:30:000";
			rankdata["world3_level11_B"] = "1:50:000";
			rankdata["world3_level11_C"] = "2:30:000";
		}
		
		
		
	}
	
}
