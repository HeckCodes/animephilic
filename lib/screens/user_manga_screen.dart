import 'package:flutter/material.dart';

class UserMangaListScreen extends StatefulWidget {
  const UserMangaListScreen({super.key});

  @override
  State<UserMangaListScreen> createState() => _UserMangaListScreenState();
}

class _UserMangaListScreenState extends State<UserMangaListScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
                  onPressed: () {},
                  icon: const Icon(Icons.sort_rounded),
                ),
              ],
              bottom: TabBar(
                isScrollable: true,
                tabs: const [
                  Tab(text: "All manga"),
                  Tab(text: "Watching"),
                  Tab(text: "Plan to Watch"),
                  Tab(text: "Completed"),
                  Tab(text: "On Hold"),
                  Tab(text: "Dropped")
                ],
                onTap: (value) {},
              ),
            ),
          ],
          body: const Center(child: Text("Under Development")),
        ),
      ),
    );
  }
}
