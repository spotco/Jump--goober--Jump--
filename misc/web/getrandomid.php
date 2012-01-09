<?php
	include("common.php");
	error_reporting(0);

	sqlconnect();
	$query = mysql_query("
	SELECT id FROM level
	WHERE id > 0
	ORDER BY RAND()
	LIMIT 1;
	");
	if ($query) {
		$results = mysql_fetch_array($query);
		echo($results["id"]);
	} else {
		header("HTTP/1.0 406 Not Acceptable");
		die("query error");
	}
?>