import 'package:flutter/material.dart';

class TaskApplicationPage extends StatelessWidget {
  final Map<String, dynamic> task;

  const TaskApplicationPage({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1F2B),
      appBar: AppBar(
        title: const Text('Task Application'),
        backgroundColor: const Color(0xFF1E1F2B),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.hourglass_empty, size: 100, color: Colors.white70),
              const SizedBox(height: 20),
              Text(
                'You have applied for the task:\n"${task['title']}"',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please wait for the Task Poster to review your application.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF9C270),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Back to Dashboard',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
