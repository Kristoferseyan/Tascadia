import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/database_handler.dart';

class TaskApplicationReviewPage extends StatelessWidget {
  final Map<String, dynamic> application;
  final DatabaseHandler dbHandler = DatabaseHandler(); 

  TaskApplicationReviewPage({Key? key, required this.application})
      : super(key: key);

void _approveApplication(BuildContext context) async {
  print("Application ID: ${application['application_id']}");
  print("Task ID: ${application['task_id']}");
  print("Task Doer ID: ${application['task_doer_id']}");
  print("Task Title: ${application['task_title']}");

  final applicationId = application['application_id'];
  final taskId = application['task_id'];
  final taskDoerId = application['task_doer_id'];
  final taskTitle = application['task_title'] ?? "Unknown Task";

  
  if (applicationId != null && taskId != null && taskDoerId != null) {
    
    await dbHandler.updateApplicationStatus(
      applicationId: applicationId,
      status: 'Approved',
    );

    
    await dbHandler.updateTaskStatus(
      taskId: taskId,
      status: 'In Progress',
    );

    
    await dbHandler.sendNotificationToTaskDoer(
      taskDoerId: taskDoerId,
      message: "Your application for '$taskTitle' has been approved!",
    );

    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Application approved successfully!')),
    );

    Navigator.pop(context);
  } else {
    
    print("Missing required IDs: applicationId: $applicationId, taskId: $taskId, taskDoerId: $taskDoerId");
  }
}


  void _rejectApplication(BuildContext context) async {
    try {
      final applicationId = application['application_id'] ?? "";
      final taskDoerId = application['task_doer_id'] ?? "";
      final taskTitle = application['task_title'] ?? "Unknown Task";

      if (applicationId.isEmpty || taskDoerId.isEmpty) {
        throw Exception("Invalid application data. Missing required IDs.");
      }

      
      await dbHandler.sendNotificationToTaskDoer(
        taskDoerId: taskDoerId,
        message: "Your application for '$taskTitle' has been rejected.",
      );

      
      await dbHandler.deleteApplication(
        applicationId: applicationId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application rejected successfully!')),
      );

      Navigator.pop(context);
    } catch (e) {
      print("Error rejecting application: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error rejecting application: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Application'),
        backgroundColor: AppColors.background,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text(
              application['task_title'] ?? "No Title",
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            
            Text(
              "Task Doer: ${application['task_doer_name'] ?? "Unknown"}",
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),

            
            const Text(
              "Task Description:",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              application['task_description'] ?? "No Description",
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),

            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () => _approveApplication(context),
                  child: const Text("Approve"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () => _rejectApplication(context),
                  child: const Text("Reject"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
