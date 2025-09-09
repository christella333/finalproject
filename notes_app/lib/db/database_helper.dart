import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "notes.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        date TEXT
      )
    ''');
  }

  // 👉 Méthodes CRUD

  Future<List<Note>> getNotes() async {
    Database db = await instance.database;
    var notes = await db.query('notes', orderBy: "id DESC");
    List<Note> notesList = notes.isNotEmpty
        ? notes.map((c) => Note.fromMap(c)).toList()
        : [];
    return notesList;
  }

  Future<int> insertNote(Note note) async {
    Database db = await instance.database;
    return await db.insert('notes', note.toMap());
  }

  Future<int> updateNote(Note note) async {
    Database db = await instance.database;
    return await db.update(
      'notes',
      note.toMap(),
      where: "id = ?",
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    Database db = await instance.database;
    return await db.delete('notes', where: "id = ?", whereArgs: [id]);
  }
}
