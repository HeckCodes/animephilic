import 'package:animephilic/authenication_bloc/authentication_handler_bloc_bloc.dart';
import 'package:animephilic/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/oauth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  bool? isUserLoggedIn = sharedPreferences.getBool("loggedIn");

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationHandlerBloc>(
            create: (context) => AuthenticationHandlerBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
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
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: BlocBuilder<AuthenticationHandlerBloc,
          AuthenticationHandlerBlocState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          if (widget.isUserLoggedIn ??
              false || state.status == AuthenticationStatus.loggedIn) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
