import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notes/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //singleton DatabaseHelper
  static Database _database; //singleton Database

  String notesTable = 'notes_table';
  String colId = 'id';
  String colTitle = 'title';
  String colText = 'text';
  String colDate = 'date';
  String colDone = 'done';

  DatabaseHelper._createInstance(); //named constructor to create instance of database

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    var notesDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDb;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $notesTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colText TEXT, $colDate TEXT, $colDone BOOLEAN NOT NULL)');
  }

  //crud

  //fetch
  Future<List<Map<String, dynamic>>> getNoteListMap() async {
    Database db = await this.database;
    var result = await db.query(notesTable);
    return result;
  }

  Future<List<Note>> getNoteList() async {
    List<Map<String, dynamic>> noteMapList = await getNoteListMap();
    List<Note> noteList = List<Note>.generate(
        noteMapList.length,
        (index) => Note.withId(
            noteMapList[index]['id'],
            noteMapList[index]['title'],
            noteMapList[index]['text'],
            noteMapList[index]['date'],
            noteMapList[index]['done']));
    return noteList;
  }

  //insert
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(notesTable, note.toMap());
    return result;
  }

  //update
  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    var result = await db.update(notesTable, note.toMap(),
        where: '$colId=?', whereArgs: [note.id]);
    return result;
  }

  //delete
  Future<int> deleteNote(Note note) async {
    Database db = await this.database;
    var result =
        await db.delete(notesTable, where: '$colId=?', whereArgs: [note.id]);
    return result;
  }

  //row count
  Future<int> notesCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) FROM $notesTable');
    int count = Sqflite.firstIntValue(x);
    return count;
  }
}
