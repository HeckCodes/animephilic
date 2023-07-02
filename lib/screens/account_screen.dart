import 'package:animephilic/components/components_export.dart';
import 'package:animephilic/database/database_export.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (UserAccountInformationBloc.instance.state.user == null) {
      UserAccountInformationBloc.instance.add(UserAccountInformationEventLoadData());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        actions: [
          IconButton(
            onPressed: () {
              UserAccountInformationBloc.instance.add(UserAccountInformationEventFetchData());
            },
            icon: const Icon(Icons.sync_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<UserAccountInformationBloc, UserAccountInformationState>(
          buildWhen: (previous, current) => previous.state != current.state,
          builder: (context, state) {
            if (state.state == UserDataState.fetching || state.user == null) {
              return const Center(
                  child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ));
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Chip(
                              avatar: const Icon(FontAwesomeIcons.clock),
                              label: Text(
                                  "${state.user!.joined.day}.${state.user!.joined.month}.${state.user!.joined.year}"),
                            ),
                            Chip(
                              avatar: const Icon(Icons.location_on_rounded),
                              label: Text("${state.user!.location}"),
                            ),
                            Chip(
                              avatar: const Icon(Icons.cake_rounded),
                              label: Text(
                                  "${state.user!.birthday?.day.toString().padLeft(2, '0')}.${state.user!.birthday?.month.toString().padLeft(2, '0')}.${state.user!.birthday?.year}"),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          children: [
                            Center(
                              child: CircleAvatar(
                                radius: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(80),
                                  child: Image.network(
                                    state.user!.picture,
                                    errorBuilder: (context, error, stackTrace) => Image.asset(
                                      'assets/images/avatar.png',
                                      width: 160,
                                      height: 160,
                                      fit: BoxFit.cover,
                                    ),
                                    width: 160,
                                    height: 160,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  state.user!.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    child: Text(
                      "Anime Statictics",
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 0,
                            centerSpaceRadius: 0,
                            sections: [
                              PieChartSectionData(
                                color: Theme.of(context).colorScheme.secondary,
                                value: state.stat!.numItemsPlanToWatch.toDouble(),
                                title: '',
                                radius: 80,
                                titlePositionPercentageOffset: 0.55,
                              ),
                              PieChartSectionData(
                                color: Theme.of(context).colorScheme.inversePrimary,
                                value: state.stat!.numItemsCompleted.toDouble(),
                                title: '',
                                radius: 80,
                                titlePositionPercentageOffset: 0.55,
                              ),
                              PieChartSectionData(
                                color: Theme.of(context).colorScheme.error,
                                value: state.stat!.numItemsDropped.toDouble(),
                                title: '',
                                radius: 80,
                                titlePositionPercentageOffset: 0.55,
                              ),
                              PieChartSectionData(
                                color: Theme.of(context).colorScheme.tertiaryContainer,
                                value: state.stat!.numItemsOnHold.toDouble(),
                                title: '',
                                radius: 80,
                                titlePositionPercentageOffset: 0.55,
                              ),
                              PieChartSectionData(
                                color: Theme.of(context).colorScheme.primary,
                                value: state.stat!.numItemsWatching.toDouble(),
                                title: '',
                                radius: 80,
                                titlePositionPercentageOffset: 0.55,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Chip(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            label: Text(
                              "Watching: ${state.stat!.numItemsWatching}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          Chip(
                            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                            label: Text(
                              "On Hold: ${state.stat!.numItemsOnHold}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onTertiaryContainer,
                              ),
                            ),
                          ),
                          Chip(
                            backgroundColor: Theme.of(context).colorScheme.error,
                            label: Text(
                              "Dropped: ${state.stat!.numItemsDropped}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onError,
                              ),
                            ),
                          ),
                          Chip(
                            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                            label: Text(
                              "Completed: ${state.stat!.numItemsCompleted}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                          Chip(
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            label: Text(
                              "Plan to Watch: ${state.stat!.numItemsPlanToWatch}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Tooltip(
                        message: "Average Rating",
                        preferBelow: false,
                        child: Chip(
                          avatar: const Icon(Icons.star_rounded),
                          label: Text("${state.stat!.meanScore}"),
                        ),
                      ),
                      Tooltip(
                        message: "Episodes",
                        preferBelow: false,
                        child: Chip(
                          avatar: const Icon(Icons.movie_rounded),
                          label: Text("${state.stat!.numEpisodes}"),
                        ),
                      ),
                      Tooltip(
                        message: "Days Watched",
                        preferBelow: false,
                        child: Chip(
                          avatar: const Icon(Icons.timeline_rounded),
                          label: Text("${state.stat!.numDaysWatched}"),
                        ),
                      ),
                      Tooltip(
                        message: "Total Items",
                        preferBelow: false,
                        child: Chip(
                          avatar: const Icon(Icons.numbers_rounded),
                          label: Text("${state.stat!.numItems}"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      StatCard(
                        stat: 'Items Watching',
                        value: state.stat!.numItemsWatching,
                      ),
                      StatCard(
                        stat: 'Items Completed',
                        value: state.stat!.numItemsCompleted,
                      ),
                      StatCard(
                        stat: 'Items On Hold',
                        value: state.stat!.numItemsOnHold,
                      ),
                      StatCard(
                        stat: 'Items Dropped',
                        value: state.stat!.numItemsDropped,
                      ),
                      StatCard(
                        stat: 'Items Plan to Watch',
                        value: state.stat!.numItemsPlanToWatch,
                      ),
                      StatCard(
                        stat: 'Total Items',
                        value: state.stat!.numItems,
                      ),
                      StatCard(
                        stat: 'Days Watched',
                        value: state.stat!.numDaysWatched,
                      ),
                      StatCard(
                        stat: 'Days Watching',
                        value: state.stat!.numDaysWatching,
                      ),
                      StatCard(
                        stat: 'Days Completed',
                        value: state.stat!.numDaysCompleted,
                      ),
                      StatCard(
                        stat: 'Days On Hold',
                        value: state.stat!.numDaysOnHold,
                      ),
                      StatCard(
                        stat: 'Days Dropped',
                        value: state.stat!.numDaysDropped,
                      ),
                      StatCard(
                        stat: 'Total Days',
                        value: state.stat!.numDays,
                      ),
                      StatCard(
                        stat: 'Episodes',
                        value: state.stat!.numEpisodes,
                      ),
                      StatCard(
                        stat: 'Times Rewatched',
                        value: state.stat!.numTimesRewatched,
                      ),
                      StatCard(
                        stat: 'Mean Score',
                        value: state.stat!.meanScore,
                      ),
                    ],
                  ),
                  const Divider(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
