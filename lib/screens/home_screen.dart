import 'package:animephilic/components/components_export.dart';
import 'package:animephilic/database/database_export.dart';
import 'package:animephilic/helpers/helpers_exports.dart';
import 'package:animephilic/screens/anime_ranking_screen.dart';
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
                unselectedLabelColor: Theme.of(context).colorScheme.onBackground,
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
          body: SingleChildScrollView(
            child: Column(
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
                                  return HorizontalListCard(
                                    title: snapshot.data![index].title,
                                    imageURL: snapshot.data![index].largeImage,
                                    stat1: "${snapshot.data![index].mean ?? 'N/A'}",
                                  );
                                },
                              ),
                            );
                          }
                        }
                      },
                    ),
                    const ListTile(
                      leading: Icon(Icons.rss_feed_rounded),
                      title: Text("Recommendations"),
                    ),
                    FutureBuilder(
                      future: getRecommendedAnime(),
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
                                  return HorizontalListCard(
                                    title: snapshot.data![index].title,
                                    imageURL: snapshot.data![index].largeImage,
                                    stat1: "${snapshot.data![index].mean ?? 'N/A'}",
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
      ),
    );
  }
}
