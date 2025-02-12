import 'package:flutter/material.dart';
import 'package:tascadia_prototype/TP-Dashboard-Modules/task_creation.dart';
import 'package:tascadia_prototype/TP-Dashboard-Modules/task_list.dart';
import 'package:tascadia_prototype/TP-Dashboard-Modules/tp_task_application_review_page.dart';
import '../utils/colors.dart';
import '../utils/database_handler.dart';

class TaskPosterDashboard extends StatefulWidget {
  final String id; 

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
    fetchUserDataAndTasks(widget.id); 
    fetchPendingApplications(widget.id);
  }

  List<dynamic> pendingApplications = []; 

  Future<void> fetchPendingApplications(String userId) async {
    try {
      final applications = await dbHandler.fetchPendingApplicationsForPoster(userId);
      setState(() {
        pendingApplications = applications;
      });
    } catch (e) {
      print("Error fetching pending applications: $e");
    }
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

void _reviewApplication(Map<String, dynamic> application) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TaskApplicationReviewPage(application: application),
    ),
  );
}


void _showPendingApplicationsModal(BuildContext context) {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pending Applications",
              style: const TextStyle(
                color: AppColors.accent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            pendingApplications.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: pendingApplications.length,
                    itemBuilder: (context, index) {
                      final application = pendingApplications[index];
                      return ListTile(
                        title: Text(
                          application['task_title'], 
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                        subtitle: Text(
                          "Task Doer: ${application['task_doer_name']}", 
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                          ),
                          onPressed: () {
                            Navigator.pop(context); 
                            _reviewApplication(application); 
                          },
                          child: const Text(
                            'Review',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      "No pending applications.",
                      style: TextStyle(color: AppColors.textMuted),
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
                  icon: Stack(
                    children: [
                      Icon(Icons.notifications, color: AppColors.textPrimary, size: screenWidth * 0.07),
                      if (pendingApplications.isNotEmpty) 
                        Positioned(
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${pendingApplications.length}', 
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onPressed: () => _showPendingApplicationsModal(context),
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
