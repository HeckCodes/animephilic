import 'dart:convert';

import 'package:animephilic/authentication/authentication_exports.dart';
import 'package:animephilic/database/database_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void sortDialog(BuildContext context, String status, bool isAnime) async {
  showDialog<(bool, String, String)>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      String? orderBy = 'none';
      String? order = 'DESC';
      return AlertDialog(
        title: const Text('Sort by'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile(
                  title: const Text('None'),
                  subtitle: const Text("Keep the default view"),
                  value: 'none',
                  groupValue: orderBy,
                  onChanged: (value) => setState(() => orderBy = value),
                ),
                RadioListTile(
                  title: const Text("Title"),
                  subtitle: const Text("Sort based on alphabetical order"),
                  value: 'title',
                  groupValue: orderBy,
                  onChanged: (value) => setState(() => orderBy = value),
                ),
                RadioListTile(
                  title: const Text("Score"),
                  subtitle: const Text("Sort based on rating"),
                  value: 'score',
                  groupValue: orderBy,
                  onChanged: (value) => setState(() => orderBy = value),
                ),
                RadioListTile(
                  title: const Text("Updated At"),
                  subtitle: const Text("Sort based on last updated item"),
                  value: 'updatedAt',
                  groupValue: orderBy,
                  onChanged: (value) => setState(() => orderBy = value),
                ),
                const Divider(thickness: 2),
                RadioListTile(
                  title: const Text("Ascending Order"),
                  value: 'ASC',
                  groupValue: order,
                  onChanged: (value) => setState(() => order = value),
                ),
                RadioListTile(
                  title: const Text("Descending Order"),
                  value: 'DESC',
                  groupValue: order,
                  onChanged: (value) => setState(() => order = value),
                ),
              ],
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, (true, orderBy, order)),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, (false, orderBy, order)),
            child: const Text('OK'),
          ),
        ],
      );
    },
  ).then((value) {
    var (bool isCancel, String orderBy, String order) = value!;
    if (isCancel || orderBy == 'none') return;
    if (isAnime) {
      UserAnimeListBloc.instance.add(UserAnimeListEventLoadData(
        status: status,
        orderBy: orderBy,
        order: order,
      ));
    } else {
      UserMangaListBloc.instance.add(UserMangaListEventLoadData(
        status: status,
        orderBy: orderBy,
        order: order,
      ));
    }
  });
}

void seasonalSortDialog(BuildContext context, int year, String season) async {
  showDialog<(bool, String, String)>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      String? orderBy = 'none';
      String? order = 'DESC';
      return AlertDialog(
        title: const Text('Sort by'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(
                    title: const Text('None'),
                    subtitle: const Text("Keep the default view"),
                    value: 'none',
                    groupValue: orderBy,
                    onChanged: (value) => setState(() => orderBy = value),
                  ),
                  RadioListTile(
                    title: const Text("Title"),
                    subtitle: const Text("Sort based on alphabetical order"),
                    value: 'title',
                    groupValue: orderBy,
                    onChanged: (value) => setState(() => orderBy = value),
                  ),
                  RadioListTile(
                    title: const Text("Mean score"),
                    subtitle: const Text("Sort based on average rating"),
                    value: 'mean',
                    groupValue: orderBy,
                    onChanged: (value) => setState(() => orderBy = value),
                  ),
                  RadioListTile(
                    title: const Text("Popularity"),
                    subtitle: const Text("Select ascending for most popular"),
                    value: 'popularity',
                    groupValue: orderBy,
                    onChanged: (value) => setState(() => orderBy = value),
                  ),
                  const Divider(thickness: 2),
                  RadioListTile(
                    title: const Text("Ascending Order"),
                    value: 'ASC',
                    groupValue: order,
                    onChanged: (value) => setState(() => order = value),
                  ),
                  RadioListTile(
                    title: const Text("Descending Order"),
                    value: 'DESC',
                    groupValue: order,
                    onChanged: (value) => setState(() => order = value),
                  ),
                ],
              ),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, (true, orderBy, order)),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, (false, orderBy, order)),
            child: const Text('OK'),
          ),
        ],
      );
    },
  ).then((value) {
    var (bool isCancel, String orderBy, String order) = value!;
    if (isCancel || orderBy == 'none') return;
    SeasonalAnimeBloc.instance.add(SeasonalAnimeEventLoadData(
      year: year,
      season: season,
      orderBy: orderBy,
      order: order,
    ));
  });
}

SystemUiOverlayStyle getOverlayStyle(BuildContext context) => SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).scaffoldBackgroundColor,
      systemNavigationBarColor: ElevationOverlay.applySurfaceTint(
        Theme.of(context).colorScheme.surface,
        Theme.of(context).colorScheme.surfaceTint,
        3,
      ),
      statusBarIconBrightness:
          MediaQuery.of(context).platformBrightness == Brightness.light ? Brightness.dark : Brightness.light,
      systemNavigationBarIconBrightness:
          MediaQuery.of(context).platformBrightness == Brightness.light ? Brightness.dark : Brightness.light,
    );

void seasonChangeHandle(BuildContext context, int value, DateTime now, Function(DateTime) setNow, Function() setSeason,
    String season, int iterator) {
  if (value == 0) {
    showDialog<(bool, DateTime)>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        DateTime selected = now;
        return AlertDialog(
          title: const Text("Select Year"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 3 / 4,
                child: YearPicker(
                  firstDate: DateTime(1917),
                  lastDate: DateTime(DateTime.now().year + 1),
                  currentDate: DateTime.now(),
                  selectedDate: selected,
                  onChanged: (newDate) {
                    setState(() {
                      selected = newDate;
                    });
                  },
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, (true, selected)),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, (false, selected)),
              child: const Text('OK'),
            ),
          ],
        );
      },
    ).then((value) {
      var (isCancel, date) = value!;
      if (!isCancel) {
        setNow(date);
        SeasonalAnimeBloc.instance.add(SeasonalAnimeEventLoadData(year: date.year, season: season));
      }
    });
  } else {
    List<String> seasons = ['winter', 'spring', 'summer', 'fall'];
    setSeason();
    SeasonalAnimeBloc.instance.add(SeasonalAnimeEventLoadData(year: now.year, season: seasons[++iterator % 4]));
  }
}

Future<List<SeasonalAnimeItem>> getSeasonalAnime(int year, String season) async {
  http.Response response = await http.get(
    Uri.parse(
        'https://api.myanimelist.net/v2/anime/season/$year/$season?limit=15&fields=${AnimeFieldOptions().animeSeasonalFields}'),
    headers: {'Authorization': "Bearer ${Authentication().accessToken}"},
  );
  Map<String, dynamic> jsonData = jsonDecode(response.body);
  List<dynamic> seasonalAnimeJsonList = jsonData['data'];

  return List.generate(
    seasonalAnimeJsonList.length,
    (index) => SeasonalAnimeItem.fromJSON(
      seasonalAnimeJsonList[index],
      year,
      season,
    ),
  );
}

Future<List<RecommendedAnimeItem>> getRecommendedAnime() async {
  http.Response response = await http.get(
    Uri.parse('https://api.myanimelist.net/v2/anime/suggestions?limit=50&fields=mean'),
    headers: {'Authorization': "Bearer ${Authentication().accessToken}"},
  );
  Map<String, dynamic> jsonData = jsonDecode(response.body);
  List<dynamic> recommendedAnimeJsonList = jsonData['data'];

  return List.generate(
    recommendedAnimeJsonList.length,
    (index) => RecommendedAnimeItem.fromJSON(
      recommendedAnimeJsonList[index],
    ),
  );
}

Future<AnimeDetails> getAnimeDetails(int id) async {
  http.Response response = await http.get(
    Uri.parse('https://api.myanimelist.net/v2/anime/$id?fields=${AnimeFieldOptions().animeFull}'),
    headers: {'Authorization': "Bearer ${Authentication().accessToken}"},
  );

  return AnimeDetails.fromMap(jsonDecode(response.body));
}

Future<MangaDetails> getMangaDetails(int id) async {
  http.Response response = await http.get(
    Uri.parse(
        'https://api.myanimelist.net/v2/manga/$id?fields=${AnimeFieldOptions().animeFull},num_volumes,num_chapters,authors{first_name,last_name},serialization{name}'),
    headers: {'Authorization': "Bearer ${Authentication().accessToken}"},
  );

  return MangaDetails.fromMap(jsonDecode(response.body));
}

Future getSearch(String searchFor, String search, bool shouldGet) async {
  if (shouldGet) {
    http.Response response = await http.get(
      Uri.parse('https://api.myanimelist.net/v2/$searchFor?q=$search&limit=100'),
      headers: {'Authorization': "Bearer ${Authentication().accessToken}"},
    );
    return jsonDecode(response.body);
  } else {
    return {};
  }
}

Future<http.Response?> animeDataUpdateHandler(
    BuildContext context, int animeId, MyListStatus? myListStatus, int numEpisodes) async {
  var record = await showDialog<(bool, double, String?, String)>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      double score = (myListStatus?.myScore.toDouble() ?? 0) / 10;
      String? status = myListStatus?.myStatus;
      TextEditingController epWatchedController = TextEditingController(text: myListStatus?.numberEpWatched.toString());
      return SingleChildScrollView(
        child: AlertDialog(
          title: const Text("Update Details"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(
                    dense: true,
                    title: const Text('None'),
                    value: 'none',
                    groupValue: status,
                    onChanged: (value) => setState(() => status = value),
                  ),
                  RadioListTile(
                    dense: true,
                    title: const Text("Plan To Watch"),
                    value: 'plan_to_watch',
                    groupValue: status,
                    onChanged: (value) => setState(() => status = value),
                  ),
                  RadioListTile(
                    dense: true,
                    title: const Text("Watching"),
                    value: 'watching',
                    groupValue: status,
                    onChanged: (value) => setState(() => status = value),
                  ),
                  RadioListTile(
                    dense: true,
                    title: const Text("Completed"),
                    value: 'completed',
                    groupValue: status,
                    onChanged: (value) => setState(() => status = value),
                  ),
                  RadioListTile(
                    dense: true,
                    title: const Text("On Hold"),
                    value: 'on_hold',
                    groupValue: status,
                    onChanged: (value) => setState(() => status = value),
                  ),
                  RadioListTile(
                    dense: true,
                    title: const Text("Dropped"),
                    value: 'dropped',
                    groupValue: status,
                    onChanged: (value) => setState(() => status = value),
                  ),
                  const Divider(thickness: 2),
                  const Text(
                    "Episodes Watched",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (epWatchedController.text.isNotEmpty) {
                            int cnt = int.parse(epWatchedController.text);
                            if (cnt > 0) {
                              setState(() {
                                epWatchedController.text = (--cnt).toString();
                              });
                            }
                          }
                        },
                        icon: const Icon(Icons.arrow_drop_down_rounded, size: 44),
                      ),
                      SizedBox(
                        width: 80,
                        height: 50,
                        child: TextField(
                          controller: epWatchedController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(0),
                            isDense: true,
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24),
                          readOnly: true,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (epWatchedController.text.isNotEmpty) {
                            int cnt = int.parse(epWatchedController.text);
                            if (cnt < (numEpisodes == 0 ? 8000 : numEpisodes)) {
                              setState(() {
                                epWatchedController.text = (++cnt).toString();
                              });
                            }
                          } else {
                            setState(() {
                              epWatchedController.text = '0';
                            });
                          }
                        },
                        icon: const Icon(Icons.arrow_drop_up_rounded, size: 44),
                      ),
                    ],
                  ),
                  const Divider(thickness: 2),
                  Text(
                    "Score: ${(score * 10).toInt()}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    divisions: 10,
                    value: score,
                    onChanged: (value) {
                      setState(() {
                        score = value;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, (true, score, status, epWatchedController.text)),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, (false, score, status, epWatchedController.text)),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    },
  );

  if (record == null || record.$1) return null;

  return http.put(
    Uri.parse('https://api.myanimelist.net/v2/anime/$animeId/my_list_status'),
    headers: {
      'Authorization': "Bearer ${Authentication().accessToken}",
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'status': record.$3,
      'score': (record.$2 * 10).round().toString(),
      'num_watched_episodes': record.$4.isEmpty ? '0' : record.$4,
    },
  );
}

Future<http.Response?> mangaDataUpdateHandler(
  BuildContext context,
  int mangaId,
  MyMangaListStatus? myMangaListStatus,
  int chapters,
  int volumes,
) async {
  var record = await showDialog<(bool, double, String?, String, String)>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      double score = (myMangaListStatus?.myScore.toDouble() ?? 0) / 10;
      String? status = myMangaListStatus?.myStatus;
      TextEditingController volumesController = TextEditingController(text: myMangaListStatus?.volumesRead.toString());
      TextEditingController chaptersController =
          TextEditingController(text: myMangaListStatus?.chaptersRead.toString());
      return SingleChildScrollView(
        child: AlertDialog(
          title: const Text("Update Details"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(
                    dense: true,
                    title: const Text('None'),
                    value: 'none',
                    groupValue: status,
                    onChanged: (value) => setState(() => status = value),
                  ),
                  RadioListTile(
                    dense: true,
                    title: const Text("Plan To Read"),
                    value: 'plan_to_read',
                    groupValue: status,
                    onChanged: (value) => setState(() => status = value),
                  ),
                  RadioListTile(
                    dense: true,
                    title: const Text("Reading"),
                    value: 'reading',
                    groupValue: status,
                    onChanged: (value) => setState(() => status = value),
                  ),
                  RadioListTile(
                    dense: true,
                    title: const Text("Completed"),
                    value: 'completed',
                    groupValue: status,
                    onChanged: (value) => setState(() => status = value),
                  ),
                  RadioListTile(
                    dense: true,
                    title: const Text("On Hold"),
                    value: 'on_hold',
                    groupValue: status,
                    onChanged: (value) => setState(() => status = value),
                  ),
                  RadioListTile(
                    dense: true,
                    title: const Text("Dropped"),
                    value: 'dropped',
                    groupValue: status,
                    onChanged: (value) => setState(() => status = value),
                  ),
                  const Divider(thickness: 2),
                  const Text(
                    "Chapters Read",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (chaptersController.text.isNotEmpty) {
                            int cnt = int.parse(chaptersController.text);
                            if (cnt > 0) {
                              setState(() {
                                chaptersController.text = (--cnt).toString();
                              });
                            }
                          }
                        },
                        icon: const Icon(Icons.arrow_drop_down_rounded, size: 44),
                      ),
                      SizedBox(
                        width: 80,
                        height: 50,
                        child: TextField(
                          controller: chaptersController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(0),
                            isDense: true,
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24),
                          readOnly: true,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (chaptersController.text.isNotEmpty) {
                            int cnt = int.parse(chaptersController.text);
                            if (cnt < (chapters == 0 ? 8000 : chapters)) {
                              setState(() {
                                chaptersController.text = (++cnt).toString();
                              });
                            }
                          } else {
                            setState(() {
                              chaptersController.text = '0';
                            });
                          }
                        },
                        icon: const Icon(Icons.arrow_drop_up_rounded, size: 44),
                      ),
                    ],
                  ),
                  const Divider(thickness: 2),
                  const Text(
                    "Volumes Read",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (volumesController.text.isNotEmpty) {
                            int cnt = int.parse(volumesController.text);
                            if (cnt > 0) {
                              setState(() {
                                volumesController.text = (--cnt).toString();
                              });
                            }
                          }
                        },
                        icon: const Icon(Icons.arrow_drop_down_rounded, size: 44),
                      ),
                      SizedBox(
                        width: 80,
                        height: 50,
                        child: TextField(
                          controller: volumesController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(0),
                            isDense: true,
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24),
                          readOnly: true,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (volumesController.text.isNotEmpty) {
                            int cnt = int.parse(volumesController.text);
                            if (cnt < (volumes == 0 ? 8000 : volumes)) {
                              setState(() {
                                volumesController.text = (++cnt).toString();
                              });
                            }
                          } else {
                            setState(() {
                              volumesController.text = '0';
                            });
                          }
                        },
                        icon: const Icon(Icons.arrow_drop_up_rounded, size: 44),
                      ),
                    ],
                  ),
                  const Divider(thickness: 2),
                  Text(
                    "Score: ${(score * 10).toInt()}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    divisions: 10,
                    value: score,
                    onChanged: (value) {
                      setState(() {
                        score = value;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, (true, score, status, chaptersController.text, volumesController.text)),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, (false, score, status, chaptersController.text, volumesController.text)),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    },
  );

  if (record == null || record.$1) return null;

  return http.put(
    Uri.parse('https://api.myanimelist.net/v2/manga/$mangaId/my_list_status'),
    headers: {
      'Authorization': "Bearer ${Authentication().accessToken}",
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'status': record.$3,
      'score': (record.$2 * 10).round().toString(),
      'num_volumes_read': record.$5.isEmpty ? '0' : record.$5,
      'num_chapters_read': record.$4.isEmpty ? '0' : record.$4,
    },
  );
}
