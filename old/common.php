<?php

function sqlconnect() {
	$db = mysql_connect("localhost", "spotco_sql", "dododo");
	if (!$db) {
		header("HTTP/1.0 401 Unauthorized");
		die("Unable to connect to server: " . mysql_error());
	}
	if (!mysql_select_db("spotco_jumpdiecreatelevels")) {
		header("HTTP/1.0 401 Unauthorized");
		die("Unable to select database: " . mysql_error());
	}
}

?>