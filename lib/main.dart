import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tascadia_prototype/TD-Dashboard-Modules/td_dashboard_page.dart';
import 'package:tascadia_prototype/logreg.dart';
import 'package:tascadia_prototype/tp_store_page.dart';
import 'package:tascadia_prototype/utils/nav_bar.dart';
import 'welcome_page.dart';
import 'Settings-Modules/tp_settings_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: 'https://yezqgjvvazinfttlmmks.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InllenFnanZ2YXppbmZ0dGxtbWtzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI3MDE4NDYsImV4cCI6MjA0ODI3Nzg0Nn0.ZNaznwb1J5kN9_jNJzZ5h89Mfrl1nVocds6jGIxA8P4',
    );
  } catch (e) {
    debugPrint("Error initializing Supabase: $e");
    return;
  }

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
        '/store': (context) => const StorePage(),
        '/settings': (context) => SettingsPage(),
        '/taskdoer_dashboard': (context) => TaskDoerDashboardPage(
          username: ModalRoute.of(context)!.settings.arguments as String,
        ),
      },
      onGenerateRoute: (settings) {

        if (settings.name == '/dashboard') {
          final username = settings.arguments as String?;
          if (username != null) {
            return MaterialPageRoute(
              builder: (context) => HomePage(username: username),
            );
          }
          return _errorRoute("Missing username for dashboard");
        }

        if (settings.name == '/login_register') {
          final role = settings.arguments as String?;
          if (role != null) {
            return MaterialPageRoute(
              builder: (context) => LoginRegisterPage(role: role),
            );
          }
          return _errorRoute("Missing role for login/register");
        }

        return _errorRoute("Route not found: ${settings.name}");
      },
      debugShowCheckedModeBanner: false,
    );
  }

  Route<dynamic> _errorRoute(String errorMessage) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
