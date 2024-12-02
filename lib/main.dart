import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tascadia_prototype/TD-Dashboard-Modules/td_dashboard_page.dart';
import 'package:tascadia_prototype/TD-Dashboard-Modules/td_home_page.dart';
import 'package:tascadia_prototype/logreg.dart';
import 'package:tascadia_prototype/tp_store_page.dart';
import 'package:tascadia_prototype/utils/nav_bar.dart';
import 'welcome_page.dart';
import 'Settings-Modules/tp_settings_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/auth.env");

  final supabaseUrl = dotenv.env['SUPABASE_URL']!;
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
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
        '/taskdoer_home': (context) => TaskDoerHomePage(
          username: ModalRoute.of(context)!.settings.arguments as String,
        ),
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
