import 'dart:convert';

import 'package:animephilic/authentication/authenticaton_exports.dart';
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
                  initialDate: DateTime.now(),
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
