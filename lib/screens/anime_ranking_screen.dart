import 'package:animephilic/database/database_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnimeRankingScreen extends StatefulWidget {
  const AnimeRankingScreen({super.key});

  @override
  State<AnimeRankingScreen> createState() => _AnimeRankingScreenState();
}

class _AnimeRankingScreenState extends State<AnimeRankingScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String rankingType = "all";
  ScrollController scrollController = ScrollController();

  void onTabChange(int value) {
    switch (value) {
      case 0:
        rankingType = "all";
        break;
      case 1:
        rankingType = "bypopularity";
        break;
      case 2:
        rankingType = "favorite";
        break;
      case 3:
        rankingType = "airing";
        break;
      case 4:
        rankingType = "upcoming";
        break;
      case 5:
        rankingType = "tv";
        break;
      case 6:
        rankingType = "ova";
        break;
      case 7:
        rankingType = "movie";
        break;
      case 8:
        rankingType = "special";
        break;
      default:
        rankingType = "all";
        break;
    }
    AnimeRankingBloc.instance
        .add(AnimeRankingEventFetchData(rankingType: rankingType));
  }

  @override
  void initState() {
    super.initState();
    if (AnimeRankingBloc.instance.state.animeRankingList == null) {
      AnimeRankingBloc.instance
          .add(AnimeRankingEventFetchData(rankingType: rankingType));
    }

    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        bool isTop = scrollController.position.pixels == 0;
        if (!isTop) {
          AnimeRankingBloc.instance
              .add(AnimeRankingEventFetchData(rankingType: rankingType));
          scrollController.jumpTo(scrollController.offset);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).scaffoldBackgroundColor,
          systemNavigationBarColor: ElevationOverlay.applySurfaceTint(
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surfaceTint,
            3,
          ),
          statusBarIconBrightness:
              MediaQuery.of(context).platformBrightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light,
          systemNavigationBarIconBrightness:
              MediaQuery.of(context).platformBrightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light,
        ),
        child: DefaultTabController(
          length: 9,
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  title: const Text("Anime Ranking"),
                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  actions: [
                    IconButton(
                      onPressed: () {
                        AnimeRankingBloc.instance.add(
                            AnimeRankingEventFetchData(
                                rankingType: rankingType));
                      },
                      icon: const Icon(Icons.sync_rounded),
                    ),
                  ],
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: const [
                      Tab(text: "All anime"),
                      Tab(text: "Popularity"),
                      Tab(text: "Favorite"),
                      Tab(text: "Airing"),
                      Tab(text: "Upcoming"),
                      Tab(text: "TV"),
                      Tab(text: "OVA"),
                      Tab(text: "Movie"),
                      Tab(text: "Special"),
                    ],
                    onTap: onTabChange,
                  ),
                ),
              ],
              body: BlocBuilder<AnimeRankingBloc, AnimeRankingState>(
                buildWhen: (previous, current) =>
                    previous.state != current.state,
                builder: (context, state) {
                  if (state.animeRankingList == null ||
                      state.state == AnimeRankingDataState.fetching) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (state.animeRankingList!.isEmpty) {
                      return const Center(
                        child: Text("Fetch data using 'sync' button"),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      controller: scrollController,
                      itemCount: state.animeRankingList!.length,
                      itemBuilder: (context, index) {
                        AnimeRankingItem item = state.animeRankingList![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 1),
                          child: SizedBox(
                            height: 160,
                            child: Card(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        item.largeImage!,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                          Text(
                                            UserAnimeListItem.parseStatus(
                                                item.status),
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          const Divider(thickness: 2),
                                          Text(
                                              "Mean Score: ${item.mean ?? 'N/A'}"),
                                          Text(
                                              "Popularity: ${item.popularity ?? 'N/A'}"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
