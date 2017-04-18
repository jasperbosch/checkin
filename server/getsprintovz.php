<?php
require_once ("models/config.php");
if (! securePage ( $_SERVER ['PHP_SELF'] )) {
	die ();
}
define ( 'SESSION_MONTHYEAR', 'monthYear' );
$postdata = file_get_contents ( "php://input" );

$currentDate = getCurrentDate ()->format ( 'Y-m-d' );
$today = $currentDate;
if (trim ( $postdata ) != "") {
	$currentDate = $postdata;
}

// Bepaal maxWerkplekken
$sQuery = "SELECT waarde FROM ch_config WHERE sleutel = 'maxWerkplekken' LIMIT 1";

$stmt = $mysqli->prepare ( $sQuery );
$stmt->execute ();
$stmt->bind_result ( $waarde );
while ( $stmt->fetch () ) {
	$maxWerkplekken = intval ( $waarde );
}
$stmt->close ();
$sQuery = "SELECT waarde FROM ch_config WHERE sleutel = 'maxWerkplekkenImCkc' LIMIT 1";

$stmt = $mysqli->prepare ( $sQuery );
$stmt->execute ();
$stmt->bind_result ( $waarde );
while ( $stmt->fetch () ) {
	$maxImckcWerkplekken = intval ( $waarde );
}
$stmt->close ();
// Bepaal de huidige sprint
$sQuery = "SELECT naam, datum FROM ch_sprints WHERE datum <= ? ORDER BY datum DESC LIMIT 1";

$stmt = $mysqli->prepare ( $sQuery );
$stmt->bind_param ( 's', $currentDate );
$stmt->execute ();
$stmt->bind_result ( $naam, $datum );
$currentSprint = array ();
while ( $stmt->fetch () ) {
	$currentSprint = array (
			'naam' => $naam,
			'datum' => $datum 
	);
}
$stmt->close ();

// Bepaal de vorige sprint
$sQuery = "SELECT naam, datum FROM ch_sprints WHERE datum < ? ORDER BY datum DESC LIMIT 1";

$stmt = $mysqli->prepare ( $sQuery );
$stmt->bind_param ( 's', $currentSprint ['datum'] );
$stmt->execute ();
$stmt->bind_result ( $naam, $datum );
$prevSprint = array ();
while ( $stmt->fetch () ) {
	$prevSprint = array (
			'naam' => $naam,
			'datum' => $datum 
	);
}
$stmt->close ();

// Bepaal de volgende sprint
$sQuery = "SELECT naam, datum FROM ch_sprints WHERE datum > ? ORDER BY datum ASC LIMIT 1";

$stmt = $mysqli->prepare ( $sQuery );
$stmt->bind_param ( 's', $currentSprint ['datum'] );
$stmt->execute ();
$stmt->bind_result ( $naam, $datum );
$nextSprint = array ();
while ( $stmt->fetch () ) {
	$nextSprint = array (
			'naam' => $naam,
			'datum' => $datum 
	);
}
$stmt->close ();

$startDate = new DateTime ( $currentSprint ['datum'] );
$endDate = new DateTime ( $nextSprint ['datum'] );

// Bepaal alle afwijkende datums
$sQuery = "SELECT datum, user_name, soort, uren
		FROM ch_data
		WHERE datum BETWEEN ? AND ?";

$stmt = $mysqli->prepare ( $sQuery );
$stmt->bind_param ( 'ss', $currentSprint ['datum'], $nextSprint ['datum'] );
$stmt->execute ();
$stmt->bind_result ( $datum, $userName, $soort, $uren );
$afwdata = array ();
while ( $stmt->fetch () ) {
	$afw = new stdClass ();
	$afw->soort = $soort;
	$afw->uren = $uren;
	$afwdata [$datum] [$userName] = $afw;
}
$stmt->close ();

// Bepaal alle vrije datums
$sQuery = "SELECT datum
		FROM ch_vrijedagen
		WHERE datum BETWEEN ? AND ?";

$stmt = $mysqli->prepare ( $sQuery );
$stmt->bind_param ( 'ss', $currentSprint ['datum'], $nextSprint ['datum'] );
$stmt->execute ();
$stmt->bind_result ( $datum );
$vrijdata = array ();
while ( $stmt->fetch () ) {
	$vrijdata [$datum] = $datum;
}
$stmt->close ();

// Bepaal de users
$sQuery = "SELECT a.user_name, a.display_name, c.naam, c.rgb, b.mo, b.tu, b.we, b.th, b.vr, b.sa, b.su, d.code, c.imckc
		FROM uc_users a
		LEFT JOIN ch_preferences b
			ON b.user_name = a.user_name
		LEFT JOIN ch_teams c
			ON c.id = b.team
		LEFT JOIN ch_functies d
			ON d.id = b.functie
		ORDER BY c.naam, a.display_name ASC";

$stmt = $mysqli->prepare ( $sQuery );
$stmt->execute ();
$stmt->bind_result ( $userId, $userName, $team, $rgb, $ma, $tu, $we, $th, $vr, $sa, $su, $functie, $imckc );
$users = array ();

$users = array ();
$totAanwezig = array ();
$totImckcAanwezig = array ();
$totTeam = array ();
while ( $stmt->fetch () ) {
	$prefs = array (
			'ma' => $ma,
			'tu' => $tu,
			'we' => $we,
			'th' => $th,
			'vr' => $vr,
			'sa' => $sa,
			'su' => $su 
	);
	$user = array (
			'id' => $userId,
			'naam' => $userName,
			'team' => $team,
			'rgb' => $rgb,
			'data' => getData ( $startDate, $endDate, $prefs, $afwdata, $userId, $functie, $team, $rgb, $vrijdata, $imckc ) 
	);
	$users [] = $user;
}
$stmt->close ();

$data = array (
		'today' => $today,
		'maxWerkplekken' => $maxWerkplekken,
		'maxImckcWerkplekken' => $maxImckcWerkplekken,
		'prevSprint' => $prevSprint,
		'currSprint' => $currentSprint,
		'nextSprint' => $nextSprint,
		'totaal' => $totAanwezig,
		'totaalimckc' => $totImckcAanwezig,
		'totaalTeam' => $totTeam,
		'users' => $users 
);

echo json_encode ( $data );
function getData($startDate, $endDate, $prefs, $afwdata, $userName, $functie, $team, $rgb, $vrijdata, $imckc) {
	global $totAanwezig, $totImckcAanwezig, $totTeam, $today;
	$interval = new DateInterval ( 'P1D' );
	$datum = clone $startDate;
	$data = array ();
	while ( $datum < $endDate ) {
		$dag = new stdClass ();
		$dag->datum = $datum->format ( 'Y-m-d' );
		$dag->dag = $datum->format ( 'j' );
		$dag->maand = intval ( $datum->format ( 'n' ) );
		$dag->dow = intval ( $datum->format ( 'N' ) );
		$dag->dowName = strftime ( '%a', strtotime ( $datum->format ( "d-m-Y" ) ) );
		$dag->soort = 'K';
		$dag->today = ($today == $datum->format ( 'Y-m-d' ));
		if ($datum == $startDate) {
			// Sprintstartdag
			$dag->soort = 'S';
		}
		switch ($dag->dow) {
			case 1 :
				$dag->uren = $prefs ['ma'];
				break;
			case 2 :
				$dag->uren = $prefs ['tu'];
				break;
			case 3 :
				$dag->uren = $prefs ['we'];
				break;
			case 4 :
				$dag->uren = $prefs ['th'];
				break;
			case 5 :
				$dag->uren = $prefs ['vr'];
				break;
			case 6 :
				$dag->uren = $prefs ['sa'];
				break;
			case 7 :
				$dag->uren = $prefs ['su'];
				break;
		}
		
		if (isset ( $afwdata [$dag->datum] [$userName] )) {
			$dag->soort = $afwdata [$dag->datum] [$userName]->soort;
			$dag->uren = $afwdata [$dag->datum] [$userName]->uren;
		}
		if (isset ( $vrijdata [$dag->datum] )) {
			$dag->soort = "V";
			$dag->uren = 0;
		}
		if ($dag->soort == "K" && $dag->uren == 0) {
			$dag->soort = "V";
		}
		if ($dag->soort == "S") {
			$dag->uren = 0;
		}
		
		// Totaal aantal bezette plekken per dag
		if (! isset ( $totAanwezig [$dag->datum] )) {
			$totAanwezig [$dag->datum] = 0;
			$totImckcAanwezig [$dag->datum] = 0;
		}
		if ($dag->soort == "K" || $dag->soort == "S") {
			if ($imckc) {
				$totImckcAanwezig [$dag->datum] ++;
			} else {
				$totAanwezig [$dag->datum] ++;
			}
		}
		
		// Totaal per team per functie
		if (isset ( $team )) {
			if (! isset ( $totTeam [$team] )) {
				$teamObj = array ();
				$teamObj ['naam'] = $team;
				$teamObj ['rgb'] = $rgb;
				$teamObj ['functies'] = array ();
				$totTeam [$team] = $teamObj;
			}
			if (! isset ( $totTeam [$team] ['functies'] [$functie] ['code'] )) {
				$totTeam [$team] ['functies'] [$functie] ['code'] = $functie;
				$totTeam [$team] ['functies'] [$functie] ['uren'] = 0;
			}
			$totTeam [$team] ['functies'] [$functie] ['uren'] = $totTeam [$team] ['functies'] [$functie] ['uren'] + $dag->uren;
		}
		
		// Bepaal de volgende datum
		$data [$datum->format ( 'Y-m-d' )] = $dag;
		$datum->add ( $interval );
	}
	return $data;
}
function getCurrentDate() {
	return new DateTime ();
}
