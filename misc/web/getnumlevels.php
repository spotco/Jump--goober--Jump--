<?php header ("Content-Type:text/xml"); ?>
<count>
<?php
	include("common.php");
	error_reporting(0);

	sqlconnect();
	
	$query = mysql_query("
	SELECT COUNT(level_name), COUNT(creator_name) FROM level;
	");
	
	if ($query) {
		$results = mysql_fetch_array($query);
	?><numlevels val="<?=$results["COUNT(level_name)"]?>" /><?php
	}
	
?>
</count>