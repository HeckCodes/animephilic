import 'package:animephilic/authentication/authenticaton_exports.dart';
import 'package:animephilic/screens/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.calendar),
            label: 'Seasonal',
          ),
          NavigationDestination(
            icon: Icon(Icons.tv_rounded),
            label: 'Anime',
          ),
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.file),
            label: 'Manga',
          ),
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.user),
            label: 'Account',
          ),
        ],
      ),
      body: <Widget>[
        Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Text(Authentication().accessToken),
        ),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: const Text('Page 2'),
        ),
        Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: const Text('Page 3'),
        ),
        const AccountScreen(),
      ][currentPageIndex],
    );
  }
}
