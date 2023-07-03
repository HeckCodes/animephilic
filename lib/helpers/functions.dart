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
  // http.Response response = await http.get(
  //   Uri.parse('https://api.myanimelist.net/v2/anime/$id?fields=${AnimeFieldOptions().animeFull}'),
  //   headers: {'Authorization': "Bearer ${Authentication().accessToken}"},
  // );

  return AnimeDetails.fromMap(jsonDecode(jsonEncode({
    "id": 123,
    "title": "Fushigi Yuugi",
    "main_picture": {
      "medium": "https:\/\/cdn.myanimelist.net\/images\/anime\/2\/20140.jpg",
      "large": "https:\/\/cdn.myanimelist.net\/images\/anime\/2\/20140l.jpg"
    },
    "alternative_titles": {
      "synonyms": ["Fushigi Yugi", "Curious Play"],
      "en": "Mysterious Play",
      "ja": "\u3075\u3057\u304e\u904a\u622f"
    },
    "start_date": "1995-04-06",
    "end_date": "1996-03-28",
    "synopsis":
        "During a visit to the National Library, Miaka Yuuki and Yui Hongo stumble upon a strange old book that casts a red light, sucking them inside its unfamiliar world. Upon arrival, the two encounter hostile slave traders and barely escape with the help of Tamahome\u2014a powerful young man bearing a Chinese symbol on his forehead. But, a moment later, the red light returns and takes Yui away. \n\nDesperate to reunite with her companion, Miaka asks Tamahome for assistance. However, the situation escalates when the pair encounters the land's emperor, Hotohori, who believes Miaka is the foretold priestess of the kingdom's protector god Suzaku. By gathering the god's seven Celestial Warriors, the priestess can summon Suzaku and have all her wishes granted. Hotohori hopes this will save his country, and since it appears to be a fitting solution to the girl's problems as well, he convinces her to accept the role.\n\nMeanwhile, at the library, Yui realizes she has been brought back alone. Unable to intervene, she helplessly witnesses Miaka traversing through courageous trials as the mysterious book's heroine.\n\n[Written by MAL Rewrite]",
    "mean": 7.61,
    "rank": 1361,
    "popularity": 1752,
    "num_list_users": 116072,
    "num_scoring_users": 51081,
    "nsfw": "white",
    "genres": [
      {"id": 2, "name": "Adventure"},
      {"id": 10, "name": "Fantasy"},
      {"id": 13, "name": "Historical"},
      {"id": 62, "name": "Isekai"},
      {"id": 17, "name": "Martial Arts"},
      {"id": 73, "name": "Reverse Harem"},
      {"id": 22, "name": "Romance"},
      {"id": 25, "name": "Shoujo"}
    ],
    "created_at": "2005-11-11T14:36:58+00:00",
    "updated_at": "2023-01-06T08:35:15+00:00",
    "media_type": "tv",
    "status": "finished_airing",
    "num_episodes": 52,
    "start_season": {"year": 1995, "season": "spring"},
    "broadcast": {"day_of_the_week": "thursday", "start_time": "18:00"},
    "source": "manga",
    "average_episode_duration": 1410,
    "rating": "pg_13",
    "studios": [
      {"id": 1, "name": "Pierrot"}
    ],
    "pictures": [],
    "background":
        "Despite presenting some disturbing imagery, Fushigi Yuugi was broadcasted at 6 p.m. during its airing in Japan, a timeslot that now no longer permits such content. \n\nThe series' English version was made available in DVD and VHS formats by Geneon Entertainment, formerly known as Pioneer, under the expanded title Fushigi Yuugi: The Mysterious Play. The DVDs were released as eight volumes between July 27, 2004 and September 20, 2005. It was also released as two box sets: Suzaku on November 30, 1999 and Seiryuu on December 12, 2000.\n\nSeven years later, Media Blasters released another two DVD box sets and a collection with the entire series using the original title. The sets, Fushigi Yuugi Season 1 and Season 2, were released on June 19, 2012 and February 12, 2013 respectively. The collection was made available on April 28, 2015.\n",
    "related_anime": [
      {
        "node": {
          "id": 380,
          "title": "Fushigi Yuugi OVA",
          "main_picture": {
            "medium": "https:\/\/cdn.myanimelist.net\/images\/anime\/1171\/92443.jpg",
            "large": "https:\/\/cdn.myanimelist.net\/images\/anime\/1171\/92443l.jpg"
          }
        },
        "relation_type": "sequel",
        "relation_type_formatted": "Sequel"
      }
    ],
    "related_manga": [],
    "recommendations": [
      {
        "node": {
          "id": 249,
          "title": "InuYasha",
          "main_picture": {
            "medium": "https:\/\/cdn.myanimelist.net\/images\/anime\/1589\/95329.jpg",
            "large": "https:\/\/cdn.myanimelist.net\/images\/anime\/1589\/95329l.jpg"
          }
        },
        "num_recommendations": 18
      },
      {
        "node": {
          "id": 25013,
          "title": "Akatsuki no Yona",
          "main_picture": {
            "medium": "https:\/\/cdn.myanimelist.net\/images\/anime\/9\/64225.jpg",
            "large": "https:\/\/cdn.myanimelist.net\/images\/anime\/9\/64225l.jpg"
          }
        },
        "num_recommendations": 15
      },
      {
        "node": {
          "id": 247,
          "title": "Harukanaru Toki no Naka de: Hachiyou Shou",
          "main_picture": {
            "medium": "https:\/\/cdn.myanimelist.net\/images\/anime\/7\/7227.jpg",
            "large": "https:\/\/cdn.myanimelist.net\/images\/anime\/7\/7227l.jpg"
          }
        },
        "num_recommendations": 13
      },
      {
        "node": {
          "id": 957,
          "title": "Saiunkoku Monogatari",
          "main_picture": {
            "medium": "https:\/\/cdn.myanimelist.net\/images\/anime\/1\/957.jpg",
            "large": "https:\/\/cdn.myanimelist.net\/images\/anime\/1\/957l.jpg"
          }
        },
        "num_recommendations": 11
      },
      {
        "node": {
          "id": 104,
          "title": "Ayashi no Ceres",
          "main_picture": {
            "medium": "https:\/\/cdn.myanimelist.net\/images\/anime\/1928\/106202.jpg",
            "large": "https:\/\/cdn.myanimelist.net\/images\/anime\/1928\/106202l.jpg"
          }
        },
        "num_recommendations": 11
      },
      {
        "node": {
          "id": 153,
          "title": "Juuni Kokuki",
          "main_picture": {
            "medium": "https:\/\/cdn.myanimelist.net\/images\/anime\/6\/50859.jpg",
            "large": "https:\/\/cdn.myanimelist.net\/images\/anime\/6\/50859l.jpg"
          }
        },
        "num_recommendations": 8
      },
      {
        "node": {
          "id": 182,
          "title": "Tenkuu no Escaflowne",
          "main_picture": {
            "medium": "https:\/\/cdn.myanimelist.net\/images\/anime\/5\/30689.jpg",
            "large": "https:\/\/cdn.myanimelist.net\/images\/anime\/5\/30689l.jpg"
          }
        },
        "num_recommendations": 7
      },
      {
        "node": {
          "id": 100,
          "title": "Shin Shirayuki-hime Densetsu Pr\u00e9tear",
          "main_picture": {
            "medium": "https:\/\/cdn.myanimelist.net\/images\/anime\/9\/11709.jpg",
            "large": "https:\/\/cdn.myanimelist.net\/images\/anime\/9\/11709l.jpg"
          }
        },
        "num_recommendations": 5
      },
      {
        "node": {
          "id": 12461,
          "title": "Hiiro no Kakera",
          "main_picture": {
            "medium": "https:\/\/cdn.myanimelist.net\/images\/anime\/3\/36925.jpg",
            "large": "https:\/\/cdn.myanimelist.net\/images\/anime\/3\/36925l.jpg"
          }
        },
        "num_recommendations": 4
      },
      {
        "node": {
          "id": 5835,
          "title": "Hanasakeru Seishounen",
          "main_picture": {
            "medium": "https:\/\/cdn.myanimelist.net\/images\/anime\/1094\/116584.jpg",
            "large": "https:\/\/cdn.myanimelist.net\/images\/anime\/1094\/116584l.jpg"
          }
        },
        "num_recommendations": 3
      }
    ],
    "statistics": {
      "status": {
        "watching": "6423",
        "completed": "61768",
        "on_hold": "6365",
        "dropped": "6857",
        "plan_to_watch": "34656"
      },
      "num_list_users": 116069
    },
    "opening_themes": [
      {"id": 1060, "anime_id": 123, "text": "\"Itooshii Hito no Tame ni; For My Darling\" by Akemi Satou"}
    ],
    "ending_themes": [
      {"id": 1061, "anime_id": 123, "text": "#1: \"Tokimeki no Doukasen\" by Yukari Konno (eps 1-32,34-51)"},
      {"id": 1062, "anime_id": 123, "text": "#2: \"Kaze no Uta\" by Chika Sakamoto (ep 33)"},
      {"id": 1063, "anime_id": 123, "text": "#3: \"For Epilogue\u2026\" by Yukari Konno & Akemi Satou (ep 52)"}
    ]
  })));
}
