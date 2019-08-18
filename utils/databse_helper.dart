import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:to_do_app/model/note.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'proirity';
  String colDate = 'date';

  DatabaseHelper._createInstence();
  
  factory DatabaseHelper(){
    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper._createInstence();
    }
    return _databaseHelper;
  }

  Future<Database> get database async{
    if(_database ==  null){
      _database = await initDb();
    }
    return _database;
  }

  Future<Database> initDb() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    var notedDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return notedDb;
  }

  void _createDb(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $noteTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT $colDescription TEXT, $colPriority INTEGER, $colDate TEXT )');
  }

// get data from database
  Future<List<Map<String, dynamic>>> getDataToMap () async{
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $noteTable ORDER BY $colPriority ASC');
    return result;
  }

// insert data
  Future<int> insertData(Note note) async{
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

// update data 
  Future<int> updateData(Note note) async{
    Database db = await this.database;
    var result = await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

// delete date
  Future<int> deleteNode(int id) async{
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

// get number of Notes objects in database
  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT(*) FROM $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }
}