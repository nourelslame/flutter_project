import 'package:flutter/material.dart';
import '../../services/database_service.dart';

class TeacherAttendance extends StatefulWidget {
  @override
  _TeacherAttendanceState createState() => _TeacherAttendanceState();
}

class _TeacherAttendanceState extends State<TeacherAttendance> {
  String selectedCourse = 'DAM';
  String selectedGroup = 'G1';
  String selectedWeek = 'Week 1';

  // Changed: Now empty, will be filled from database
  List<Map<String, dynamic>> students = [];

  // ADDED: Database service and loading state
  DatabaseService db = DatabaseService();
  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadStudents(); // Load real students when screen opens
  }

  Future<void> _loadStudents() async {
    setState(() => isLoading = true);

    try {
      // Try to get REAL students from database
      students = await db.getStudentsInGroup(selectedGroup);

      // Initialize all as present by default
      for (var student in students) {
        student['present'] = true; // Default to present
      }

      setState(() => isLoading = false);
      print("Loaded ${students.length} real students");
    } catch (e) {
      print("Database error: $e");

      // FALLBACK: Use fake data if database fails
      students = [
        {'name': 'Ahmed Benali', 'id': 'STU001', 'present': true},
        {'name': 'Sara Amira', 'id': 'STU101', 'present': true},
        {'name': 'Mohamed Ali', 'id': 'STU102', 'present': false},
        {'name': 'Yasmine Nour', 'id': 'STU103', 'present': true},
      ];

      setState(() => isLoading = false);
      print("Using fake data (database error)");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while fetching data
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          color: Colors.green.shade50,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedCourse,
                      decoration: InputDecoration(
                        labelText: 'Course',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: ['DAM', 'Mobile Dev']
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCourse = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedGroup,
                      decoration: InputDecoration(
                        labelText: 'Group',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: ['G1', 'G2']
                          .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGroup = value!;
                        });
                        _loadStudents(); // Reload students for new group
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedWeek,
                decoration: InputDecoration(
                  labelText: 'Week',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: List.generate(
                  12,
                      (i) => DropdownMenuItem(
                    value: 'Week ${i + 1}',
                    child: Text('Week ${i + 1}'),
                  ),
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedWeek = value!;
                  });
                  // TODO: Load existing attendance for this week
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mark Attendance - $selectedWeek',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Present: ${students.where((s) => s['present']).length}/${students.length}',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(student['name'][0]),
                    backgroundColor: student['present']
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                  ),
                  title: Text(student['name']),
                  subtitle: Text(student['id'] ?? student['studentId'] ?? 'No ID'),
                  trailing: Switch(
                    value: student['present'],
                    onChanged: (value) {
                      setState(() {
                        students[index]['present'] = value;
                      });
                    },
                    activeColor: Colors.green,
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSaving ? null : _saveAttendance,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: isSaving
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                'Save Attendance',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveAttendance() async {
    if (students.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No students to save')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      // Convert "Week 1" to number 1
      int weekNumber = int.parse(selectedWeek.replaceAll('Week ', ''));

      // Save each student's attendance
      for (var student in students) {
        await db.markAttendance(
          courseId: selectedCourse,
          groupId: selectedGroup,
          studentId: student['id'] ?? 'unknown',
          weekNumber: weekNumber,
          present: student['present'] ?? true,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Attendance saved for $selectedWeek'),
          backgroundColor: Colors.green,
        ),
      );

      print("Saved attendance for ${students.length} students");
    } catch (e) {
      print("Save error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isSaving = false);
    }
  }
}
