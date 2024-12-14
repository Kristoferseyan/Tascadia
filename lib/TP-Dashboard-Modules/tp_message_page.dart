import 'package:flutter/material.dart';
import 'package:tascadia_prototype/utils/database_handler.dart';

class TPMessagePage extends StatefulWidget {
  final String id;

  const TPMessagePage({Key? key, required this.id}) : super(key: key);

  @override
  _TaskPosterMessagesPageState createState() => _TaskPosterMessagesPageState();
}

class _TaskPosterMessagesPageState extends State<TPMessagePage> {
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
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(
                'Welcome to Messages, $username!',
                style: const TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
