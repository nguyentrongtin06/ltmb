import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'task_manager.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id TEXT PRIMARY KEY,
            username TEXT NOT NULL,
            password TEXT NOT NULL,
            email TEXT NOT NULL,
            avatar TEXT,
            createdAt TEXT NOT NULL,
            lastActive TEXT NOT NULL,
            isAdmin INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE tasks (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            status TEXT NOT NULL,
            priority INTEGER NOT NULL,
            dueDate TEXT,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL,
            assignedTo TEXT,
            createdBy TEXT NOT NULL,
            category TEXT,
            attachments TEXT,
            completed INTEGER NOT NULL,
            FOREIGN KEY (assignedTo) REFERENCES users(id),
            FOREIGN KEY (createdBy) REFERENCES users(id)
          )
        ''');
      },
    );
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> getUserByCredentials(String username, String password) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (maps.isNotEmpty) return User.fromMap(maps.first);
    return null;
  }

  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final maps = await db.query('users');
    return maps.map((map) => User.fromMap(map)).toList();
  }

  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Task?> getTask(String id) async {
    final db = await database;
    final maps = await db.query('tasks', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return Task.fromMap(maps.first);
    return null;
  }

  Future<List<Task>> getTasks({String? userId, bool isAdmin = false, String? status, String? category}) async {
    final db = await database;
    String? where;
    List<dynamic> whereArgs = [];
    if (!isAdmin && userId != null) {
      where = 'assignedTo = ?';
      whereArgs.add(userId);
    } else if (isAdmin && userId == null) {
      // Admin không áp dụng điều kiện assignedTo
      where = null;
    }
    if (status != null) {
      where = where != null ? '$where AND status = ?' : 'status = ?';
      whereArgs.add(status);
    }
    if (category != null) {
      where = where != null ? '$where AND category = ?' : 'category = ?';
      whereArgs.add(category);
    }
    print('Query: where=$where, args=$whereArgs'); // Debug
    final maps = await db.query('tasks', where: where, whereArgs: whereArgs);
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  Future<List<Task>> searchTasks(String query, {String? userId, bool isAdmin = false}) async {
    final db = await database;
    String where = 'title LIKE ? OR description LIKE ?';
    List<dynamic> whereArgs = ['%$query%', '%$query%'];
    if (!isAdmin && userId != null) {
      where += ' AND assignedTo = ?';
      whereArgs.add(userId);
    }
    print('Search query: where=$where, args=$whereArgs'); // Debug
    final maps = await db.query('tasks', where: where, whereArgs: whereArgs);
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}