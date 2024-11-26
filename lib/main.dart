import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tascadia_prototype/logreg.dart';
import 'welcome_page.dart';
import 'Dashboard-Modules/tp_dashboard_page.dart';
import 'Settings-Modules/tp_settings_page.dart';
import 'tp_tasks_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ebexpwjowwgvxbzbausd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImViZXhwd2pvd3dndnhiemJhdXNkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIzMTkzNTIsImV4cCI6MjA0Nzg5NTM1Mn0.bG7zifFauy-XMX08yKQ9SoaWSy_SL7WfM0ae_FyVYLc',
  );

  runApp(TascadiaApp());
}

final supabase = Supabase.instance.client;

class TascadiaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tascadia',
      theme: ThemeData(
        primaryColor: const Color(0xFFF9C270),
        scaffoldBackgroundColor: const Color(0xFF1E1F2B),
      ),
      initialRoute: '/welcomepage',
      routes: {
        '/welcomepage': (context) => WelcomePage(),
        '/tasks': (context) => TasksPage(),
        '/settings': (context) => SettingsPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          final username = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => TaskPosterDashboard(username: username),
          );
        }
        if (settings.name == '/login_register') {
          final role = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => LoginRegisterPage(role: role),
          );
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
