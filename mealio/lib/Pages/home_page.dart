import 'package:flutter/material.dart';
import 'package:mealio/Pages/home_content_page.dart';
import 'package:mealio/Pages/profile_content_page.dart';
import 'package:mealio/Pages/favorite_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  int _favoriteKey = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        _favoriteKey++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      FavoritePage(key: ValueKey(_favoriteKey)),
      const HomeContentPage(),
      const ProfileContentPage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Saved",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
