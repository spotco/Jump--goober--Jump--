<?php
	include("common.php");
	error_reporting(0);
	sqlconnect();
	
	if (isset($_REQUEST["level"]) && is_numeric($_REQUEST["level"])) {
		$level = $_REQUEST["level"];
	} else {
		die("bad param");
	}
	
	if (isset($_REQUEST["checksum"]) && evalChecksum("updateplaycount",$_REQUEST["level"],$_REQUEST["checksum"])) {
		echo("success");
	} else {
		die("checksum fail");
	}
	
	$query = mysql_query("
		SELECT level_id FROM level_playcount
		WHERE level_id = $level;
	");
	
	if (mysql_num_rows($query) > 0) {
		$query = mysql_query("
			UPDATE level_playcount
			SET playcount = (playcount + 1)
			WHERE level_id = $level;
		");
	} else {
		$query = mysql_query("
			INSERT INTO level_playcount (level_id, playcount)
			VALUES ($level,1);
		");
	}
?>