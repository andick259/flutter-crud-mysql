<?php
header("Access-Control-Allow-Headers: Authorization, Content-Type");
header("Access-Control-Allow-Origin: https://mitrasite.com");
header("Access-Control-Allow-Method: GET, POST");
header('content-type: application/json; charset=utf-8');
if(!empty($_POST['email']) && !empty($_POST['password'])){
    $email = $_POST['email'];
    $password = $_POST['password']; 
    $result = array();
    //$con = mysqli_connect("localhost", "u1466464_nearco_app", "lyhWPZCvGMsK", "u1466464_nearco_app");
    $con = mysqli_connect("localhost", "u1466464_animart_internal", "uhex7vv0xfta", "u1466464_animart_internal");
    if($con){
        $sql = "select * from app_user where email = '".$email."'";
        $res = mysqli_query($con, $sql);
        if(mysqli_num_rows($res) != 0){
            $row = mysqli_fetch_assoc($res);
            //if ($email == $row['email'] && password_verify($password, $row['password'])){
            if ($email == $row['email'] && $password == $row['password']){
                try {
                    $apiKey = bin2hex(random_bytes(23));
                } catch (Exception $e) {
                    $apiKey = bin2hex(uniqid($email, true));
                }
                $sqlUpdate = "update app_user set apiKey = '".$apiKey."' where email = '".$email."'";
                if (mysqli_query($con, $sqlUpdate)){
                    $response['status'] = 200;
                    $response['message'] = "Login Success.";
                    $response['username'] = $row['username'];
                    $response['email'] = $row['email'];
                    $response['apiKey'] = $row['apiKey'];
                    $response['id_user'] = $row['id_user'];
                    $response['password'] = $row['password'];
                    echo json_encode($response);
                    exit();
                } else 
                $response['status'] = 300;
                $response['message'] = "Login Failed.";
                echo json_encode($response);
                exit();

            }else
                $response['status'] = 400;
                $response['message'] = "Retry with correct email and password";
                echo json_encode($response);
                exit();

        }else
                $response['status'] = 500;
                $response['message'] = "Account not found";
                echo json_encode($response);
                exit();

    }else 
                $response['status'] = 600;
                $response['message'] = "Database Connection failed";
                echo json_encode($response);
                exit();

}else
                $response['status'] = 700;
                $response['message'] = "All Fields are required";
                echo json_encode($response);
                exit();
