import 'package:animephilic/screens/account_screen.dart';
import 'package:animephilic/screens/home_screen.dart';
import 'package:animephilic/screens/user_anime_screen.dart';
import 'package:animephilic/screens/user_manga_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int currentPageIndex = 0;

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
            pageController.animateToPage(currentPageIndex,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease);
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.timeline_rounded),
            label: 'Home',
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
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomeScreen(),
          UserAnimeListScreen(),
          UserMangaListScreen(),
          AccountScreen(),
        ],
      ),
    );
  }
}
