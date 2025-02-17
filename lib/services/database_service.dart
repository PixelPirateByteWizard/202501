import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/practice_record.dart';
import 'dart:io';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, 'practice_records.db');

    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE practice_records(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            instrument TEXT NOT NULL,
            duration INTEGER NOT NULL,
            notes TEXT NOT NULL
          )
        ''');
      },
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<int> insertRecord(PracticeRecord record) async {
    final db = await database;
    return await db.insert('practice_records', record.toMap());
  }

  Future<List<PracticeRecord>> getRecordsForDate(DateTime date) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final results = await db.query(
      'practice_records',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startOfDay.toIso8601String(), endOfDay.toIso8601String()],
    );

    return results.map((record) => PracticeRecord.fromMap(record)).toList();
  }

  Future<int> deleteRecord(int id) async {
    final db = await database;
    return await db.delete(
      'practice_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Set<DateTime>> getDatesWithRecords() async {
    final db = await database;
    final results = await db.query(
      'practice_records',
      columns: ['date'],
      distinct: true,
      orderBy: 'date DESC',
    );

    return results
        .map((record) => DateTime.parse(record['date'] as String))
        .map((date) => DateTime(date.year, date.month, date.day))
        .toSet();
  }
}
