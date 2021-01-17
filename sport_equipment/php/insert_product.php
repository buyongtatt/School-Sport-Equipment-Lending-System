<?php
error_reporting(0);
include_once ("dbconnect.php");
$id = $_POST['id'];
$name  = ucwords($_POST['name']);
$fee  = $_POST['fee'];
$quantity  = $_POST['quantity'];
$description = $_POST['description'];
$type  = $_POST['type'];

$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$path = '../equipmentimage/'.$id.'.jpg';

$sqlinsert = "INSERT INTO EQUIPMENT(ID,NAME,FEE,QUANTITY,DESCRIPTION,TYPE) VALUES ('$id','$name','$fee','$quantity','$description','$type')";
$sqlsearch = "SELECT * FROM EQUIPMENT WHERE ID='$id'";
$resultsearch = $conn->query($sqlsearch);
if ($resultsearch->num_rows > 0)
{
    echo 'found';
}else{
if ($conn->query($sqlinsert) === true)
{
    if (file_put_contents($path, $decoded_string)){
        echo 'success';
    }else{
        echo 'failed';
    }
}
else
{
    echo "failed";
}    
}


?>