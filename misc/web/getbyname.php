<?php header ("Content-Type:text/xml"); ?>
<levellist>
<?php
	include("common.php");
	error_reporting(0);

	sqlconnect();
	if (isset($_REQUEST["targetname"])) {
		$targetname = $_REQUEST["targetname"];
	} else {
		$targetname = "s";
	}
	$targetname = mysql_real_escape_string($targetname);
	$query = mysql_query('
	SELECT id,level_name,creator_name,date_created FROM level
	WHERE level_name = "'.$targetname.'";
	');
	
	if ($query) {
		$results = mysql_fetch_array($query);
		while ($results) {
			?>
			<level id="<?=$results["id"]?>" level_name="<?=$results["level_name"]?>" creator_name="<?=$results["creator_name"]?>" date_created="<?=$results["date_created"]?>" />
			<?php
			$results = mysql_fetch_array($query);
		}
	}
?>
</levellist>