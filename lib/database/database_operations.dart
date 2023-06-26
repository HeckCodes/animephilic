import 'package:animephilic/database/database_repository.dart';
import 'package:animephilic/database/models/stat_model.dart';
import 'package:animephilic/database/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseOperations {
  DatabaseOperations._privateConstructor();

  static final DatabaseOperations instance =
      DatabaseOperations._privateConstructor();

  final ConnectDatabase dbInstance = ConnectDatabase.instance;

  Future<void> updateUserData(User user) async {
    final db = await dbInstance.database;

    await db.insert(
      'User',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateUserStat(Stat stat) async {
    final db = await dbInstance.database;

    await db.insert(
      'Stat',
      stat.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User> getUserData() async {
    final db = await dbInstance.database;

    List<Map<String, dynamic>> results = await db.query('User');
    return User.fromMap(results.first);
  }

  Future<Stat> getUserStat() async {
    final db = await dbInstance.database;

    List<Map<String, dynamic>> results = await db.query('Stat');
    return Stat.fromMap(results.first);
  }
}
