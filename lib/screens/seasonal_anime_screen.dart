import 'package:animephilic/components/components_export.dart';
import 'package:animephilic/database/database_export.dart';
import 'package:animephilic/helpers/helpers_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeasonalAnimeScreen extends StatefulWidget {
  const SeasonalAnimeScreen({super.key});

  @override
  State<SeasonalAnimeScreen> createState() => _SeasonalAnimeScreenState();
}

class _SeasonalAnimeScreenState extends State<SeasonalAnimeScreen> {
  DateTime now = DateTime.now();
  String season = SeasonalAnimeItem.parseSeason(DateTime.now().month);
  List<String> seasons = ['winter', 'spring', 'summer', 'fall'];
  int seasonIterator =
      ['winter', 'spring', 'summer', 'fall'].indexOf(SeasonalAnimeItem.parseSeason(DateTime.now().month));

  void setNow(DateTime date) {
    setState(() {
      now = date;
    });
  }

  void setSeason() {
    setState(() {
      seasonIterator++;
      seasonIterator %= 4;
      season = seasons[seasonIterator];
    });
  }

  @override
  void initState() {
    super.initState();
    SeasonalAnimeBloc.instance.add(SeasonalAnimeEventLoadData(
      year: DateTime.now().year,
      season: SeasonalAnimeItem.parseSeason(DateTime.now().month),
    ));
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
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  title: const Text("Seasonal Anime"),
                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  actions: [
                    IconButton(
                      onPressed: () {
                        SeasonalAnimeBloc.instance.add(SeasonalAnimeEventFetchData(
                          year: now.year,
                          season: season,
                        ));
                      },
                      icon: const Icon(Icons.sync_rounded),
                    ),
                    IconButton(
                      onPressed: () {
                        seasonalSortDialog(context, now.year, season);
                      },
                      icon: const Icon(Icons.sort_rounded),
                    ),
                  ],
                  bottom: TabBar(
                    indicatorColor: Colors.transparent,
                    labelColor: Theme.of(context).colorScheme.onBackground,
                    unselectedLabelColor: Theme.of(context).colorScheme.onBackground,
                    tabs: [
                      Tab(text: now.year.toString()),
                      Tab(text: season),
                    ],
                    onTap: (value) {
                      seasonChangeHandle(
                        context,
                        value,
                        now,
                        setNow,
                        setSeason,
                        season,
                        seasonIterator,
                      );
                    },
                  ),
                ),
              ],
              body: BlocBuilder<SeasonalAnimeBloc, SeasonalAnimeState>(
                buildWhen: (previous, current) => previous.state != current.state,
                builder: (context, state) {
                  if (state.seasonalAnimeList == null || state.state == SeasonalAnimeDataState.fetching) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (state.seasonalAnimeList!.isEmpty) {
                      return const Center(
                        child: Text("1. Please select year and season\n2. Press the 'Sync' button to load data"),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.seasonalAnimeList!.length,
                      itemBuilder: (context, index) {
                        SeasonalAnimeItem item = state.seasonalAnimeList![index];
                        return VerticalListCard(
                          title: item.title,
                          imageURL: item.largeImage,
                          status: SeasonalAnimeItem.parseStatus(item.status),
                          stat1: "Mean score: ${item.mean ?? 'N/A'}",
                          stat2: "Popularity: ${item.popularity ?? 'N/A'}",
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
