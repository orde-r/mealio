import 'package:flutter/material.dart';
import 'package:mealino/Pages/home_content_page.dart';
import 'package:mealino/Pages/profile_content_page.dart';
import 'package:mealino/Pages/saved_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 1; // default di Home

  final List<Widget> _pages = const [
    SavedPage(),
    HomeContentPage(),
    ProfileContentPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pages[_selectedIndex],
      

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        selectedItemColor: const Color(0xFFF26A3D),
        unselectedItemColor: const Color(0xFF94A3B8),

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Saved",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}