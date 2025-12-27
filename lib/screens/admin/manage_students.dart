import 'package:flutter/material.dart';

class ManageStudents extends StatefulWidget {
  @override
  _ManageStudentsState createState() => _ManageStudentsState();
}

class _ManageStudentsState extends State<ManageStudents> {
  List<Map<String, dynamic>> pendingStudents = [
    {'name': 'Ahmed Benali', 'id': 'STU001', 'email': 'ahmed@example.com'},
    {'name': 'Fatima Zohra', 'id': 'STU002', 'email': 'fatima@example.com'},
    {'name': 'Karim Mahdi', 'id': 'STU003', 'email': 'karim@example.com'},
  ];

  List<Map<String, dynamic>> approvedStudents = [
    {'name': 'Sara Amira', 'id': 'STU101', 'email': 'sara@example.com', 'group': 'G1'},
    {'name': 'Mohamed Ali', 'id': 'STU102', 'email': 'mohamed@example.com', 'group': 'G2'},
    {'name': 'Yasmine Nour', 'id': 'STU103', 'email': 'yasmine@example.com', 'group': 'G1'},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.blue.shade700,
            child: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: 'Pending (${pendingStudents.length})'),
                Tab(text: 'Approved (${approvedStudents.length})'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildPendingList(),
                _buildApprovedList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: pendingStudents.length,
      itemBuilder: (context, index) {
        final student = pendingStudents[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(student['name'][0]),
              backgroundColor: Colors.orange,
            ),
            title: Text(student['name']),
            subtitle: Text('${student['id']} • ${student['email']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check, color: Colors.green),
                  onPressed: () => _approveStudent(index),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () => _rejectStudent(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildApprovedList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: approvedStudents.length,
      itemBuilder: (context, index) {
        final student = approvedStudents[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(student['name'][0]),
              backgroundColor: Colors.blue,
            ),
            title: Text(student['name']),
            subtitle: Text('${student['id']} • Group: ${student['group']}'),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(child: Text('Edit Group'), value: 'edit'),
                PopupMenuItem(child: Text('Delete'), value: 'delete'),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  _showGroupDialog(index);
                } else if (value == 'delete') {
                  _deleteStudent(index);
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _approveStudent(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Assign Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select a group for ${pendingStudents[index]['name']}'),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Group',
              ),
              items: ['G1', 'G2', 'G3', 'G4']
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                pendingStudents.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Student approved!')),
              );
            },
            child: Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _rejectStudent(int index) {
    setState(() {
      pendingStudents.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Student rejected')),
    );
  }

  void _showGroupDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Group'),
        content: DropdownButtonFormField<String>(
          value: approvedStudents[index]['group'],
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Group',
          ),
          items: ['G1', 'G2', 'G3', 'G4']
              .map((g) => DropdownMenuItem(value: g, child: Text(g)))
              .toList(),
          onChanged: (value) {
            setState(() {
              approvedStudents[index]['group'] = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteStudent(int index) {
    setState(() {
      approvedStudents.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Student deleted')),
    );
  }
}