import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../utils/colors.dart';

class TaskList extends StatelessWidget {
  final List<dynamic> tasks;
  final bool isLoading;

  const TaskList({Key? key, required this.tasks, required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      );
    }

    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          "No tasks available.",
          style: TextStyle(color: AppColors.textMuted),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(
          context,
          task['title'] ?? "Untitled",
          task['status'] ?? "Pending",
          task['due_date'], 
        );
      },
    );
  }

  Widget _buildTaskCard(BuildContext context, String title, String status, String? dueDate) {
    
    final formattedDate = (dueDate != null && dueDate != "No Date")
        ? "Due Date: ${DateFormat('MMMM dd, yyyy').format(DateTime.parse(dueDate))}"
        : "Due Date: No Date";

    return Center(
      child: Card(
        color: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    status,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    formattedDate, 
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
