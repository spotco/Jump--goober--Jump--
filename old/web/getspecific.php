<?php
if (isset($_REQUEST["name"])) {
	//echo("target: $targetlevel"); 
	if (!file_exists("./levels/".$_REQUEST["name"].".xml")) {
		die("ERROR01");
	}
	$fh = fopen("./levels/".$_REQUEST["name"].".xml", 'r') or die("ERROR01");
	header("Content-type: text/xml");
	echo(fread($fh,filesize("./levels/".$_REQUEST["name"].".xml")));
	fclose($fh);
} else {
	die("ERROR00");
}
?>
