import 'package:flutter/material.dart';

class StudentDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.blue.shade500],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Mohamed Ali • STU102',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Access',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickCard(
                        'My Schedule',
                        Icons.calendar_today,
                        Colors.blue,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickCard(
                        'My Marks',
                        Icons.grade,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickCard(
                        'My Courses',
                        Icons.book,
                        Colors.orange,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickCard(
                        'Student ID',
                        Icons.badge,
                        Colors.purple,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  'Recent Announcements',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                _buildAnnouncementCard(
                  'Exam Schedule Updated',
                  'Final exams schedule has been posted',
                  '2 hours ago',
                  Icons.assignment,
                ),
                _buildAnnouncementCard(
                  'New Course Materials',
                  'DAM course materials uploaded',
                  '1 day ago',
                  Icons.upload_file,
                ),
                _buildAnnouncementCard(
                  'Holiday Notice',
                  'Campus closed on Friday',
                  '3 days ago',
                  Icons.event,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCard(String title, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard(
    String title,
    String description,
    String time,
    IconData icon,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(icon, color: Colors.blue.shade700),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Text(
          time,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
}