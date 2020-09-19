<?php
require "config/connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	$response = array();
	$username = $_POST['username'];

	$cek = "select * from users where username='$username'";
	$result = mysqli_query($con, $cek);
	$row = mysqli_fetch_array($result, MYSQLI_ASSOC);

	if (isset($row)) {
		$response['value'] = 1;
		$response['username'] = $row["username"];
		$response['loginState'] = $row["login_state"];
		echo json_encode($response);
	} else {
		$response['value'] = 0;
		$response['message'] = "Login Gagal";
		echo json_encode($response);
	}

}