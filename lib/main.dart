import 'package:animephilic/authentication/authenticaton_exports.dart';
import 'package:animephilic/database/database_export.dart';
import 'package:animephilic/screens/anime_details_screen.dart';
import 'package:animephilic/screens/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/oauth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  bool? isUserLoggedIn = sharedPreferences.getBool("loggedIn");
  Authentication();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthenticationHandlerBloc()),
        BlocProvider(create: (context) => UserAccountInformationBloc.instance),
        BlocProvider(create: (context) => UserAnimeListBloc.instance),
        BlocProvider(create: (context) => UserMangaListBloc.instance),
        BlocProvider(create: (context) => SeasonalAnimeBloc.instance),
        BlocProvider(create: (context) => AnimeRankingBloc.instance),
      ],
      child: MaterialApp(
        title: 'Animephilic',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        home: SafeArea(child: Root(isUserLoggedIn: isUserLoggedIn)),
      ),
    ),
  );
}

class Root extends StatefulWidget {
  final bool? isUserLoggedIn;
  const Root({
    super.key,
    required this.isUserLoggedIn,
  });

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarColor: ElevationOverlay.applySurfaceTint(
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surfaceTint,
          3,
        ),
        statusBarIconBrightness:
            MediaQuery.of(context).platformBrightness == Brightness.light ? Brightness.dark : Brightness.light,
        systemNavigationBarIconBrightness:
            MediaQuery.of(context).platformBrightness == Brightness.light ? Brightness.dark : Brightness.light,
      ),
      child: BlocBuilder<AuthenticationHandlerBloc, AuthenticationHandlerState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          if (widget.isUserLoggedIn ?? false || state.status == AuthenticationStatus.loggedIn) {
            return const AnimeDetailsScreen(animeId: 1535);
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
