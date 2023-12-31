import 'package:animephilic/database/database_repository.dart';
import 'package:animephilic/database/models/seasonal_anime_model.dart';
import 'package:animephilic/database/models/stat_model.dart';
import 'package:animephilic/database/models/user_anime_list_model.dart';
import 'package:animephilic/database/models/user_manga_list_model.dart';
import 'package:animephilic/database/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseOperations {
  DatabaseOperations._privateConstructor();

  static final DatabaseOperations instance = DatabaseOperations._privateConstructor();

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

  Future<void> updateUserAnime(UserAnimeListItem animeListItem) async {
    final db = await dbInstance.database;

    await db.insert(
      'UserAnimeList',
      animeListItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateUserManga(UserMangaListItem mangaListItem) async {
    final db = await dbInstance.database;

    await db.insert(
      'UserMangaList',
      mangaListItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateSeasonalAnime(SeasonalAnimeItem seasonalAnimeItem) async {
    final db = await dbInstance.database;

    await db.insert(
      'SeasonalAnime',
      seasonalAnimeItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateUserAnimeList(List<UserAnimeListItem> userAnimeList) async =>
      await Future.forEach(userAnimeList, (item) => updateUserAnime(item));

  Future<void> updateUserMangaList(List<UserMangaListItem> userMangaList) async =>
      await Future.forEach(userMangaList, (item) => updateUserManga(item));

  Future<void> updateSeasonalAnimeList(List<SeasonalAnimeItem> seasonalAnimeList) async =>
      await Future.forEach(seasonalAnimeList, (item) => updateSeasonalAnime(item));

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

  Future<List<UserAnimeListItem>> getUserAnimeList({
    String status = 'all',
    String orderBy = 'none',
    String order = 'DESC',
  }) async {
    final db = await dbInstance.database;

    if (orderBy == 'none') {
      if (status == "all") {
        List<Map<String, dynamic>> results = await db.query('UserAnimeList');
        return List.generate(results.length, (index) => UserAnimeListItem.fromMap(results[index]));
      } else {
        List<Map<String, dynamic>> results = await db.query('UserAnimeList', where: "status == '$status'");
        return List.generate(results.length, (index) => UserAnimeListItem.fromMap(results[index]));
      }
    } else {
      if (status == "all") {
        List<Map<String, dynamic>> results = await db.query('UserAnimeList', orderBy: '$orderBy $order');
        return List.generate(results.length, (index) => UserAnimeListItem.fromMap(results[index]));
      } else {
        List<Map<String, dynamic>> results =
            await db.query('UserAnimeList', where: "status == '$status'", orderBy: '$orderBy $order');
        return List.generate(results.length, (index) => UserAnimeListItem.fromMap(results[index]));
      }
    }
  }

  Future<List<UserMangaListItem>> getUserMangaList({
    String status = 'all',
    String orderBy = 'none',
    String order = 'DESC',
  }) async {
    final db = await dbInstance.database;

    if (orderBy == 'none') {
      if (status == "all") {
        List<Map<String, dynamic>> results = await db.query('UserMangaList');
        return List.generate(results.length, (index) => UserMangaListItem.fromMap(results[index]));
      } else {
        List<Map<String, dynamic>> results = await db.query('UserMangaList', where: "status == '$status'");
        return List.generate(results.length, (index) => UserMangaListItem.fromMap(results[index]));
      }
    } else {
      if (status == "all") {
        List<Map<String, dynamic>> results = await db.query('UserMangaList', orderBy: '$orderBy $order');
        return List.generate(results.length, (index) => UserMangaListItem.fromMap(results[index]));
      } else {
        List<Map<String, dynamic>> results =
            await db.query('UserMangaList', where: "status == '$status'", orderBy: '$orderBy $order');
        return List.generate(results.length, (index) => UserMangaListItem.fromMap(results[index]));
      }
    }
  }

  Future<List<SeasonalAnimeItem>> getSeasonalAnimeList({
    String orderBy = 'none',
    String order = 'DESC',
    required int year,
    required String season,
  }) async {
    final db = await dbInstance.database;

    if (orderBy == 'none') {
      List<Map<String, dynamic>> results = await db.query(
        'SeasonalAnime',
        where: "year == $year AND season == '$season'",
      );
      return List.generate(results.length, (index) => SeasonalAnimeItem.fromMap(results[index]));
    } else {
      List<Map<String, dynamic>> results = await db.query(
        'SeasonalAnime',
        where: "year == $year AND season == '$season'",
        orderBy: '$orderBy $order',
      );
      return List.generate(results.length, (index) => SeasonalAnimeItem.fromMap(results[index]));
    }
  }
}
