import 'package:animephilic/components/components_export.dart';
import 'package:animephilic/database/database_export.dart';
import 'package:animephilic/helpers/helpers_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserMangaListScreen extends StatefulWidget {
  const UserMangaListScreen({super.key});

  @override
  State<UserMangaListScreen> createState() => _UserMangaListScreenState();
}

class _UserMangaListScreenState extends State<UserMangaListScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String mangaStatus = "all";
  bool isGridView = false;

  void onTabChange(int value) {
    List<String> statusList = ['all', 'reading', 'plan_to_read', 'completed', 'on_hold', 'dropped'];
    mangaStatus = statusList[value];
    UserMangaListBloc.instance.add(UserMangaListEventLoadData(status: mangaStatus));
  }

  @override
  void initState() {
    super.initState();
    if (UserMangaListBloc.instance.state.userMangaList == null) {
      UserMangaListBloc.instance.add(const UserMangaListEventLoadData());
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
              title: const Text("Manga List"),
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
                  onPressed: () => UserMangaListBloc.instance.add(UserMangaListEventFetchData()),
                  icon: const Icon(Icons.sync_rounded),
                ),
                IconButton(
                  onPressed: () {
                    sortDialog(context, mangaStatus, false);
                  },
                  icon: const Icon(Icons.sort_rounded),
                ),
              ],
              bottom: TabBar(
                isScrollable: true,
                tabs: const [
                  Tab(text: "All manga"),
                  Tab(text: "Reading"),
                  Tab(text: "Plan to Read"),
                  Tab(text: "Completed"),
                  Tab(text: "On Hold"),
                  Tab(text: "Dropped")
                ],
                onTap: onTabChange,
              ),
            ),
          ],
          body: BlocBuilder<UserMangaListBloc, UserMangaListState>(
            buildWhen: (previous, current) => previous.state != current.state,
            builder: (context, state) {
              if (state.userMangaList == null || state.state == UserMangaListDataState.fetching) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (state.userMangaList!.isEmpty) {
                  return const Center(
                    child: Text("Nothing to see here"),
                  );
                }
                return Visibility(
                  visible: isGridView,
                  replacement: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.userMangaList!.length,
                    itemBuilder: (context, index) {
                      UserMangaListItem item = state.userMangaList![index];
                      return VerticalListCard(
                        animeId: 000,
                        mangaId: 000,
                        isForAnime: false,
                        title: item.title,
                        imageURL: item.largeImage,
                        status: UserMangaListItem.parseStatus(item.status ?? ""),
                        stat1: "Chapters Read: ${item.chaptersRead}",
                        stat2: "Your Rating: ${item.score}",
                      );
                    },
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: state.userMangaList!.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.44,
                    ),
                    itemBuilder: (context, index) {
                      UserMangaListItem item = state.userMangaList![index];
                      return HorizontalListCard(
                        title: item.title,
                        imageURL: item.largeImage,
                        animeId: 000,
                        mangaId: 000,
                        isForAnime: false,
                        info: [
                          (Icons.timelapse_rounded, UserMangaListItem.parseStatus(item.status ?? 'N/A', short: true)),
                          (Icons.star_rounded, "${item.score}"),
                          (Icons.checklist_rtl_rounded, "${item.chaptersRead}"),
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
