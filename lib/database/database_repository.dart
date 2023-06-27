import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ConnectDatabase {
  ConnectDatabase._privateConstructor();

  static final ConnectDatabase instance = ConnectDatabase._privateConstructor();

  Database? _database;

  Future<Database> get database async {
    final dbPath = await getDatabasesPath();

    const dbName = 'animephilic.db';

    final path = join(dbPath, dbName);

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );

    return _database!;
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE User(
        id INTEGER PRIMARY KEY,
        name TEXT,
        picture TEXT,
        gender TEXT,
        birthday TEXT,
        location TEXT,
        joined TEXT,
        timezone TEXT,
        isSupporter INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE Stat(
        id INTEGER PRIMARY KEY,
        numItemsWatching INTEGER,
        numItemsCompleted INTEGER,
        numItemsOnHold INTEGER,
        numItemsDropped INTEGER,
        numItemsPlanToWatch INTEGER,
        numItems INTEGER,
        numEpisodes INTEGER,
        numTimesRewatched INTEGER,
        numDaysWatched TEXT,
        numDaysWatching TEXT,
        numDaysCompleted TEXT,
        numDaysOnHold TEXT,
        numDaysDropped TEXT,
        numDays TEXT,
        meanScore TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE UserAnimeList(
        id INTEGER PRIMARY KEY,
        title TEXT,
        mediumImage TEXT,
        largeImage TEXT,
        status TEXT,
        score INTEGER,
        episodesWatched INTEGER,
        isRewatching INT,
        updatedAt TEXT
      )
    ''');
  }
}
