import 'package:animephilic/helpers/helpers_exports.dart';
import 'package:animephilic/screens/anime_details_screen.dart';
import 'package:animephilic/screens/manga_details_screen.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController textEditingController = TextEditingController();
  String searchFor = "anime";
  bool shouldGet = false;

  late Future getSearchFuture;

  @override
  void initState() {
    super.initState();
    getSearchFuture = getSearch(searchFor, textEditingController.text.trim(), shouldGet);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnnotatedRegion(
        value: getOverlayStyle(context),
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder:
                  (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      title: const Text("Search"),
                      pinned: true,
                      floating: true,
                      forceElevated: innerBoxIsScrolled,
                      bottom: TabBar(
                        tabs: const [Tab(text: "Anime"), Tab(text: "Manga")],
                        onTap: (value) {
                          setState(() {
                            if (value == 0) {
                              setState(() {
                                searchFor = "anime";
                                shouldGet = false;
                                getSearchFuture = getSearch(searchFor, textEditingController.text.trim(), shouldGet);
                              });
                            } else {
                              setState(() {
                                searchFor = "manga";
                                shouldGet = false;
                                getSearchFuture = getSearch(searchFor, textEditingController.text.trim(), shouldGet);
                              });
                            }
                          });
                        },
                      ),
                    ),
                  ],
              body: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            controller: textEditingController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              label: Text(searchFor == 'anime' ? 'Anime Title' : 'Manga Title'),
                              isDense: true,
                              helperText: "Enter 3 or more characters",
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, right: 16, bottom: 16),
                        child: IconButton(
                          onPressed: () {
                            if (textEditingController.text.trim().length >= 3) {
                              setState(() {
                                shouldGet = true;
                                getSearchFuture = getSearch(searchFor, textEditingController.text.trim(), shouldGet);
                              });
                            }
                          },
                          icon: const Icon(Icons.search_rounded),
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder(
                    future: getSearchFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      } else if (snapshot.hasData) {
                        if (snapshot.data!.length == 0) {
                          return const Center(child: Text("Search for Anime/Manga"));
                        }
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: snapshot.data!['data'].length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.6,
                          ),
                          itemBuilder: (context, index) {
                            var item = snapshot.data!['data'][index]['node'];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              child: Card(
                                child: InkWell(
                                  onTap: () {
                                    if (searchFor == 'anime') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AnimeDetailsScreen(animeId: item['id']),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MangaDetailsScreen(mangaId: item['id']),
                                        ),
                                      );
                                    }
                                  },
                                  splashColor: Theme.of(context).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.network(
                                            item['main_picture']['large'] ?? "",
                                            height: 230,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Image.asset(
                                                'assets/images/avatar.png',
                                                height: 230,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          item['title'],
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(child: Text("Something went extremely wrong"));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
