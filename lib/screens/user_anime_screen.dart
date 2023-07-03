import 'package:animephilic/components/components_export.dart';
import 'package:animephilic/database/database_export.dart';
import 'package:animephilic/helpers/helpers_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAnimeListScreen extends StatefulWidget {
  const UserAnimeListScreen({super.key});

  @override
  State<UserAnimeListScreen> createState() => _UserAnimeListScreenState();
}

class _UserAnimeListScreenState extends State<UserAnimeListScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String animeStatus = "all";
  bool isGridView = false;

  void onTabChange(int value) {
    List<String> statusList = ['all', 'watching', 'plan_to_watch', 'completed', 'on_hold', 'dropped'];
    animeStatus = statusList[value];
    UserAnimeListBloc.instance.add(UserAnimeListEventLoadData(status: animeStatus));
  }

  @override
  void initState() {
    super.initState();
    if (UserAnimeListBloc.instance.state.userAnimeList == null) {
      UserAnimeListBloc.instance.add(const UserAnimeListEventLoadData());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              title: const Text("Anime List"),
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
                  onPressed: () => UserAnimeListBloc.instance.add(UserAnimeListEventFetchData()),
                  icon: const Icon(Icons.sync_rounded),
                ),
                IconButton(
                  onPressed: () {
                    sortDialog(context, animeStatus, true);
                  },
                  icon: const Icon(Icons.sort_rounded),
                ),
              ],
              bottom: TabBar(
                isScrollable: true,
                tabs: const [
                  Tab(text: "All anime"),
                  Tab(text: "Watching"),
                  Tab(text: "Plan to Watch"),
                  Tab(text: "Completed"),
                  Tab(text: "On Hold"),
                  Tab(text: "Dropped")
                ],
                onTap: onTabChange,
              ),
            ),
          ],
          body: BlocBuilder<UserAnimeListBloc, UserAnimeListState>(
            buildWhen: (previous, current) => previous.state != current.state,
            builder: (context, state) {
              if (state.userAnimeList == null || state.state == UserAnimeListDataState.fetching) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (state.userAnimeList!.isEmpty) {
                  return const Center(
                    child: Text("Nothing to see here"),
                  );
                }
                return Visibility(
                  visible: isGridView,
                  replacement: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.userAnimeList!.length,
                    itemBuilder: (context, index) {
                      UserAnimeListItem item = state.userAnimeList![index];
                      return VerticalListCard(
                        animeId: item.id,
                        mangaId: 000,
                        isForAnime: true,
                        title: item.title,
                        imageURL: item.largeImage,
                        status: UserAnimeListItem.parseStatus(item.status ?? ""),
                        stat1: "Episodes Watched: ${item.episodesWatched}",
                        stat2: "Your Rating: ${item.score}",
                      );
                    },
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: state.userAnimeList!.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.44,
                    ),
                    itemBuilder: (context, index) {
                      UserAnimeListItem item = state.userAnimeList![index];
                      return HorizontalListCard(
                        animeId: item.id,
                        mangaId: 000,
                        isForAnime: true,
                        title: item.title,
                        imageURL: item.largeImage,
                        info: [
                          (Icons.timelapse_rounded, UserAnimeListItem.parseStatus(item.status ?? 'N/A', short: true)),
                          (Icons.star_rounded, "${item.score}"),
                          (Icons.checklist_rtl_rounded, "${item.episodesWatched}"),
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
    );
  }
}
