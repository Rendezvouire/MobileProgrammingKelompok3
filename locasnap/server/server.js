const express = require('express');
const cors = require('cors');
const mysql = require('mysql2');
const multer = require('multer');
const path = require('path');

const app = express();
const PORT = 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Supaya foto di folder uploads bisa dibuka lewat browser
app.use('/uploads', express.static('uploads'));

// Koneksi ke database MySQL (setting default XAMPP)
const db = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'locasnap',
  dateStrings: true   // supaya tanggal tampil apa adanya (tidak jadi format UTC)
});

// Cek koneksi database
db.getConnection((err, connection) => {
  if (err) {
    console.error('Gagal konek ke database:', err.message);
  } else {
    console.log('Berhasil konek ke database locasnap');
    connection.release();
  }
});

// Pengaturan upload foto (multer)
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    // nama file unik, contoh: 1727875200000.jpg
    cb(null, Date.now() + path.extname(file.originalname));
  }
});
const upload = multer({ storage: storage });

// Route tes
app.get('/', (req, res) => {
  res.json({ message: 'Server LocaSnap berjalan!' });
});

// Ambil semua lokasi
app.get('/locations', (req, res) => {
  db.query('SELECT * FROM locations ORDER BY created_at DESC', (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// Ambil satu lokasi berdasarkan id
app.get('/locations/:id', (req, res) => {
  db.query('SELECT * FROM locations WHERE id = ?', [req.params.id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length === 0) return res.status(404).json({ error: 'Lokasi tidak ditemukan' });
    res.json(results[0]);
  });
});

// Tambah lokasi baru + upload foto
app.post('/locations', upload.single('image'), (req, res) => {
  const { title, description, latitude, longitude } = req.body;

  if (!title || !latitude || !longitude) {
    return res.status(400).json({ error: 'title, latitude, dan longitude wajib diisi' });
  }

  const imageUrl = req.file ? '/uploads/' + req.file.filename : null;

  const sql = `INSERT INTO locations (title, description, latitude, longitude, image_url)
               VALUES (?, ?, ?, ?, ?)`;

  db.query(sql, [title, description, latitude, longitude, imageUrl], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({
      message: 'Lokasi berhasil ditambahkan',
      id: result.insertId,
      image_url: imageUrl
    });
  });
});

// Jalankan server
app.listen(PORT, () => {
  console.log(`Server berjalan di http://localhost:${PORT}`);
});