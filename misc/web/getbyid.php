<?php
	if (isset($_REQUEST["id"])) {
		$_REQUEST["id"] = str_replace(';','?',$_REQUEST["id"]);
		include("common.php");
		error_reporting(0);

		sqlconnect();
		$query = mysql_query("
		SELECT xml FROM level
		WHERE id = ".$_REQUEST["id"]."
		LIMIT 1;
		");
		if ($query) {
			$results = mysql_fetch_array($query);
			$results["xml"] = str_replace('&quot;',"'",$results["xml"]);
			header("Content-type: text/xml");
			echo($results["xml"]);
		} else {
			header("HTTP/1.0 406 Not Acceptable");
			die("query error");
		}
	} else {
		header("HTTP/1.0 406 Not Acceptable");
		die("query error");
	}
?>
