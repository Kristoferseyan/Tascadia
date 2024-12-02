import 'package:flutter/material.dart';
import 'package:tascadia_prototype/TP-Dashboard-Modules/task_creation.dart';
import 'package:tascadia_prototype/TP-Dashboard-Modules/task_list.dart';
import '../utils/colors.dart';
import '../utils/database_handler.dart';

class TaskPosterDashboard extends StatefulWidget {
  final String id; // Changed to `id`

  const TaskPosterDashboard({Key? key, required this.id}) : super(key: key);

  @override
  _TaskPosterDashboardState createState() => _TaskPosterDashboardState();
}

class _TaskPosterDashboardState extends State<TaskPosterDashboard> {
  final DatabaseHandler dbHandler = DatabaseHandler();

  List<dynamic> tasks = [];
  String userName = 'User';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDataAndTasks(widget.id); // Use `id` directly
  }

  Future<void> fetchUserDataAndTasks(String userId) async {
    try {
      print("Fetching data for user ID: $userId");

      final userData = await dbHandler.fetchUserById(userId);
      final fetchedTasks = await dbHandler.fetchTasks(userId);

      setState(() {
        userName = userData['username'] ?? 'User';
        tasks = fetchedTasks;
        isLoading = false;
      });

      print("Tasks fetched: $tasks");
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching user data or tasks: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  void _showTaskCreationModal() {
    if (widget.id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User ID not available.')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: TaskCreationForm(userId: widget.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.06,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.06,
                  backgroundColor: AppColors.accent,
                  child: Icon(Icons.person, color: AppColors.textPrimary, size: screenWidth * 0.06),
                ),
                SizedBox(width: screenWidth * 0.03),
                Text(
                  "Welcome, $userName!",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.notifications, color: AppColors.textPrimary, size: screenWidth * 0.07),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              "Categories",
              style: TextStyle(
                color: AppColors.accent,
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip("Tech", Icons.computer, screenWidth),
                  _buildCategoryChip("Manual", Icons.build, screenWidth),
                  _buildCategoryChip("Delivery", Icons.local_shipping, screenWidth),
                  _buildCategoryChip("Cleaning", Icons.cleaning_services, screenWidth),
                  _buildCategoryChip("Other", Icons.more_horiz, screenWidth),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Posted Tasks",
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle, color: AppColors.accent, size: screenWidth * 0.07),
                  onPressed: _showTaskCreationModal,
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.015),
            Expanded(
              child: TaskList(tasks: tasks, isLoading: isLoading),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(right: screenWidth * 0.02),
      child: Chip(
        backgroundColor: AppColors.chipBackground,
        avatar: Icon(icon, color: AppColors.accent, size: screenWidth * 0.045),
        label: Text(
          label,
          style: TextStyle(color: AppColors.textPrimary, fontSize: screenWidth * 0.04),
        ),
      ),
    );
  }
}
