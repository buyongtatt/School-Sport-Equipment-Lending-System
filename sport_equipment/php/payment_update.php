<?php
error_reporting(0);
include_once("dbconnect.php");
$userid = $_GET['userid'];
$mobile = $_GET['mobile'];
$amount = $_GET['amount'];
$lendingid = $_GET['lendingid'];

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus=="true"){
    $paidstatus = "Success";
}else{
    $paidstatus = "Failed";
}
$receiptid = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value) {
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}
 
 
$signed= hash_hmac('sha256', $signing, 'S-My-WVZAUzWYlNDlqIjNLSA');
if ($signed === $data['x_signature']) {

    if ($paidstatus == "Success"){ //payment success
        
        $sqlcart ="SELECT CART.ID, CART.CQUANTITY,  CART.HOUR, EQUIPMENT.FEE FROM CART INNER JOIN EQUIPMENT ON CART.ID = EQUIPMENT.ID WHERE CART.EMAIL = '$userid'";
        $cartresult = $conn->query($sqlcart);
        if ($cartresult->num_rows > 0)
        {
        while ($row = $cartresult->fetch_assoc())
        {
            $id = $row["ID"];
            $cq = $row["CQUANTITY"]; //cart qty
            $hour = $row["HOUR"];
            $sqlinsertcarthistory = "INSERT INTO CARTHISTORY(EMAIL,LENDINGID,BILLID,ID,CQUANTITY,HOUR) VALUES ('$userid','$lendingid','$receiptid','$id','$cq','$hour')";
            $conn->query($sqlinsertcarthistory);
            
            $selectequipment = "SELECT * FROM EQUIPMENT WHERE ID = '$id'";
            $equipmentresult = $conn->query($selectequipment);
             if ($equipmentresult->num_rows > 0){
                  while ($rowp = $equipmentresult->fetch_assoc()){
                    $eqquantity = $rowp["QUANTITY"];
                   
                    $newquantity = $eqquantity - $cq; //quantity in store - quantity ordered by user
                  
                    $sqlupdatequantity = "UPDATE EQUIPMENT SET QUANTITY = '$newquantity' WHERE ID = '$id'";
                    $conn->query($sqlupdatequantity);
                  }
             }
        }
        
       $sqldeletecart = "DELETE FROM CART WHERE EMAIL = '$userid'";
       $sqlinsert = "INSERT INTO PAYMENT(LENDINGID,BILLID,USERID,TOTAL) VALUES ('$lendingid','$receiptid','$userid','$amount')";
       
       $conn->query($sqldeletecart);
       $conn->query($sqlinsert);
    }
        echo '<br><br><body><div><h2><br><br><center>Receipt</center></h1><table border=1 width=80% align=center><tr><td>Order id</td><td>'.$lendingid.'</td></tr><tr><td>Receipt ID</td><td>'.$receiptid.'</td></tr><tr><td>Email to </td><td>'.$userid. ' </td></tr><td>Amount </td><td>RM '.$amount.'</td></tr><tr><td>Payment Status </td><td>'.$paidstatus.'</td></tr><tr><td>Date </td><td>'.date("d/m/Y").'</td></tr><tr><td>Time </td><td>'.date("h:i a").'</td></tr></table><br><p><center>Press back button to return to MyLendSport</center></p></div></body>';
        //echo $sqlinsertcarthistory;
    } 
        else 
    {
    echo 'Payment Failed!';
    }
}

?>