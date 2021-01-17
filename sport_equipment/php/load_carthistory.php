<?php
error_reporting(0);
include_once ("dbconnect.php");
$lendingid = $_POST['lendingid'];



$sql = "SELECT EQUIPMENT.ID, EQUIPMENT.NAME, EQUIPMENT.FEE, CARTHISTORY.HOUR, CARTHISTORY.CQUANTITY FROM EQUIPMENT INNER JOIN CARTHISTORY ON CARTHISTORY.ID = EQUIPMENT.ID WHERE CARTHISTORY.LENDINGID = '$lendingid'";




$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["carthistory"] = array();
    while ($row = $result->fetch_assoc())
    {
        $cartlist = array();
        $cartlist["id"] = $row["ID"];
        $cartlist["name"] = $row["NAME"];
        $cartlist["fee"] = $row["FEE"];
        $cartlist["cquantity"] = $row["CQUANTITY"];
        $cartlist["hour"] = $row["HOUR"];
        array_push($response["carthistory"], $cartlist);
    }
    echo json_encode($response);
}
else 
{
    echo "Cart Empty";
}
?>