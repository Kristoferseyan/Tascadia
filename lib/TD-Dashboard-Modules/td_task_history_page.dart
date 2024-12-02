import 'package:flutter/material.dart';

class TaskDoerTaskHistoryPage extends StatelessWidget {
  final String username;

  const TaskDoerTaskHistoryPage({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task History'),
        backgroundColor: const Color(0xFF2A2B39),
      ),
      body: Center(
        child: Text(
          'Task History for $username.',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
