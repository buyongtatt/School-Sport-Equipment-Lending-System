<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

if (isset($email)){
   $sql = "SELECT EQUIPMENT.ID, EQUIPMENT.NAME, EQUIPMENT.FEE, EQUIPMENT.QUANTITY,  CART.CQUANTITY, CART.HOUR FROM EQUIPMENT INNER JOIN CART ON CART.ID = EQUIPMENT.ID WHERE CART.EMAIL = '$email'";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["cart"] = array();
    while ($row = $result->fetch_assoc())
    {
        $cartlist = array();
        $cartlist["id"] = $row["ID"];
        $cartlist["name"] = $row["NAME"];
        $cartlist["fee"] = $row["FEE"];
        $cartlist["quantity"] = $row["QUANTITY"];
        $cartlist["cquantity"] = $row["CQUANTITY"];
        $cartlist["hour"] = $row["HOUR"];
        $cartlist["yourfee"] = round(doubleval($row["FEE"])*(doubleval($row["CQUANTITY"]))*(doubleval($row["HOUR"])),2)."";
        array_push($response["cart"], $cartlist);
    }
    echo json_encode($response);
}
else
{
    echo "Cart Empty";
}
?>
