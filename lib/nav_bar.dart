import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  CustomNavBar({required this.selectedIndex, required this.onTabChange});

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
            icon: Icons.task_alt,
            text: 'Tasks',
          ),
          GButton(
            icon: Icons.dashboard,
            text: 'Dashboard',
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
