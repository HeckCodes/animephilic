import 'package:animephilic/components/stat_card.dart';
import 'package:animephilic/database/database_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    if (UserAccountInformationBloc.instance.state.user == null) {
      UserAccountInformationBloc.instance
          .add(UserAccountInformationEventLoadData());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account")),
      body: SingleChildScrollView(
        child: BlocBuilder<UserAccountInformationBloc,
            UserAccountInformationState>(
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
                  Center(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(state.user!.picture),
                      radius: 64,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        state.user!.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const Divider(),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 2,
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
