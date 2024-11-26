import 'package:flutter/material.dart';
import 'utils/nav_bar.dart'; 

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  int _selectedIndex = 0; 
  final PageController _pageController = PageController(initialPage: 0);

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
        title: const Text("Tasks"), 
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
