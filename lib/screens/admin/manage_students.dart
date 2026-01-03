import 'package:flutter/material.dart';
import '../../services/database_service.dart';

class ManageStudents extends StatefulWidget {
  @override
  _ManageStudentsState createState() => _ManageStudentsState();
}

class _ManageStudentsState extends State<ManageStudents> {
  DatabaseService _dbService = DatabaseService(); //

  // use empty lists to fill from Firebase
  List<Map<String, dynamic>> pendingStudents = [];
  List<Map<String, dynamic>> approvedStudents = [];

  bool isLoading = true;
  String? selectedGroup; //store selected group in approval dialog

  @override
  void initState() {
    super.initState();
    _loadStudents(); //
  }

  Future<void> _loadStudents() async {
    setState(() {
      isLoading = true;
    });

    final pending = await _dbService.getStudents(false);
    final approved = await _dbService.getStudents(true);

    setState(() {
      pendingStudents = pending;
      approvedStudents = approved;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

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
    if (pendingStudents.isEmpty) {
      return Center(child: Text('No pending students'));
    }

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
                  onPressed: () => _approveStudent(index), //
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () => _rejectStudent(index), //
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildApprovedList() {
    if (approvedStudents.isEmpty) {
      return Center(child: Text('No approved students yet'));
    }

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
            subtitle:
            Text('${student['id']} • Group: ${student['group'] ?? 'Not set'}'),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(child: Text('Edit Group'), value: 'edit'),
                PopupMenuItem(child: Text('Delete'), value: 'delete'),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  _showGroupDialog(index); //
                } else if (value == 'delete') {
                  _deleteStudent(index); //
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _approveStudent(int index) {
    final student = pendingStudents[index];
    String? selectedGroup = 'G1'; // default value

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Assign Group'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Select a group for ${student['name']}'),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Group',
                    ),
                    items: ['G1', 'G2', 'G3', 'G4']
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGroup = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedGroup == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select a group first!')),
                      );
                      return;
                    }

                    await _dbService.approveStudent(student['id'], selectedGroup!);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${student['name']} approved!')),
                    );
                    await _loadStudents(); // Refresh lists after approval
                  },
                  child: Text('Approve'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _rejectStudent(int index) {
    final student = pendingStudents[index];
    setState(() {
      pendingStudents.removeAt(index); //
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${student['name']} rejected')),
    );
  }

  void _showGroupDialog(int index) {
    final student = approvedStudents[index];
    String? newGroup = student['group'] ?? 'G1';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Group'),
        content: DropdownButtonFormField<String>(
          value: newGroup,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Group',
          ),
          items: ['G1', 'G2', 'G3', 'G4']
              .map((g) => DropdownMenuItem(value: g, child: Text(g)))
              .toList(),
          onChanged: (value) {
            newGroup = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              //  update student's group in Firebase
              if (newGroup != null) {
                await _dbService.approveStudent(student['id'], newGroup!);
                await _loadStudents(); // refresh lists
              }
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteStudent(int index) {
    final student = approvedStudents[index];
    setState(() {
      approvedStudents.removeAt(index); //
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${student['name']} deleted')),
    );
  }
}
