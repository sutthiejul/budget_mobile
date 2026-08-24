import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chat_local.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        msg TEXT NOT NULL,
        timestamp INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertMessage(
    String username,
    String msg, {
    int? timestamp,
  }) async {
    final db = await instance.database;
    final time = timestamp ?? DateTime.now().millisecondsSinceEpoch;

    // ตรวจสอบจำนวนแถวทั้งหมดในฐานข้อมูล SQLite
    final countResult = await db.rawQuery(
      'SELECT COUNT(*) as cnt FROM messages',
    );
    int totalCount = Sqflite.firstIntValue(countResult) ?? 0;

    // หากเกิน 200 บรรทัด ให้เคลียร์ข้อความทิ้งทั้งหมดและเริ่มเก็บใหม่
    if (totalCount >= 200) {
      await db.delete('messages');
    }

    return await db.insert('messages', {
      'username': username,
      'msg': msg,
      'timestamp': time,
    });
  }

  Future<void> syncHistory(List<dynamic> historyList) async {
    final db = await instance.database;
    await db.delete('messages'); // ล้างข้อมูลเก่าเพื่อซิงค์ประวัติชุดล่าสุด

    // ตัดประวัติให้เก็บไม่เกิน 200 รายการล่าสุด
    final trimmedHistory =
        historyList.length > 200
            ? historyList.sublist(historyList.length - 200)
            : historyList;

    for (var item in trimmedHistory) {
      await db.insert('messages', {
        'username': item['username'] ?? '',
        'msg': item['msg'] ?? '',
        'timestamp': item['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  Future<List<Map<String, dynamic>>> getAllMessages() async {
    final db = await instance.database;
    return await db.query('messages', orderBy: 'id ASC');
  }

  Future<void> clearAll() async {
    final db = await instance.database;
    await db.delete('messages');
  }
}
