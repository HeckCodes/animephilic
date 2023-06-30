import 'dart:convert';

import 'package:animephilic/authentication/authenticaton_exports.dart';
import 'package:animephilic/database/database_export.dart';
import 'package:animephilic/screens/anime_ranking_screen.dart';
import 'package:animephilic/screens/seasonal_anime_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  Future<List<SeasonalAnimeItem>> getSeasonalAnime(
      int year, String season) async {
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              title: const Text("Animephilic"),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: Colors.transparent,
                labelColor: Theme.of(context).colorScheme.onBackground,
                unselectedLabelColor:
                    Theme.of(context).colorScheme.onBackground,
                tabs: const [
                  Tab(text: "Seasonal Anime"),
                  Tab(text: "Search"),
                  Tab(text: "Anime Ranking"),
                  Tab(text: "Manga Ranking"),
                ],
                onTap: (value) {
                  if (value == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SeasonalAnimeScreen(),
                      ),
                    );
                  } else if (value == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AnimeRankingScreen(),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ListTile(
                    leading: const Icon(Icons.spa_rounded),
                    title: const Text("This Season"),
                    trailing: const Icon(Icons.arrow_right_rounded, size: 46),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SeasonalAnimeScreen(),
                        ),
                      );
                    },
                    splashColor: Colors.transparent,
                  ),
                  FutureBuilder(
                    future: getSeasonalAnime(
                      DateTime.now().year,
                      SeasonalAnimeItem.parseSeason(DateTime.now().month),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        } else {
                          return SizedBox(
                            height: 260,
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 130,
                                  child: Card(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8, left: 8, right: 8),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              snapshot.data![index].largeImage!,
                                              height: 180,
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8, left: 8),
                                          child: Text(
                                            snapshot.data![index].title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.star_rounded,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                "${snapshot.data![index].mean ?? 'N/A'}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
