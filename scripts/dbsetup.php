<?php
echo ('start');
echo ('<br/>');

include ('db-settings.php');

$db = new PDO("mysql:host=$db_host;dbname=$db_name", $db_user, $db_pass);

$sql = file_get_contents('checkin.sql');

echo $sql;
echo ('<br/>');

$qr = $db->exec($sql);

echo $qr;
echo ('<br/>');

echo 'stop';