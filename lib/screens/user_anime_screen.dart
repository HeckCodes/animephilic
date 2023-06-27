import 'package:animephilic/database/database_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAnimeListScreen extends StatefulWidget {
  const UserAnimeListScreen({super.key});

  @override
  State<UserAnimeListScreen> createState() => _UserAnimeListScreenState();
}

class _UserAnimeListScreenState extends State<UserAnimeListScreen> {
  @override
  void initState() {
    super.initState();
    if (UserAnimeListBloc.instance.state.userAnimeList == null) {
      UserAnimeListBloc.instance.add(UserAnimeListEventLoadData());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Anime List")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          UserAnimeListBloc.instance.add(UserAnimeListEventFetchData());
        },
        icon: const Icon(Icons.sync_rounded),
        label: const Text("Sync"),
      ),
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
            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.userAnimeList!.length,
              itemBuilder: (context, index) {
                UserAnimeListItem item = state.userAnimeList![index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  child: SizedBox(
                    height: 160,
                    child: Card(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(item.largeImage!),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    UserAnimeListItem.parseStatus(item.status!),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const Divider(),
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
    );
  }
}
