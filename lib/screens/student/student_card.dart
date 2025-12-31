import 'package:flutter/material.dart';

class StudentCard extends StatefulWidget {
  @override
  _StudentCardState createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard> {
  // Student data
  String name = 'Mohamed Ali';
  String studentId = 'STU102';
  String group = 'G2';
  String department = 'IFA';
  String email = 'mohamed@example.com';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade700, Colors.blue.shade500],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Constantine 2 University',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Student ID Card',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                SizedBox(height: 24),
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 80, color: Colors.blue.shade700),
                ),
                SizedBox(height: 24),
                _buildInfoRow('Name', name, Icons.person),
                _buildInfoRow('Student ID', studentId, Icons.badge),
                _buildInfoRow('Group', group, Icons.group),
                _buildInfoRow('Department', department, Icons.business),
                _buildInfoRow('Email', email, Icons.email),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _showEditProfileDialog,
                  icon: Icon(Icons.edit),
                  label: Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue.shade700,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Function to show edit profile dialog
  void _showEditProfileDialog() {
    final TextEditingController nameController = TextEditingController(text: name);
    final TextEditingController studentIdController = TextEditingController(text: studentId);
    final TextEditingController groupController = TextEditingController(text: group);
    final TextEditingController departmentController = TextEditingController(text: department);
    final TextEditingController emailController = TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.edit, color: Colors.blue.shade700),
              SizedBox(width: 8),
              Text('Edit Profile'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, 'Name', Icons.person),
                SizedBox(height: 16),
                _buildTextField(studentIdController, 'Student ID', Icons.badge),
                SizedBox(height: 16),
                _buildTextField(groupController, 'Group', Icons.group),
                SizedBox(height: 16),
                _buildTextField(departmentController, 'Department', Icons.business),
                SizedBox(height: 16),
                _buildTextField(emailController, 'Email', Icons.email),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  name = nameController.text;
                  studentId = studentIdController.text;
                  group = groupController.text;
                  department = departmentController.text;
                  email = emailController.text;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Profile updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
              ),
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to create text input fields
  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
      ),
    );
  }
}
