import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tascadia_prototype/TD-Dashboard-Modules/td_dashboard_page.dart';
import 'package:tascadia_prototype/TD-Dashboard-Modules/td_home_page.dart';
import 'package:tascadia_prototype/logreg.dart';
import 'package:tascadia_prototype/TP-Dashboard-Modules/tp_store_page.dart';
import 'package:tascadia_prototype/utils/nav_bar.dart';
import 'welcome_page.dart';
import 'TP-Dashboard-Modules/tp_settings_page.dart';

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
    final response = await Supabase.instance.client
        .from('users') 
        .select()
        .limit(1)
        .maybeSingle(); 

    if (response == null) {
      debugPrint("Supabase is reachable, but no data found in the 'users' table.");
    } else {
      debugPrint("Supabase is reachable. Test data: $response");
    }
  } catch (e) {
    debugPrint("Error initializing Supabase or testing connection: $e");
    return;
  }

  runApp(TascadiaApp());
}


final supabase = Supabase.instance.client;

class TascadiaApp extends StatelessWidget {
  const TascadiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFinder',
      theme: ThemeData(
        primaryColor: const Color(0xFFF9C270),
        scaffoldBackgroundColor: const Color(0xFF1E1F2B),
      ),
      home: WelcomePage(), 
      initialRoute: '/welcomepage',
      routes: {
        '/welcomepage': (context) => WelcomePage(),
        '/store': (context) => const StorePage(),
        '/settings': (context) => SettingsPage(),
        '/taskdoer_home': (context) => TaskDoerHomePage(
          id: ModalRoute.of(context)!.settings.arguments as String,
        ),
        '/taskdoer_dashboard': (context) => TaskDoerDashboardPage(
          id: ModalRoute.of(context)!.settings.arguments as String,
        ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          final id = settings.arguments as String?;
          if (id != null) {
            return MaterialPageRoute(
              builder: (context) => HomePage(id: id),
            );
          }
          return _errorRoute("Missing ID for dashboard");
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
    debugPrint("Navigated to an unknown route: $errorMessage");
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
