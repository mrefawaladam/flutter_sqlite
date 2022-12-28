import 'package:learningsqlite/model/kontak.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;

  //inisialisasi beberapa variabel yang dibutuhkan
  final String tableName = 'tableMahasiswa';
  final String columnId = 'id';
  final String columnNama = 'nama';
  final String columnNim = 'nim';
  final String columnAlamat = 'alamat';
  final String columnJk = 'jk';

  DbHelper._internal();
  factory DbHelper() => _instance;

  //cek apakah database ada
  Future<Database?> get _db  async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDb();
    return _database;
  }

  Future<Database?> _initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'biodata.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  //membuat tabel dan field-fieldnya
  Future<void> _onCreate(Database db, int version) async {
    var sql = "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, "
        "$columnNama TEXT,"
        "$columnNim TEXT,"
        "$columnAlamat TEXT,"
        "$columnJk TEXT)";
    await db.execute(sql);
  }

  //insert ke database
  Future<int?> saveKontak(Biodata biodata) async {
    var dbClient = await _db;
    return await dbClient!.insert(tableName, biodata.toMap());
  }

  //read database
  Future<List?> getAllKontak() async {
    var dbClient = await _db;
    var result = await dbClient!.query(tableName, columns: [
      columnId,
      columnNama,
      columnNim,
      columnAlamat,
      columnJk
    ]);

    return result.toList();
  }

  //update database
  Future<int?> updateKontak(Biodata kontak) async {
    var dbClient = await _db;
    return await dbClient!.update(tableName, kontak.toMap(), where: '$columnId = ?', whereArgs: [kontak.id]);
  }

  //hapus database
  Future<int?> deleteKontak(int id) async {
    var dbClient = await _db;
    return await dbClient!.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }
}