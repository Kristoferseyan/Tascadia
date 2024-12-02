import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tascadia_prototype/TD-Dashboard-Modules/td_task_application_page.dart';
import '../utils/database_handler.dart';
import '../utils/colors.dart';

class TaskDoerDashboardPage extends StatefulWidget {
  final String id; // Changed from `username` to `id`

  const TaskDoerDashboardPage({Key? key, required this.id}) : super(key: key);

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
      // Fetch tasks for the specific user ID
      final taskData = await _dbHandler.fetchTasks(widget.id);
      setState(() {
        tasks = taskData.map<Map<String, dynamic>>((task) {
          return {
            'id': task['id'],
            'title': task['title'],
            'description': task['description'],
            'budget': task['budget'],
            'category': task['category'],
            'due_date': task['due_date'] != null
                ? DateTime.parse(task['due_date']).toString()
                : 'No due date',
            'address': task['address'] ?? 'No address specified',
          };
        }).toList();
      });

      print("Tasks fetched for user ID ${widget.id}: $tasks");
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
    print("Logged in as user ID: ${widget.id}");
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Task Doer Dashboard',
          style: TextStyle(color: AppColors.textPrimary),
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

  void _showTaskDetailsBottomSheet(BuildContext context, Map<String, dynamic> task) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Details
              Text(
                task['title'],
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Description:',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                task['description'],
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),

              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                  ),
                  onPressed: () async {
                    try {
                      // Ensure the task ID exists
                      if (!task.containsKey('id') || task['id'] == null) {
                        throw Exception("Task ID is missing.");
                      }

                      // Apply for the task
                      await _dbHandler.applyForTask(
                        taskId: task['id'], // Task ID from tasks table
                        taskDoerId: widget.id, // User ID from users table
                      );

                      // Redirect to Task Application Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskApplicationPage(task: task),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  },
                  child: const Text(
                    'Accept Task',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    return Card(
      color: AppColors.cardBackground,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: ListTile(
        title: Text(
          task['title'],
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Budget: ₱${task['budget']}',
              style: const TextStyle(
                color: AppColors.accent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Due Date: ${task['due_date']}',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
              ),
            ),
          ],
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
          ),
          onPressed: () => _showTaskDetailsBottomSheet(context, task),
          child: const Text(
            'View',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
