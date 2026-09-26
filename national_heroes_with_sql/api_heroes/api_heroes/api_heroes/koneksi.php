<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit(0);
}

$host = "localhost";
$user = "root";
$password = "";
$database = "national_heroes";

$koneksi = new mysqli($host, $user, $password, $database);

if ($koneksi->connect_error) {
    die(json_encode([
        'status' => false,
        'message' => 'Koneksi database gagal: ' . $koneksi->connect_error
    ]));
}

?>