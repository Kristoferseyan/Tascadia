import 'package:flutter/material.dart';
import 'package:tascadia_prototype/Dashboard-Modules/task_creation.dart';
import '../colors.dart';
import '../nav_bar.dart';
import '../database_handler.dart';

class TaskPosterDashboard extends StatefulWidget {
  const TaskPosterDashboard({super.key});

  @override
  _TaskPosterDashboardState createState() => _TaskPosterDashboardState();
}

class _TaskPosterDashboardState extends State<TaskPosterDashboard> {
  int _selectedIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);
  final DatabaseHandler dbHandler = DatabaseHandler();

  List<dynamic> tasks = [];
  String userName = 'User';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDataAndTasks();
  }

  Future<void> fetchUserDataAndTasks() async {
    try {
      final userId = await dbHandler.getCurrentUserId(); // Fetch the logged-in user ID
      if (userId == null) throw Exception("No user logged in.");

      final userData = await dbHandler.fetchUserById(userId);
      final fetchedTasks = await dbHandler.fetchTasks(userId);

      setState(() {
        userName = userData['username'] ?? 'User';
        tasks = fetchedTasks;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _showTaskCreationModal() {
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
        child: TaskCreationForm(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          const Center(
            child: Text("Tasks Page", style: TextStyle(color: AppColors.textPrimary)),
          ),
          _buildDashboardContent(screenWidth, screenHeight),
          const Center(
            child: Text("Settings Page", style: TextStyle(color: AppColors.textPrimary)),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: _onItemTapped,
      ),
    );
  }

  Widget _buildDashboardContent(double screenWidth, double screenHeight) {
    return Padding(
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
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                )
              : Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return _buildTaskCard(
                        task['title'],
                        task['status'],
                        task['due_date'],
                        screenWidth,
                      );
                    },
                  ),
                ),
        ],
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

  Widget _buildTaskCard(String title, String status, String dueDate, double screenWidth) {
    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04, horizontal: screenWidth * 0.045),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: screenWidth * 0.035,
                  ),
                ),
                Text(
                  dueDate,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: screenWidth * 0.035,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
