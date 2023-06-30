import 'package:animephilic/screens/anime_ranking_screen.dart';
import 'package:animephilic/screens/seasonal_anime_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              title: const Text("Seasonal Anime"),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.sync_rounded),
                ),
              ],
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
          body: const Column(),
        ),
      ),
    );
  }
}
