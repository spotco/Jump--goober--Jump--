<?php
	include("common.php");
	error_reporting(0);
	sqlconnect();
	
	if (isset($_REQUEST["level"]) && is_numeric($_REQUEST["level"]) && isset($_REQUEST["rating"]) && is_numeric($_REQUEST["rating"]) && $_REQUEST["rating"] >= 0 && $_REQUEST["rating"] <= 5 ) {
		$level = $_REQUEST["level"];
		$review = $_REQUEST["rating"];
	} else {
		die("bad param");
	}
	
	if (isset($_REQUEST["checksum"]) && evalChecksum("submitreview",$_REQUEST["level"],$_REQUEST["checksum"])) {
		echo("success1");
	} else {
		die("checksum fail");
	}
	
	$query = mysql_query("
		INSERT INTO level_review (level_id, rating)
		VALUES ($level,$review);
	");
	if ($query) {
		echo 'success';
	} else {
		echo 'failure';
	}
?>