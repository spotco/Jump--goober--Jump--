<?php header ("Content-Type:text/xml"); ?>
<levellist>
<?php
	include("common.php");
	error_reporting(0);

	sqlconnect();
	if (isset($_REQUEST["targetname"])) {
		$targetname = $_REQUEST["targetname"];
	} else {
		die("invalid params");
	}
	if (isset($_REQUEST["offset"])) {
		$offset = $_REQUEST["offset"];
	} else {
		$offset = 0;
	}
	$targetname = mysql_real_escape_string($targetname);
	$query = mysql_query("
		SELECT l.id,l.level_name,l.creator_name,l.date_created,
			(
				SELECT AVG( lr.rating )
				FROM level_review lr
				WHERE lr.level_id = l.id
			) AS ratingavg
		FROM level l
		WHERE LOWER(l.level_name) LIKE LOWER(\"%$targetname%\")
		LIMIT 5 OFFSET $offset;
	");
	
	if ($query) {
		$results = mysql_fetch_array($query);
		while ($results) {
			?>
			<level 
			id="<?=$results["id"]?>" 
			level_name="<?=$results["level_name"]?>" 
			creator_name="<?=$results["creator_name"]?>" 
			date_created="<?=$results["date_created"]?>" 
			ratingavg="<?=$results["ratingavg"]?>" 
			/>
			<?php
			$results = mysql_fetch_array($query);
		}
	}
?>
</levellist>