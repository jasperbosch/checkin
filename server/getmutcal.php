<?php
require_once ("models/config.php");
if (! securePage ( $_SERVER ['PHP_SELF'] )) {
	die ();
}
define ( 'SESSION_MONTHYEAR', 'monthYear' );
$postdata = file_get_contents ( "php://input" );

$data = array ();
$prefs = array ();
$errors = array ();

$check = checkSession ();
if ($check != "OK") {
	$errors [] = $check;
} else {
	
	$username = trim ( $_SESSION [SESSION_USER]->username );
	
	$sQuery = "SELECT * FROM ch_preferences WHERE user_name = ?";
	
	$stmt = $mysqli->prepare ( $sQuery );
	$stmt->bind_param ( 's', $username );
	$stmt->execute ();
	$stmt->bind_result ( $username, $phone, $functie, $team, $mo, $tu, $we, $th, $vr, $sa, $su, $timestamp );
	while ( $stmt->fetch () ) {
		$prefs [1] = $mo;
		$prefs [2] = $tu;
		$prefs [3] = $we;
		$prefs [4] = $th;
		$prefs [5] = $vr;
		$prefs [6] = $sa;
		$prefs [7] = $su;
	}
	
	$werkDatum = getCurrentDate ();
	if ($postdata == 0) {
		$monthYear = $werkDatum;
	} elseif ($postdata == - 1) {
		$monthYear = $_SESSION [SESSION_MONTHYEAR];
		$monthInterval = new DateInterval ( 'P1M' );
		$monthYear->sub ( $monthInterval );
	} elseif ($postdata == 1) {
		$monthYear = $_SESSION [SESSION_MONTHYEAR];
		$monthInterval = new DateInterval ( 'P1M' );
		$monthYear->add ( $monthInterval );
	}
	$_SESSION [SESSION_MONTHYEAR] = $monthYear;
	
	$datum = getFistDayOfCalender ( $monthYear );
	$datumParam = $datum->format ( 'Y-m-d' );
	$clone = clone $datum;
	$datumTotParam = $clone->add ( new DateInterval ( 'P1M7D' ) )->format ( 'Y-m-d' );
	$spDatumTotParam = $clone->add ( new DateInterval ( 'P1M8D' ) )->format ( 'Y-m-d' );
	
	$sQuery = "SELECT * FROM ch_data WHERE user_name = ? AND datum BETWEEN ? AND ?";
	$stmt = $mysqli->prepare ( $sQuery );
	$stmt->bind_param ( 'sss', $username, $datumParam, $datumTotParam );
	$stmt->execute ();
	$stmt->bind_result ( $username, $datumValue, $soort, $uren, $timestamp );
	$chdata = array ();
	while ( $stmt->fetch () ) {
		$chdata [$datumValue] = array (
				'soort' => $soort,
				'uren' => $uren 
		);
	}
	
	$sQuery = "SELECT * FROM ch_sprints WHERE datum BETWEEN ? AND ?";
	$stmt = $mysqli->prepare ( $sQuery );
	$stmt->bind_param ( 'ss', $datumParam, $spDatumTotParam );
	$stmt->execute ();
	$stmt->bind_result ( $id, $naam, $datumValue, $timestamp );
	$spdata = array ();
	while ( $stmt->fetch () ) {
		$spdata [$datumValue] = array (
				'naam' => $naam,
				'datum' => $datumValue 
		);
	}
	
	$sQuery = "SELECT * FROM ch_vrijedagen WHERE datum BETWEEN ? AND ?";
	$stmt = $mysqli->prepare ( $sQuery );
	$stmt->bind_param ( 'ss', $datumParam, $datumTotParam );
	$stmt->execute ();
	$stmt->bind_result ( $datumValue, $timestamp );
	$vrdata = array ();
	while ( $stmt->fetch () ) {
		$vrdata [$datumValue] = array (
				'datum' => $datumValue 
		);
	}
	
	$interval = new DateInterval ( 'P1D' );
	while ( datumIsInDezeMaand ( $datum, $monthYear ) ) {
		$week = array ();
		for($i = 0; $i < 7; $i ++) {
			$dag = new stdClass ();
			$dag->datum = $datum->format ( 'Y-m-d' );
			$dag->dag = $datum->format ( 'j' );
			$dag->maand = intval ( $datum->format ( 'n' ) );
			$dag->dow = intval ( $datum->format ( 'N' ) );
			if (isset ( $chdata [$dag->datum] )) {
				// Mutatie van de gebruiker
				$dag->uren = ( float ) $chdata [$dag->datum] ['uren'];
				$dag->soort = $chdata [$dag->datum] ['soort'];
			} elseif (isset ( $vrdata [$dag->datum] )) {
				// Verplichte vrije dag
				$dag->uren = 0;
				$dag->soort = 'V';
			} elseif (isset ( $spdata [$dag->datum] )) {
				// Sprint start
				$dag->uren = 0;
				$dag->soort = 'S';
			} else {
				$dag->uren = ( float ) $prefs [$dag->dow];
				if ($dag->uren == 0) {
					$dag->soort = 'V';
				} else {
					$dag->soort = 'K';
				}
			}
			$dag->isSprintstart = (isset ( $spdata [$dag->datum] ));
			$dag->isVerplichtVrij = (isset ( $vrdata [$dag->datum] ));
			$week [] = $dag;
			$datum->add ( $interval );
		}
		$weeks [] = $week;
	}
	$data = array (
			'weeks' => $weeks,
			'currmonth' => intval ( $monthYear->format ( 'n' ) ),
			'currmonthname' => getFullMonth ( $monthYear ) 
	);
}
if (count ( $errors ) > 0) {
	$data = array (
			'id' => session_id (),
			'error' => $errors 
	);
}
echo json_encode ( $data );
function getCurrentDate() {
	return new DateTime ();
}
function getCurrentMonth() {
	$date = new DateTime ();
	return intval ( $date->format ( "n" ) );
}
function getFullMonth($date) {
	return strftime ( '%B %Y', strtotime ( $date->format ( "d-m-Y" ) ) );
}
function getFirstDayOfMonth($datum) {
	return $datum->format ( 'N' );
}
function getFistDayOfCalender($datum) {
	$firstDayOfMonth = new DateTime ( $datum->format ( 'Y-m-01' ) );
	$dag = intval ( getFirstDayOfMonth ( $firstDayOfMonth ) - 1 );
	// echo var_dump($dag);
	// if ($dag==0){
	// $dag=7;
	// }
	$clone = clone $firstDayOfMonth;
	$clone->sub ( new DateInterval ( 'P' . $dag . 'D' ) );
	return $clone;
}
function datumIsInDezeMaand($datum, $werkDatum) {
	return $datum->format ( 'Ym' ) <= $werkDatum->format ( 'Ym' );
}