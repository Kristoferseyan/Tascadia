import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1F2B),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Welcome to TaskFinder!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFF9C270),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Where tasks and doers meet!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFE5E5E5),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            _buildRoleCard(
              context,
              "Task Poster",
              "Create and post tasks to find skilled helpers.",
              Icons.edit_note,
              const Color(0xFFF3D9B1),
              () {
                Navigator.pushNamed(
                  context,
                  '/login_register',
                  arguments: 'TaskPoster', 
                );
              },
            ),
            const SizedBox(height: 20),
            _buildRoleCard(
              context,
              "Task Doer",
              "Browse and complete tasks to earn rewards.",
              Icons.handyman,
              const Color(0xFFF3D9B1),
              () {
                Navigator.pushNamed(
                  context,
                  '/login_register',
                  arguments: 'TaskDoer', 
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, String role, String description,
      IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2B39),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role,
                    style: TextStyle(
                      color: color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFFA4A4A8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
