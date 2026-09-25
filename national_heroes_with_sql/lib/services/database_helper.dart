import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('national_heroes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Tabel Pahlawan / Post
    await db.execute('''
      CREATE TABLE heroes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    // Tabel Komentar
    await db.execute('''
      CREATE TABLE comments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        post_id INTEGER NOT NULL,
        username TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (post_id) REFERENCES heroes (id) ON DELETE CASCADE
      )
    ''');
  }

  // Mengambil komentar berdasarkan ID Pahlawan / Post
  Future<List<Map<String, dynamic>>> getCommentsByPostId(int heroId) async {
    final db = await instance.database;
    return await db.query(
      'comments',
      where: 'post_id = ?',
      whereArgs: [heroId],
      orderBy: 'created_at DESC',
    );
  }

  // Menyimpan komentar baru
  Future<int> insertComment(int heroId, String name, String comment) async {
    final db = await instance.database;
    final data = {
      'post_id': heroId,
      'username': name,
      'content': comment,
      'created_at': DateTime.now().toIso8601String(),
    };
    return await db.insert('comments', data);
  }
}
