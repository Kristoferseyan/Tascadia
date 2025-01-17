import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tascadia_prototype/TD-Dashboard-Modules/td_home_page.dart';
import 'package:tascadia_prototype/utils/nav_bar.dart';
import 'utils/database_handler.dart';

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
                ? HomePage(id: user['id'])
                : TaskDoerHomePage(id: user['id']),
          ),
        );
      } catch (e) {
        showSnackBar(e.toString());
      }
    } else {
      showSnackBar("Please fill in all fields");
    }
  }

void registerUser() async {
  final username = usernameController.text.trim();
  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
    await dbHandler.registerUser(
      username: username,
      email: email,
      password: password,
      role: widget.role,
    );

    authenticateUser();
  } else {
    showSnackBar("Please fill in all fields");
  }
}


  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roleTitle =
        widget.role == 'TaskPoster' ? "Task Poster" : "Task Doer";

    return Scaffold(
      backgroundColor: const Color(0xFF1E1F2B),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "$roleTitle ${isLogin ? "Login" : "Register"}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E1F2B),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!isLogin)
                _buildTextField(
                  controller: usernameController,
                  label: "Username",
                  icon: Icons.person,
                ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: emailController,
                label: isLogin ? "Username or Email" : "Email",
                icon: Icons.email,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: passwordController,
                label: "Password",
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF9C270),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  minimumSize: const Size(double.infinity, 50),
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
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                    usernameController.clear();
                    emailController.clear();
                    passwordController.clear();
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF2A2B39),
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFF9C270)),
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.white70),
                onPressed: () => controller.clear(),
              )
            : null,
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
