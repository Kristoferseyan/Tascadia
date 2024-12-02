import 'package:flutter/material.dart';
import 'package:tascadia_prototype/utils/database_handler.dart';

class TaskDoerTaskHistoryPage extends StatefulWidget {
  final String id;

  const TaskDoerTaskHistoryPage({Key? key, required this.id}) : super(key: key);
  @override
  _TaskDoerMessagesPageState createState() => _TaskDoerMessagesPageState();
}

class _TaskDoerMessagesPageState extends State<TaskDoerTaskHistoryPage> {
  final DatabaseHandler _dbHandler = DatabaseHandler();
  String username = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    try {
      final fetchedUsername = await _dbHandler.fetchUsername(widget.id);
      setState(() {
        username = fetchedUsername;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching username: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Task History for $username.',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
