import 'package:animephilic/database/database_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeasonalAnimeScreen extends StatefulWidget {
  const SeasonalAnimeScreen({super.key});

  @override
  State<SeasonalAnimeScreen> createState() => _SeasonalAnimeScreenState();
}

class _SeasonalAnimeScreenState extends State<SeasonalAnimeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  DateTime now = DateTime.now();
  String season = SeasonalAnimeItem.parseSeason(DateTime.now().month);
  List<String> seasons = ['winter', 'spring', 'summer', 'fall'];
  int seasonIterator = ['winter', 'spring', 'summer', 'fall']
      .indexOf(SeasonalAnimeItem.parseSeason(DateTime.now().month));

  void sortDialog(BuildContext context, int year, String season) async {
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
              return SingleChildScrollView(
                child: Column(
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
                      title: const Text("Mean score"),
                      subtitle: const Text("Sort based on average rating"),
                      value: 'mean',
                      groupValue: orderBy,
                      onChanged: (value) => setState(() => orderBy = value),
                    ),
                    RadioListTile(
                      title: const Text("Popularity"),
                      subtitle: const Text("Select ascending for most popular"),
                      value: 'popularity',
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
                ),
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
      SeasonalAnimeBloc.instance.add(SeasonalAnimeEventLoadData(
        year: year,
        season: season,
        orderBy: orderBy,
        order: order,
      ));
    });
  }

  void seasonChangeHandle(BuildContext context, int value) {
    if (value == 0) {
      showDialog<(bool, DateTime)>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          DateTime selected = now;
          return AlertDialog(
            title: const Text("Select Year"),
            content: StatefulBuilder(
              builder: (context, setState) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 3 / 4,
                  child: YearPicker(
                    firstDate: DateTime(1917),
                    lastDate: DateTime(DateTime.now().year + 1),
                    initialDate: DateTime.now(),
                    currentDate: DateTime.now(),
                    selectedDate: selected,
                    onChanged: (newDate) {
                      setState(() {
                        selected = newDate;
                      });
                    },
                  ),
                );
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, (true, selected)),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, (false, selected)),
                child: const Text('OK'),
              ),
            ],
          );
        },
      ).then((value) {
        var (isCancel, date) = value!;
        if (!isCancel) {
          setState(() {
            now = date;
          });
          SeasonalAnimeBloc.instance
              .add(SeasonalAnimeEventLoadData(year: now.year, season: season));
        }
      });
    } else {
      setState(() {
        seasonIterator++;
        seasonIterator %= 4;
        season = seasons[seasonIterator];
      });
      SeasonalAnimeBloc.instance
          .add(SeasonalAnimeEventLoadData(year: now.year, season: season));
    }
  }

  @override
  void initState() {
    super.initState();
    if (SeasonalAnimeBloc.instance.state.seasonalAnimeList == null) {
      SeasonalAnimeBloc.instance.add(SeasonalAnimeEventLoadData(
        year: DateTime.now().year,
        season: SeasonalAnimeItem.parseSeason(DateTime.now().month),
      ));
    }
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
                        SeasonalAnimeBloc.instance
                            .add(SeasonalAnimeEventFetchData(
                          year: now.year,
                          season: season,
                        ));
                      },
                      icon: const Icon(Icons.sync_rounded),
                    ),
                    IconButton(
                      onPressed: () {
                        sortDialog(context, now.year, season);
                      },
                      icon: const Icon(Icons.sort_rounded),
                    ),
                  ],
                  bottom: TabBar(
                    indicatorColor: Colors.transparent,
                    labelColor: Theme.of(context).colorScheme.onBackground,
                    unselectedLabelColor:
                        Theme.of(context).colorScheme.onBackground,
                    tabs: [
                      Tab(text: now.year.toString()),
                      Tab(text: season),
                    ],
                    onTap: (value) {
                      seasonChangeHandle(context, value);
                    },
                  ),
                ),
              ],
              body: BlocBuilder<SeasonalAnimeBloc, SeasonalAnimeState>(
                buildWhen: (previous, current) =>
                    previous.state != current.state,
                builder: (context, state) {
                  if (state.seasonalAnimeList == null ||
                      state.state == SeasonalAnimeDataState.fetching) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (state.seasonalAnimeList!.isEmpty) {
                      return const Center(
                        child: Text(
                            "1. Please select year and season\n2. Press the 'Sync' button to load data"),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.seasonalAnimeList!.length,
                      itemBuilder: (context, index) {
                        SeasonalAnimeItem item =
                            state.seasonalAnimeList![index];
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
                                            SeasonalAnimeItem.parseStatus(
                                                item.status),
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          const Divider(thickness: 2),
                                          Text(
                                              "Mean score: ${item.mean ?? 'N/A'}"),
                                          Text(
                                              "Popularity: ${item.popularity}"),
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
