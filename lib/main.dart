import 'package:animephilic/authenication_bloc/authentication_handler_bloc_bloc.dart';
import 'package:animephilic/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/oauth_screen.dart';

void main() async {
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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Root(isUserLoggedIn: isUserLoggedIn),
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
    return BlocBuilder<AuthenticationHandlerBloc,
        AuthenticationHandlerBlocState>(
      buildWhen: (previous, current) {
        return previous.status != current.status;
      },
      builder: (context, state) {
        if (widget.isUserLoggedIn ??
            false || state.status == AuthenticationStatus.loggedIn) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
