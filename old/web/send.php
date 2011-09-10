<?php 
header('Content-Type: text/plain');
	if (isset($_REQUEST["name"]) && isset($_REQUEST["pass"])) {
		if ($_REQUEST["pass"] != "upload") {
			die("ERROR01");
		}
		if (!preg_match("/^[a-zA-Z0-9]{3,16}$/", $_REQUEST["name"])) {
			//echo($_REQUEST["name"]);
			die("ERROR02");
		}
		$levellist = file("levels.txt");
		foreach($levellist as $levelname) {
			//echo($_REQUEST["name"]."  =  ".trim($levelname));
			if ($_REQUEST["name"] == trim($levelname)) {
				die("ERROR03");
			}
		}
		$fh = fopen("levels.txt",'a');
		fwrite($fh,$_REQUEST["name"]."\n");
		fclose($fh);
		
		$fh = fopen("./levels/".$_REQUEST["name"].".xml", 'w') or die("can't open file");
		fwrite($fh, $HTTP_RAW_POST_DATA);
		fclose($fh);
		
		$fh = fopen("./ratings/".$_REQUEST["name"].".txt", 'w') or die("can't open file");
		fwrite($fh,"");
		fclose($fh);
		
		$fh = fopen("./comments/".$_REQUEST["name"].".txt", 'w') or die("can't open file");
		fwrite($fh,"");
		fclose($fh);
		
		echo("SUCCESS");
	} else {
		die("ERROR00");
	}
?>
