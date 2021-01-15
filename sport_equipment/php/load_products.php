<?php
error_reporting(0);
include_once ("dbconnect.php");
$type = $_POST['type'];
$name = $_POST['name'];

if (isset($type)){
    if ($type == "Recent"){
        $sql = "SELECT * FROM EQUIPMENT ORDER BY DATE DESC lIMIT 20";    
    }else{
        $sql = "SELECT * FROM EQUIPMENT WHERE TYPE = '$type'";    
    }
}else{
    $sql = "SELECT * FROM EQUIPMENT ORDER BY DATE DESC lIMIT 20";    
}
if (isset($name)){
   $sql = "SELECT * FROM EQUIPMENT WHERE NAME LIKE  '%$name%'";
}


$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["equipment"] = array();
    while ($row = $result->fetch_assoc())
    {
        $equipmentlist = array();
        $equipmentlist["id"] = $row["ID"];
        $equipmentlist["name"] = $row["NAME"];
        $equipmentlist["fee"] = $row["FEE"];
        $equipmentlist["quantity"] = $row["QUANTITY"];
        $equipmentlist["type"] = $row["TYPE"];
        $equipmentlist["date"] = $row["DATE"];
        $equipmentlist["description"] = $row["DESCRIPTION"];
        array_push($response["equipment"], $equipmentlist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>
