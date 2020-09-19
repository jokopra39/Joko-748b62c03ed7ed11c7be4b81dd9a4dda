<?php
require "config/connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	$response = array();
	$username = $_POST['username'];
	$password = $_POST['password'];

	$cek = "select * from users where username='$username' and password='$password'";
	$result = mysqli_query($con, $cek);
	$row = mysqli_fetch_array($result, MYSQLI_ASSOC);

	if (isset($row)) {
		$response['value'] = 1;
		$response['message'] = "Login Berhasil!";
		$response['username'] = $row["username"];
		$response['login_state'] = $row["login_state"];
		echo json_encode($response);
	} else {
		$response['value'] = 0;
		$response['message'] = "Login Gagal";
		echo json_encode($response);
	}

}