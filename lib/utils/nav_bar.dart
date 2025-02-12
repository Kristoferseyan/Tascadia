import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tascadia_prototype/TP-Dashboard-Modules/tp_dashboard_page.dart';
import 'package:tascadia_prototype/TP-Dashboard-Modules/tp_message_page.dart';
import 'package:tascadia_prototype/TP-Dashboard-Modules/tp_settings_page.dart';
import 'package:tascadia_prototype/TP-Dashboard-Modules/tp_store_page.dart';

class HomePage extends StatefulWidget {
  final String id; 

  const HomePage({Key? key, required this.id}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1; 

  late final List<Widget> _pages; 

  @override
  void initState() {
    super.initState();
    
    _pages = [
      StorePage(), 
      TaskPosterDashboard(id: widget.id),
      TPMessagePage(id: widget.id),
      SettingsPage(), 
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
      body: _pages[_selectedIndex], 
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: _onTabChange,
      ),
    );
  }
}

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const CustomNavBar({required this.selectedIndex, required this.onTabChange});

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
            icon: Icons.store,
            text: 'Store',
          ),
          GButton(
            icon: Icons.dashboard,
            text: 'Dashboard',
          ),
          GButton(
            icon: Icons.message,
            text: 'Messages',
          ),
          GButton(
            icon: Icons.settings,
            text: 'Settings',
          ),
        ],
      ),
    );
  }
}
