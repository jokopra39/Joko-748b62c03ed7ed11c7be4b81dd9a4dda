<?php
require "config/connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	$response = array();
	$userName = $_POST['username'];
	$idState = $_POST['idState'];

	$insert = "update users set last_login =  NOW(), login_state = '$idState' where username = '$userName' ";

	if (mysqli_query($con, $insert)) {
		$response['value'] = 1;
		$response['message'] = "Berhasil update";
		echo json_encode($response);
	} else {
		$response['value'] = 0;
		$response['message'] = "gagal update";
		echo json_encode($response);
	}

}