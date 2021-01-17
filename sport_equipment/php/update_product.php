<?php
error_reporting(0);
include_once("dbconnect.php");
$id = $_POST['id'];
$name = ucwords($_POST['name']);
$quantity = $_POST['quantity'];
$fee = $_POST['fee'];
$type = $_POST['type'];
$description = $_POST['description'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$path = '../equipmentimage/'.$id.'.jpg';

    $sqlupdate = "UPDATE EQUIPMENT SET NAME ='$name', QUANTITY = '$quantity', FEE = '$fee', TYPE = '$type', DESCRIPTION = '$description' WHERE ID = '$id'";
    if ($conn->query($sqlupdate) === true)
    {
        if (isset($encoded_string)){
            file_put_contents($path, $decoded_string);
        }
        echo "success";
    }
    else
    {
        echo "failed";
    }

$conn->close();
?>