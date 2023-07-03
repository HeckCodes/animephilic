import 'package:animephilic/components/components_export.dart';
import 'package:animephilic/database/database_export.dart';
import 'package:animephilic/helpers/helpers_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnimeRankingScreen extends StatefulWidget {
  const AnimeRankingScreen({super.key});

  @override
  State<AnimeRankingScreen> createState() => _AnimeRankingScreenState();
}

class _AnimeRankingScreenState extends State<AnimeRankingScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool isGridView = false;
  String rankingType = "all";
  ScrollController scrollController = ScrollController();

  void onTabChange(int value) {
    List<String> rankingTypeList = [
      'all',
      'bypopularity',
      'favorite',
      'airing',
      'upcoming',
      'tv',
      'ova',
      'movie',
      'special'
    ];
    rankingType = rankingTypeList[value];
    AnimeRankingBloc.instance.add(AnimeRankingEventFetchData(rankingType: rankingType));
  }

  @override
  void initState() {
    super.initState();
    if (AnimeRankingBloc.instance.state.animeRankingList == null) {
      AnimeRankingBloc.instance.add(AnimeRankingEventFetchData(rankingType: rankingType));
    }

    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        bool isTop = scrollController.position.pixels == 0;
        if (!isTop) {
          AnimeRankingBloc.instance.add(AnimeRankingEventFetchNextData(
            nextUrl: AnimeRankingBloc.instance.state.nextUrl,
            animeRankingList: AnimeRankingBloc.instance.state.animeRankingList,
            rankingType: rankingType,
          ));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'More data loaded.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              backgroundColor: Theme.of(context).cardColor,
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: AnnotatedRegion(
        value: getOverlayStyle(context),
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
                        setState(() {
                          isGridView = !isGridView;
                        });
                      },
                      icon: Icon(!isGridView ? Icons.grid_view_rounded : Icons.view_list_rounded),
                    ),
                    IconButton(
                      onPressed: () {
                        AnimeRankingBloc.instance.add(AnimeRankingEventFetchData(rankingType: rankingType));
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
                    previous.state != current.state ||
                    previous.animeRankingList?.length != current.animeRankingList?.length,
                builder: (context, state) {
                  if (state.animeRankingList == null || state.state == AnimeRankingDataState.fetching) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (state.animeRankingList!.isEmpty) {
                      return const Center(
                        child: Text("Fetch data using 'sync' button"),
                      );
                    }
                    return Visibility(
                      visible: isGridView,
                      replacement: ListView.builder(
                        shrinkWrap: true,
                        controller: scrollController,
                        itemCount: state.animeRankingList!.length,
                        itemBuilder: (context, index) {
                          AnimeRankingItem item = state.animeRankingList![index];
                          return VerticalListCard(
                            animeId: item.id,
                            isForAnime: true,
                            mangaId: 000,
                            title: item.title,
                            imageURL: item.largeImage,
                            status: AnimeRankingItem.parseStatus(item.status),
                            stat1: "Mean score: ${item.mean ?? 'N/A'}",
                            stat2: "Popularity: ${item.popularity ?? 'N/A'}",
                          );
                        },
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        controller: scrollController,
                        physics: const ScrollPhysics(),
                        itemCount: state.animeRankingList!.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.42,
                        ),
                        itemBuilder: (context, index) {
                          AnimeRankingItem item = state.animeRankingList![index];
                          return HorizontalListCard(
                            animeId: item.id,
                            mangaId: 000,
                            isForAnime: true,
                            title: item.title,
                            imageURL: item.largeImage,
                            info: [
                              (Icons.timelapse_rounded, AnimeRankingItem.parseStatus(item.status, short: true)),
                              (Icons.star_rounded, "${item.mean ?? 'N/A'}"),
                              (Icons.people_alt_rounded, "${item.numberListUsers}"),
                              (Icons.celebration_rounded, "${item.popularity}"),
                            ],
                          );
                        },
                      ),
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
