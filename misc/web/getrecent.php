<?php header ("Content-Type:text/xml"); ?>
<levellist>
<?php
	include("common.php");
	error_reporting(0);

	sqlconnect();
	if (isset($_REQUEST["offset"])) {
		$offset = $_REQUEST["offset"];
	} else {
		$offset = 0;
	}
	$query = mysql_query("
	SELECT DISTINCT l.id, l.level_name, l.creator_name, l.date_created, lp.playcount, 
		(
			SELECT AVG( lr.rating )
			FROM level_review lr
			WHERE lr.level_id = l.id
		) AS ratingavg,
		(
			SELECT COUNT( lr.rating )
			FROM level_review lr
			WHERE lr.level_id = l.id
		) AS ratingcount
	FROM level l
	LEFT JOIN level_playcount lp ON lp.level_id = l.id
	WHERE l.id > 0
	ORDER BY l.date_created DESC
	LIMIT 5 OFFSET $offset;
	
	");
	
	if ($query) {
		$results = mysql_fetch_array($query);
		while ($results) {
			if (!$results["playcount"]) {
				$results["playcount"] = 0;
			}
			if (!$results["ratingavg"]) {
				$results["ratingavg"] = 0;
			}
			?>
			<level id="<?=$results["id"]?>" level_name="<?=$results["level_name"]?>" 
			creator_name="<?=$results["creator_name"]?>" 
			date_created="<?=$results["date_created"]?>" 
			playcount="<?=$results["playcount"]?>" 
			ratingavg="<?=$results["ratingavg"]?>" 
			ratingcount="<?=$results["ratingcount"]?>" 
			/>
			<?php
			$results = mysql_fetch_array($query);
		}
	}
?>
</levellist>