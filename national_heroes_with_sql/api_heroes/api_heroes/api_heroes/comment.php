<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

include 'koneksi.php';

// HANDLE GET: Mengambil daftar komentar berdasarkan hero_id
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $hero_id = isset($_GET['hero_id']) ? intval($_GET['hero_id']) : 0;
    
    $query = "SELECT * FROM comments WHERE hero_id = $hero_id ORDER BY created_at DESC";
    $result = $koneksi->query($query);
    
    $data = [];
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
    
    echo json_encode([
        'status' => true,
        'data' => $data
    ]);
    exit();
}

// HANDLE POST: Menambahkan komentar baru
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    $hero_id = isset($input['hero_id']) ? intval($input['hero_id']) : 0;
    $name = isset($input['name']) ? $koneksi->real_escape_string($input['name']) : '';
    $comment = isset($input['comment']) ? $koneksi->real_escape_string($input['comment']) : '';
    
    if ($hero_id > 0 && !empty($name) && !empty($comment)) {
        $query = "INSERT INTO comments (hero_id, name, comment) VALUES ($hero_id, '$name', '$comment')";
        if ($koneksi->query($query)) {
            echo json_encode([
                'status' => true,
                'message' => 'Komentar berhasil ditambahkan'
            ]);
        } else {
            echo json_encode([
                'status' => false,
                'message' => 'Gagal menyimpan komentar: ' . $koneksi->error
            ]);
        }
    } else {
        echo json_encode([
            'status' => false,
            'message' => 'Data komentar tidak lengkap'
        ]);
    }
    exit();
}
?>