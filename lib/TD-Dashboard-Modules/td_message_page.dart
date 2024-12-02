import 'package:flutter/material.dart';

class TaskDoerMessagesPage extends StatelessWidget {
  final String username;

  const TaskDoerMessagesPage({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        backgroundColor: const Color(0xFF2A2B39),
      ),
      body: Center(
        child: Text(
          'Welcome to Messages, $username!',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
