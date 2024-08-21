<?php
header("Access-Control-Allow-Headers: Authorization, Content-Type");
header("Access-Control-Allow-Origin: https://mitrasite.com");
header("Access-Control-Allow-Method: GET, POST");
header('content-type: application/json; charset=utf-8');

$con = mysqli_connect("localhost", "u1466464_animart_internal", "uhex7vv0xfta", "u1466464_animart_internal");
$id_shop = $_GET['id_shop']; 
$sql = "select * from app_shop where id_shop = '$id_shop'";
$result = mysqli_query($con, $sql);
$response = array();
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $response[] = $row;
    }
    echo json_encode($response);
} else {
    echo json_encode(array('message' => 'No products found'));
}
$con->close();
?>