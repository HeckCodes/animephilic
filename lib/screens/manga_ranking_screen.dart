import 'package:animephilic/components/components_export.dart';
import 'package:animephilic/database/database_export.dart';
import 'package:animephilic/helpers/helpers_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MangaRankingScreen extends StatefulWidget {
  const MangaRankingScreen({super.key});

  @override
  State<MangaRankingScreen> createState() => _MangaRankingScreenState();
}

class _MangaRankingScreenState extends State<MangaRankingScreen> with AutomaticKeepAliveClientMixin {
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
      'manga',
      'novels',
      'oneshots',
      'doujin',
      'manhwa',
      'manhua'
    ];
    rankingType = rankingTypeList[value];
    MangaRankingBloc.instance.add(MangaRankingEventFetchData(rankingType: rankingType));
  }

  @override
  void initState() {
    super.initState();
    if (MangaRankingBloc.instance.state.mangaRankingList == null) {
      MangaRankingBloc.instance.add(MangaRankingEventFetchData(rankingType: rankingType));
    }

    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        bool isTop = scrollController.position.pixels == 0;
        if (!isTop) {
          MangaRankingBloc.instance.add(MangaRankingEventFetchNextData(
            nextUrl: MangaRankingBloc.instance.state.nextUrl,
            mangaRankingList: MangaRankingBloc.instance.state.mangaRankingList,
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
                  title: const Text("Manga Ranking"),
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
                        MangaRankingBloc.instance.add(MangaRankingEventFetchData(rankingType: rankingType));
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
                      Tab(text: "Manga"),
                      Tab(text: "Novels"),
                      Tab(text: "One Shots"),
                      Tab(text: "Doujin"),
                      Tab(text: "Manhwa"),
                      Tab(text: "Manhua"),
                    ],
                    onTap: onTabChange,
                  ),
                ),
              ],
              body: BlocBuilder<MangaRankingBloc, MangaRankingState>(
                buildWhen: (previous, current) =>
                    previous.state != current.state ||
                    previous.mangaRankingList?.length != current.mangaRankingList?.length,
                builder: (context, state) {
                  if (state.mangaRankingList == null || state.state == MangaRankingDataState.fetching) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (state.mangaRankingList!.isEmpty) {
                      return const Center(
                        child: Text("Fetch data using 'sync' button"),
                      );
                    }
                    return Visibility(
                      visible: isGridView,
                      replacement: ListView.builder(
                        shrinkWrap: true,
                        controller: scrollController,
                        itemCount: state.mangaRankingList!.length,
                        itemBuilder: (context, index) {
                          MangaRankingItem item = state.mangaRankingList![index];
                          return VerticalListCard(
                            animeId: 000,
                            isForAnime: false,
                            mangaId: item.id,
                            title: item.title,
                            imageURL: item.largeImage,
                            status: MangaRankingItem.parseStatus(item.status),
                            stat1: "Mean score: ${item.mean ?? 'N/A'}",
                            stat2: "Popularity: ${item.popularity ?? 'N/A'}",
                          );
                        },
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        controller: scrollController,
                        physics: const ScrollPhysics(),
                        itemCount: state.mangaRankingList!.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.42,
                        ),
                        itemBuilder: (context, index) {
                          MangaRankingItem item = state.mangaRankingList![index];
                          return HorizontalListCard(
                            animeId: 000,
                            mangaId: item.id,
                            isForAnime: false,
                            title: item.title,
                            imageURL: item.largeImage,
                            info: [
                              (Icons.timelapse_rounded, MangaRankingItem.parseStatus(item.status, short: true)),
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
