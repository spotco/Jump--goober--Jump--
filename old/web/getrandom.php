<?php
	header("Content-type: text/xml"); 
	$levellist = file("levels.txt");
	$seed = rand(0,count($levellist));
	$targetlevel = "";
	while ($targetlevel == "") {
		$targetlevel = trim($levellist[$seed]);
		$seed = rand(0,count($levellist));
	}
	
	//echo("target: $targetlevel");
	$fh = fopen("./levels/".$targetlevel.".xml", 'r') or die("can't open file");
	echo(fread($fh,filesize("./levels/".$targetlevel.".xml")));
	fclose($fh);
?>
