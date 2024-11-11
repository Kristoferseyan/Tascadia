import 'package:flutter/material.dart';
import 'nav_bar.dart'; 

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 2; 
  final PageController _pageController = PageController(initialPage: 2);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1F2B),
      appBar: AppBar(
        title: const Text("Settings"), 
        backgroundColor: const Color(0xFF1E1F2B),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          Center(child: Text("Tasks Page", style: TextStyle(color: Colors.white))),
          Center(child: Text("Dashboard Page", style: TextStyle(color: Colors.white))),
          Center(child: Text("Settings Page", style: TextStyle(color: Colors.white))),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
