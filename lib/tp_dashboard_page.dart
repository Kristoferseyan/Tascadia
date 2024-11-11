import 'package:flutter/material.dart';
import 'nav_bar.dart';

class TaskPosterDashboard extends StatefulWidget {
  @override
  _TaskPosterDashboardState createState() => _TaskPosterDashboardState();
}

class _TaskPosterDashboardState extends State<TaskPosterDashboard> {
  int _selectedIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1F2B),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          Center(child: Text("Tasks Page", style: TextStyle(color: Colors.white))),
          _buildDashboardContent(screenWidth, screenHeight),
          Center(child: Text("Settings Page", style: TextStyle(color: Colors.white))),
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
          horizontal: screenWidth * 0.04, vertical: screenHeight * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: screenWidth * 0.06,
                backgroundColor: Color(0xFFF9C270),
                child: Icon(Icons.person, color: Colors.white, size: screenWidth * 0.06),
              ),
              SizedBox(width: screenWidth * 0.03),
              Text(
                "Welcome, Sean!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.white, size: screenWidth * 0.07),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.03),

          Text(
            "Categories",
            style: TextStyle(
              color: Color(0xFFF9C270),
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
                  color: Color(0xFFF9C270),
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle, color: Color(0xFFF9C270), size: screenWidth * 0.07),
                onPressed: () {
                  
                },
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.015),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildTaskCard("Design a Logo", "In Progress", "Due: Nov 15", screenWidth),
                _buildTaskCard("House Cleaning", "Pending", "Due: Nov 20", screenWidth),
                _buildTaskCard("Grocery Delivery", "Completed", "Due: Nov 10", screenWidth),
              ],
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
        backgroundColor: const Color(0xFF2A2B39),
        avatar: Icon(icon, color: const Color(0xFFF9C270), size: screenWidth * 0.045),
        label: Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.04),
        ),
      ),
    );
  }

  Widget _buildTaskCard(String title, String status, String dueDate, double screenWidth) {
    return Card(
      color: const Color(0xFF2A2B39),
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
                color: Colors.white,
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
                    color: Color(0xFFF9C270),
                    fontSize: screenWidth * 0.035,
                  ),
                ),
                Text(
                  dueDate,
                  style: TextStyle(
                    color: Colors.white70,
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
