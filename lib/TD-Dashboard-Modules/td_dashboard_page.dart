import 'package:flutter/material.dart';
import '../utils/database_handler.dart';
import '../utils/colors.dart';

class TaskDoerDashboardPage extends StatefulWidget {
  final String username;

  const TaskDoerDashboardPage({Key? key, required this.username}) : super(key: key);

  @override
  _TaskDoerDashboardPageState createState() => _TaskDoerDashboardPageState();
}

class _TaskDoerDashboardPageState extends State<TaskDoerDashboardPage> {
  final DatabaseHandler _dbHandler = DatabaseHandler();
  List<Map<String, dynamic>> tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

Future<void> fetchTasks() async {
  setState(() {
    isLoading = true;
  });

  try {
    
    final taskData = await _dbHandler.fetchTasks('');
    setState(() {
      tasks = taskData.map<Map<String, dynamic>>((task) {
        return {
          'title': task['title'],
          'description': task['description'],
          'budget': '\$${task['budget']}',
          'category': task['category'],
          'due_date': task['due_date'] != null
              ? DateTime.parse(task['due_date']).toString()
              : 'No due date',
          'status': task['status'],
        };
      }).toList();
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error fetching tasks: $e")),
    );
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        title: Text(
          'Welcome, ${widget.username}',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.accent),
            onPressed: fetchTasks, 
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : tasks.isNotEmpty
              ? ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return _buildTaskCard(task);
                  },
                )
              : const Center(
                  child: Text(
                    "No tasks found.",
                    style: TextStyle(color: AppColors.textMuted, fontSize: 16),
                  ),
                ),
    );
  }

Widget _buildTaskCard(Map<String, dynamic> task) {
  return Card(
    color: AppColors.cardBackground,
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task['title'],
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            task['description'],
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Budget: ${task['budget']}',
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Category: ${task['category']}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Due Date: ${task['due_date']}',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Status: ${task['status']}',
            style: TextStyle(
              color: task['status'] == 'Completed' ? Colors.green : AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Accepted task: ${task['title']}')),
              );
            },
            child: const Text(
              'Accept Task',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    ),
  );
}
}