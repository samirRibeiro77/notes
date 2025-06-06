import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesHelper {
  static final NotesHelper _notesHelper = NotesHelper._internal();
  late Database? _db;

  NotesHelper._internal();

  factory NotesHelper(){
    return _notesHelper;
  }

  get db async {
    _db ??= await _initDb();
    return _db;
  }

  _initDb() async {
    final dbPath = await getDatabasesPath();
    final localDb = join(dbPath, "com.sjr77.notes");
    
    var db = await openDatabase(localDb, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    var sql = "CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title VARCHAR, description VARCHAR, datetime DATETIME)";
    await db.execute(sql);
  }
}