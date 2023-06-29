import 'package:animephilic/database/database_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAnimeListScreen extends StatefulWidget {
  const UserAnimeListScreen({super.key});

  @override
  State<UserAnimeListScreen> createState() => _UserAnimeListScreenState();
}

class _UserAnimeListScreenState extends State<UserAnimeListScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String animeStatus = "all";

  void onTabChange(int value) {
    switch (value) {
      case 0:
        animeStatus = "all";
        break;
      case 1:
        animeStatus = "watching";
        break;
      case 2:
        animeStatus = "plan_to_watch";
        break;
      case 3:
        animeStatus = "completed";
        break;
      case 4:
        animeStatus = "on_hold";
        break;
      case 5:
        animeStatus = "dropped";
        break;
      default:
        animeStatus = "all";
        break;
    }
    UserAnimeListBloc.instance
        .add(UserAnimeListEventLoadData(status: animeStatus));
  }

  void sortDialog(BuildContext context, String animeStatus) async {
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
      UserAnimeListBloc.instance.add(UserAnimeListEventLoadData(
        status: animeStatus,
        orderBy: orderBy,
        order: order,
      ));
    });
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
                    UserAnimeListBloc.instance
                        .add(UserAnimeListEventFetchData());
                  },
                  icon: const Icon(Icons.sync_rounded),
                ),
                IconButton(
                  onPressed: () {
                    sortDialog(context, animeStatus);
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
              if (state.userAnimeList == null ||
                  state.state == UserAnimeListDataState.fetching) {
                return const Center(
                    child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ));
              } else {
                if (state.userAnimeList!.isEmpty) {
                  return const Center(
                    child: Text("Nothing to see here"),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.userAnimeList!.length,
                  itemBuilder: (context, index) {
                    UserAnimeListItem item = state.userAnimeList![index];
                    if (state.userAnimeList!.isEmpty) {
                      return const Center(
                        child: Text("Empty List"),
                      );
                    }
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
                                    item.mediumImage!,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        UserAnimeListItem.parseStatus(
                                            item.status!),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const Divider(thickness: 2),
                                      Text(
                                          "Episodes Watched: ${item.episodesWatched}"),
                                      Text("Your Rating: ${item.score}"),
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
    );
  }
}
