<?php
header("Access-Control-Allow-Headers: Authorization, Content-Type");
header("Access-Control-Allow-Origin: https://mitrasite.com");
header("Access-Control-Allow-Method: GET, POST");
header('content-type: application/json; charset=utf-8');

$con = mysqli_connect("localhost", "u1466464_animart_internal", "uhex7vv0xfta", "u1466464_animart_internal");
$sql = "SELECT * FROM app_shop WHERE status = 'Aktif' ORDER BY id_shop DESC LIMIT 4";

$result = mysqli_query($con, $sql);
$response = array();
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $response[] = $row;
    }
    echo json_encode($response);
} else {
    echo json_encode(array('message' => 'No products found for this user'));
}
$con->close();
?>