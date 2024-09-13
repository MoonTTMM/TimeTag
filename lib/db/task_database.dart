import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskDatabase {
  static final TaskDatabase instance = TaskDatabase._init();
  static Database? _database;

  TaskDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
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
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        taskName TEXT,
        startTime TEXT,
        duration TEXT
      )
    ''');
  }

  Future<void> insertTask(Task task) async {
    final db = await instance.database;
    await db.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteTask(String id) async {
    final db = await instance.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Task>> fetchTasks({DateTime? startDate, DateTime? endDate}) async {
    String whereClause = '';
    List<String> whereArgs = [];
    if (startDate != null && endDate != null) {
      whereClause = 'startTime BETWEEN ? AND ?';
      whereArgs = [startDate.toIso8601String(), endDate.toIso8601String()];
    }
    final db = await instance.database;
    final result = await db.query(
      'tasks',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );
    return result.map((json) => Task(
      id: json['id'] as String,
      taskName: json['taskName'] as String,
      startTime: _formatTime(json['startTime'] as String),
      duration: json['duration'] as String,
    )).toList();
  }

  Future<List<Task>> getTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');
    return result.map((json) => Task(
      id: json['id'] as String,
      taskName: json['taskName'] as String,
      startTime: _formatTime(json['startTime'] as String),
      duration: json['duration'] as String,
    )).toList();
  }

  Future<List<Map<String, dynamic>>> getSummaryByTag() async {
    final db = await instance.database;
    var result = await db.rawQuery(
      'select taskName, SUM(duration) as total_time from tasks group by taskName'
    );
    return result.toList();
  }

  Future<List<Map<String, dynamic>>> getTagCountOrder() async {
    final db = await instance.database;
    var result = await db.rawQuery(
      'select taskName, count(taskName) as tag_count from tasks group by taskName order by tag_count desc limit 7'
    );
    return result.toList();
  }

  String _formatTime(String timeString) {
    try {
      var dateTime = DateTime.parse(timeString);
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    } catch (e) {
      return "";
    }
  }
}
