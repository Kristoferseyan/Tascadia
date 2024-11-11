import 'package:flutter/material.dart';
import 'welcome_page.dart';
import 'tp_dashboard_page.dart';
import 'tp_settings_page.dart';
import 'tp_tasks_page.dart';

void main() {
  runApp(TascadiaApp());
}

class TascadiaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tascadia',
      theme: ThemeData(
        primaryColor: Color(0xFFF9C270),
        scaffoldBackgroundColor: Color(0xFF1E1F2B),
      ),
      initialRoute: '/welcomepage',
      routes: {
        '/welcomepage': (context) => WelcomePage(),
        '/tasks': (context) => TasksPage(),
        '/dashboard': (context) => TaskPosterDashboard(),
        '/settings': (context) => SettingsPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
