import 'package:notes/model/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesHelper {
  static final tableName = "notes";
  static final columnId = "id";
  static final columnTitle = "title";
  static final columnDescription = "description";
  static final columnCreatedOn = "createOn";

  static final NotesHelper _notesHelper = NotesHelper._internal();
  Database? _db;

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

  Future<int> saveNote(Note note) async {
    Database database = await db;
    int id = await database.insert(tableName, note.toMap());
    return id;
  }

  readNotes() async {
    Database database = await db;
    var query = "SELECT * FROM $tableName ORDER BY $columnCreatedOn DESC";
    List notes = await database.rawQuery(query);
    return notes;
  }

  _onCreate(Database db, int version) async {
    var sql = "CREATE TABLE $tableName "
        "($columnId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$columnTitle VARCHAR, "
        "$columnDescription VARCHAR, "
        "$columnCreatedOn DATETIME)";
    await db.execute(sql);
  }
}