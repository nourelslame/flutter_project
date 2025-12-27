import 'package:flutter/material.dart';

class ManageSchedules extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Schedules & Files',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _buildUploadCard(
            context,
            'Upload Timetable',
            'Upload schedule images for groups',
            Icons.calendar_today,
            Colors.blue,
          ),
          _buildUploadCard(
            context,
            'Upload Documents',
            'Upload course materials and files',
            Icons.description,
            Colors.green,
          ),
          _buildUploadCard(
            context,
            'Exam Schedule',
            'Upload exam timetables',
            Icons.assignment,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildUploadCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File picker will open here')),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, color: color, size: 30),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Icon(Icons.upload_file, color: color),
            ],
          ),
        ),
      ),
    );
  }
}