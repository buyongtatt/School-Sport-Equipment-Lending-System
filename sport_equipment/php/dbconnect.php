<?php
$servername = "localhost";
$username   = "lintattc_buyongtatt";
$password   = "kzZ6!)?$6e!.";
$dbname     = "lintattc_SportEquipment";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>