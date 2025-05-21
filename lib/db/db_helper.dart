// lib/db/db_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/movie_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("movies.db");
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE movies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        genre TEXT,
        release_year INTEGER,
        status TEXT,
        rating INTEGER,
        notes TEXT
      )
    ''');
  }

  Future<int> insertMovie(Movie movie) async {
    final db = await database;
    return await db.insert('movies', movie.toMap());
  }

  Future<List<Movie>> getAllMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('movies');
    return maps.map((map) => Movie.fromMap(map)).toList();
  }

  Future<int> updateMovie(Movie movie) async {
    final db = await database;
    return await db.update('movies', movie.toMap(), where: 'id = ?', whereArgs: [movie.id]);
  }

  Future<int> deleteMovie(int id) async {
    final db = await database;
    return await db.delete('movies', where: 'id = ?', whereArgs: [id]);
  }
}
