<?php
include("common.php");
error_reporting(0);
if (isset($_REQUEST["creator_name"]) && 
	isset($_REQUEST["level_name"]) &&
	isset($_REQUEST["level_data"]) &&
	isset($_REQUEST["pass"]) && 
	$_REQUEST["pass"] == "jumpdiecreatesubmit") {
	
	if (!preg_match("/^[a-zA-Z0-9]{3,16}$/", $_REQUEST["level_name"]) &&
		!preg_match("/^[a-zA-Z0-9]{3,16}$/", $_REQUEST["creator_name"])) {
		header("HTTP/1.0 400 Bad Request");
		die("level name or creator name regex error");
	}
	
	$doc = new DOMDocument();
	$doc->loadXML($_REQUEST["level_data"]);
	$xmlschema = 'levelschema.xsd';
	if (!$doc->schemaValidate($xmlschema)) {
		header("HTTP/1.0 400 Bad Request");
		die("xml is invalid");
	}
	sqlconnect();
	$_REQUEST["level_data"] = str_replace("'",'&quot;',$_REQUEST["level_data"]); //REMEMBER TO DO THIS, SINGLE TO DUB IN, DUB TO SINGLE OUT
	$query = mysql_query("
		INSERT INTO level (xml, creator_name, level_name)
		VALUES ('".$_REQUEST["level_data"]."', '".$_REQUEST["creator_name"]."', '".$_REQUEST["level_name"]."')
	");
	if (!$query) {
		header("HTTP/1.0 406 Not Acceptable");
		die("query error");
	}
	die("Your level, ".$_REQUEST["level_name"].", was successfully uploaded! Now go play some levels!");
	
} else {
	header("HTTP/1.0 404 Not Found");
	die("invalid params");
}
?>