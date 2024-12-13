import 'package:flutter/material.dart';
import 'package:tascadia_prototype/TD-Dashboard-Modules/td_task_application_page.dart';
import '../utils/database_handler.dart';
import '../utils/colors.dart';

class TaskDoerDashboardPage extends StatefulWidget {
  final String id; // Task doer ID to fetch specific data

  const TaskDoerDashboardPage({Key? key, required this.id}) : super(key: key);

  @override
  _TaskDoerDashboardPageState createState() => _TaskDoerDashboardPageState();
}

class _TaskDoerDashboardPageState extends State<TaskDoerDashboardPage> {
  final DatabaseHandler _dbHandler = DatabaseHandler();
  List<Map<String, dynamic>> tasks = [];
  bool isLoading = true;
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    fetchAvailableTasks();
    fetchNotifications();
  }

  // Fetch tasks available to all task doers
  Future<void> fetchAvailableTasks() async {
    setState(() {
      isLoading = true;
    });

    try {
      final taskData = await _dbHandler.fetchAvailableTasks();
      setState(() {
        tasks = taskData;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching available tasks: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch notifications for the task doer
  Future<void> fetchNotifications() async {
    try {
      final notificationsData = await _dbHandler.fetchNotificationsForUser(widget.id);
      setState(() {
        notifications = notificationsData;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching notifications: $e")),
      );
    }
  }

  // Show notification details in a bottom sheet
  void _showNotificationDetailsModal(Map<String, dynamic> notification) {
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
              Text(
                notification['message'],
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Received at: ${notification['created_at']}',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.notifications, color: AppColors.accent),
            onPressed: () {
              // Show notifications in a bottom sheet when the notification icon is tapped
              showModalBottomSheet(
                context: context,
                backgroundColor: AppColors.background,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                ),
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return ListTile(
                          title: Text(
                            notification['message'],
                            style: const TextStyle(color: AppColors.textPrimary),
                          ),
                          subtitle: Text(
                            'Received at: ${notification['created_at']}',
                            style: const TextStyle(color: AppColors.textMuted),
                          ),
                          onTap: () => _showNotificationDetailsModal(notification), // Show details in a modal
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.accent),
            onPressed: fetchAvailableTasks,
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

  // Build a task card for the dashboard
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

  // Show task details in a bottom sheet
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
                    if (!task.containsKey('id') || task['id'] == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Task ID is missing.")),
                      );
                      return;
                    }

                    await _dbHandler.applyForTask(
                      taskId: task['id'],
                      taskDoerId: widget.id,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskApplicationPage(task: task),
                      ),
                    );
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
}
