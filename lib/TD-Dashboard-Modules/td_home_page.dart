import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tascadia_prototype/TD-Dashboard-Modules/td_dashboard_page.dart';
import 'package:tascadia_prototype/TD-Dashboard-Modules/td_message_page.dart';
import 'package:tascadia_prototype/TD-Dashboard-Modules/td_task_history_page.dart';

class TaskDoerHomePage extends StatefulWidget {
  final String username;

  const TaskDoerHomePage({Key? key, required this.username}) : super(key: key);

  @override
  _TaskDoerHomePageState createState() => _TaskDoerHomePageState();
}

class _TaskDoerHomePageState extends State<TaskDoerHomePage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Define pages for the nav bar
    _pages = [
      TaskDoerDashboardPage(username: widget.username),
      TaskDoerMessagesPage(username: widget.username),
      TaskDoerTaskHistoryPage(username: widget.username),
    ];
  }

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Switch pages based on selected index
      bottomNavigationBar: TaskDoerNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: _onTabChange,
      ),
    );
  }
}

class TaskDoerNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const TaskDoerNavBar({required this.selectedIndex, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2A2B39),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: GNav(
        backgroundColor: const Color(0xFF2A2B39),
        color: Colors.white70,
        activeColor: const Color(0xFFF9C270),
        gap: 8,
        selectedIndex: selectedIndex,
        onTabChange: onTabChange,
        tabs: const [
          GButton(
            icon: Icons.dashboard,
            text: 'Dashboard',
          ),
          GButton(
            icon: Icons.message,
            text: 'Messages',
          ),
          GButton(
            icon: Icons.history,
            text: 'Task History',
          ),
        ],
      ),
    );
  }
}