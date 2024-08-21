<?php
header("Access-Control-Allow-Headers: Authorization, Content-Type");
header("Access-Control-Allow-Origin: https://mitrasite.com");
header("Access-Control-Allow-Method: GET, POST");
header('content-type: application/json; charset=utf-8');
if(!empty($_POST['username']) && !empty($_POST['email']) && !empty($_POST['password'])){
    //$con = mysqli_connect("localhost", "u1466464_nearco_app", "lyhWPZCvGMsK", "u1466464_nearco_app");
    $con = mysqli_connect("localhost", "u1466464_animart_internal", "uhex7vv0xfta", "u1466464_animart_internal");
    $username = $_POST['username'];
    $email = $_POST['email'];
    $password = $_POST['password'];
    //$password = password_hash($_POST['password'], PASSWORD_DEFAULT); 
    if ($con) {
        $sql = "update app_user SET apiKey = '' WHERE email = '$email'";
        if (mysqli_query($con, $sql)){
            $response['status'] = 200;
            $response['message'] = "You are logout! Please Sign In.";
            echo json_encode($response);
            exit();
        }else{
            header('Content-Type: application/json');
            $response['status'] = 300;
            $response['message'] = "Logout Failed.";
            echo json_encode($response);
            exit();
        }
    }else {
       
        $response['status'] = 600;
        $response['message'] = "Database Connection failed";
        echo json_encode($response);
        exit();
    }
}else{
        //header('Content-Type: application/json');
        $response['status'] = 700;
        $response['message'] = "All Fields are required";
        echo json_encode($response);
        exit();
}

