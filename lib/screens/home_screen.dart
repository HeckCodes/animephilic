import 'package:animephilic/components/components_export.dart';
import 'package:animephilic/database/database_export.dart';
import 'package:animephilic/helpers/helpers_exports.dart';
import 'package:animephilic/screens/anime_ranking_screen.dart';
import 'package:animephilic/screens/manga_ranking_screen.dart';
import 'package:animephilic/screens/search_screen.dart';
import 'package:animephilic/screens/seasonal_anime_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late final Future<List<SeasonalAnimeItem>> seasonalAnimeFuture;
  late final Future<List<RecommendedAnimeItem>> recommendedAnimeFuture;
  @override
  void initState() {
    super.initState();
    seasonalAnimeFuture = getSeasonalAnime(DateTime.now().year, SeasonalAnimeItem.parseSeason(DateTime.now().month));
    recommendedAnimeFuture = getRecommendedAnime();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder:
              (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  title: const Text("Animephilic"),
                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
                      },
                      icon: const Icon(Icons.search_rounded),
                    ),
                  ],
                  bottom: TabBar(
                    tabAlignment: TabAlignment.fill,
                    indicatorColor: Colors.transparent,
                    labelColor: Theme.of(context).colorScheme.onSurface,
                    unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
                    tabs: const [Tab(text: "Seasonal Anime"), Tab(text: "Anime Ranking"), Tab(text: "Manga Ranking")],
                    onTap: (value) {
                      if (value == 0) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SeasonalAnimeScreen()));
                      } else if (value == 1) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AnimeRankingScreen()));
                      } else if (value == 2) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MangaRankingScreen()));
                      }
                    },
                  ),
                ),
              ],
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.spa_rounded),
                      title: const Text("This Season"),
                      trailing: const Icon(Icons.arrow_right_rounded, size: 46),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SeasonalAnimeScreen()));
                      },
                      splashColor: Colors.transparent,
                    ),
                    FutureBuilder(
                      future: seasonalAnimeFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        } else if (snapshot.hasData) {
                          return SizedBox(
                            height: 270,
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return HorizontalListCard(
                                  animeId: snapshot.data![index].id,
                                  mangaId: 000,
                                  isForAnime: true,
                                  title: snapshot.data![index].title,
                                  imageURL: snapshot.data![index].largeImage,
                                  info: [
                                    (Icons.star_rounded, "${snapshot.data![index].mean ?? 'N/A'}"),
                                    (Icons.celebration_rounded, "${snapshot.data![index].popularity ?? 'N/A'}"),
                                  ],
                                );
                              },
                            ),
                          );
                        } else {
                          return const Center(child: Text('Something went extremely wrong!'));
                        }
                      },
                    ),
                    const ListTile(leading: Icon(Icons.rss_feed_rounded), title: Text("Recommendations")),
                    FutureBuilder(
                      future: recommendedAnimeFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        } else if (snapshot.hasData) {
                          return SizedBox(
                            height: 270,
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return HorizontalListCard(
                                  animeId: snapshot.data![index].id,
                                  mangaId: 000,
                                  isForAnime: true,
                                  title: snapshot.data![index].title,
                                  imageURL: snapshot.data![index].largeImage,
                                  info: [(Icons.star_rounded, "${snapshot.data![index].mean ?? 'N/A'}")],
                                );
                              },
                            ),
                          );
                        } else {
                          return const Center(child: Text('Something went extremely wrong!'));
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
