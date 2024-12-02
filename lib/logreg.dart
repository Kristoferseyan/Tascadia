import 'package:flutter/material.dart';
import 'package:tascadia_prototype/TD-Dashboard-Modules/td_home_page.dart';
import 'package:tascadia_prototype/utils/nav_bar.dart';
import 'utils/database_handler.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

class LoginRegisterPage extends StatefulWidget {
  final String role;

  const LoginRegisterPage({Key? key, required this.role}) : super(key: key);

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  bool isLogin = true; 
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final DatabaseHandler dbHandler = DatabaseHandler(); 

  
  Future<void> saveUserIdLocally(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  
void authenticateUser() async {
  final usernameOrEmail = usernameController.text.isNotEmpty
      ? usernameController.text
      : emailController.text;
  final password = passwordController.text;

  if (usernameOrEmail.isNotEmpty && password.isNotEmpty) {
    try {
      final user = await dbHandler.loginUser(
        usernameOrEmail: usernameOrEmail,
        password: password,
      );

      
      await saveUserIdLocally(user['id']);

      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => widget.role == 'TaskPoster'
              ? HomePage(username: user['username']) 
              : TaskDoerHomePage(username: user['username']), 
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill in all fields")),
    );
  }
}

void registerUser() async {
  final username = usernameController.text.trim();
  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
    try {
      await dbHandler.registerUser(
        username: username,
        email: email,
        password: password,
        role: widget.role,
      );

      final user = await dbHandler.loginUser(
        usernameOrEmail: username,
        password: password,
      );

      if (user != null && user['username'] != null) {
        await saveUserIdLocally(user['id']);

        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => widget.role == 'TaskPoster'
                ? HomePage(username: user['username']) 
                : TaskDoerHomePage(username: user['username']), 
          ),
        );
      } else {
        throw Exception('User data is incomplete.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill in all fields")),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1F2B),
      appBar: AppBar(
        title: Text(isLogin ? "Login" : "Register"),
        backgroundColor: const Color(0xFF1E1F2B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.role == 'TaskPoster'
                    ? "Task Poster ${isLogin ? "Login" : "Register"}"
                    : "Task Doer ${isLogin ? "Login" : "Register"}",
                style: const TextStyle(
                  color: Color(0xFFF9C270),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (!isLogin) 
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    filled: true,
                    fillColor: const Color(0xFF2A2B39),
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: isLogin ? "Username or Email" : "Email",
                  filled: true,
                  fillColor: const Color(0xFF2A2B39),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  filled: true,
                  fillColor: const Color(0xFF2A2B39),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF9C270),
                ),
                onPressed: isLogin ? authenticateUser : registerUser,
                child: Text(
                  isLogin ? "Login" : "Register",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin; 
                    usernameController.clear(); 
                  });
                },
                child: Text(
                  isLogin
                      ? "Don't have an account? Register"
                      : "Already have an account? Login",
                  style: const TextStyle(color: Color(0xFFF9C270)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
