import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tascadia_prototype/TD-Dashboard-Modules/td_dashboard_page.dart';
import 'package:tascadia_prototype/TD-Dashboard-Modules/td_home_page.dart';
import 'package:tascadia_prototype/logreg.dart';
import 'package:tascadia_prototype/TP-Dashboard-Modules/tp_store_page.dart';
import 'package:tascadia_prototype/utils/nav_bar.dart';
import 'package:tascadia_prototype/welcome_page.dart';
import 'package:tascadia_prototype/TP-Dashboard-Modules/tp_settings_page.dart';

Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  
  await _initializeEnvironment();

  
  await _initializeSupabase();

  
  runApp(const TascadiaApp());
}


Future<void> _initializeEnvironment() async {
  try {
    await dotenv.load(fileName: "assets/auth.env");
    debugPrint("Environment variables loaded successfully.");
  } catch (e) {
    debugPrint("Failed to load environment variables: $e");
  }
}


Future<void> _initializeSupabase() async {
  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null || supabaseAnonKey == null) {
    debugPrint("Supabase configuration is missing in the .env file.");
    return;
  }

  try {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
    debugPrint("Supabase initialized successfully.");

    
    final response = await Supabase.instance.client
        .from('users')
        .select()
        .limit(1)
        .maybeSingle();

    if (response == null) {
      debugPrint("Supabase connection is successful, but no data in 'users' table.");
    } else {
      debugPrint("Supabase connection successful. Test data: $response");
    }
  } catch (e) {
    debugPrint("Error initializing Supabase: $e");
  }
}


class TascadiaApp extends StatelessWidget {
  const TascadiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFinder',
      theme: _buildAppTheme(),
      initialRoute: '/', 
      routes: _buildRoutes(),
      onGenerateRoute: _onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }

  
  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      '/': (context) => const WelcomePage(), 
      '/welcomepage': (context) => const WelcomePage(),
      '/store': (context) => const StorePage(),
      '/settings': (context) => const SettingsPage(),
      '/taskdoer_home': (context) => TaskDoerHomePage(
        id: ModalRoute.of(context)?.settings.arguments as String? ?? '',
      ),
      '/taskdoer_dashboard': (context) => TaskDoerDashboardPage(
        id: ModalRoute.of(context)?.settings.arguments as String? ?? '',
      ),
    };
  }

  
  ThemeData _buildAppTheme() {
    return ThemeData(
      primaryColor: const Color(0xFFF9C270),
      scaffoldBackgroundColor: const Color(0xFF1E1F2B),
    );
  }

  
  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/dashboard') {
      final id = settings.arguments as String?;
      if (id != null) {
        return MaterialPageRoute(builder: (context) => HomePage(id: id));
      }
      return _errorRoute("Missing ID for dashboard");
    }

    if (settings.name == '/login_register') {
      final role = settings.arguments as String?;
      if (role != null) {
        return MaterialPageRoute(builder: (context) => LoginRegisterPage(role: role));
      }
      return _errorRoute("Missing role for login/register");
    }

    return _errorRoute("Route not found: ${settings.name}");
  }

  
  Route<dynamic> _errorRoute(String errorMessage) {
    debugPrint("Navigation error: $errorMessage");
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
