import 'package:flutter/material.dart';
import '../utils/nav_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> settingsOptions = [
      {'icon': Icons.person, 'title': 'Profile', 'onTap': () => print('Profile tapped')},
      {'icon': Icons.lock, 'title': 'Privacy', 'onTap': () => print('Privacy tapped')},
      {'icon': Icons.notifications, 'title': 'Notifications', 'onTap': () => print('Notifications tapped')},
      {'icon': Icons.language, 'title': 'Language', 'onTap': () => print('Language tapped')},
      {'icon': Icons.logout, 'title': 'Logout', 'onTap': () => print('Logout tapped')},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1E1F2B),
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1F2B),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: settingsOptions.length,
        itemBuilder: (context, index) {
          final option = settingsOptions[index];
          return ListTile(
            leading: Icon(option['icon'], color: Colors.white70),
            title: Text(
              option['title'],
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            onTap: option['onTap'],
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
          );
        },
      ),
    );
  }
}
