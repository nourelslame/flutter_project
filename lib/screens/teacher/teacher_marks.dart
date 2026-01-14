import 'package:flutter/material.dart';
import '../../services/database_service.dart';

class TeacherMarks extends StatefulWidget {
  @override
  _TeacherMarksState createState() => _TeacherMarksState();
}

class _TeacherMarksState extends State<TeacherMarks> {
  String selectedCourse = 'DAM';
  String selectedGroup = 'G1';
  String selectedMarkType = 'TD';

  DatabaseService db = DatabaseService();
  List<Map<String, dynamic>> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() => isLoading = true);

    try {
      students = await db.getStudentsInGroup(selectedGroup);
    } catch (e) {
      print("Error: $e");
      students = [
        {'name': 'Ahmed Benali', 'id': 'STU001'},
        {'name': 'Sara Amira', 'id': 'STU101'},
      ];
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // SIMPLE CONTROLS
        Container(
          padding: EdgeInsets.all(16),
          color: Colors.blue.shade50,
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
                      ),
                      items: ['DAM', 'Database']
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (value) {
                        setState(() => selectedCourse = value!);
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedMarkType,
                      decoration: InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(),
                      ),
                      items: ['TD', 'TP', 'Exam']
                          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (value) {
                        setState(() => selectedMarkType = value!);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // STUDENT LIST WITH MARKS
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return _buildStudentCard(student, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student, int index) {
    TextEditingController markController = TextEditingController();

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(student['name'][0]),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(student['id'] ?? 'No ID', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: markController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Mark /20',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => _saveMark(student, markController.text),
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveMark(Map<String, dynamic> student, String markText) async {
    double mark = double.tryParse(markText) ?? 0;

    if (mark < 0 || mark > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mark must be 0-20')),
      );
      return;
    }

    try {
      await db.addMark(
        studentId: student['id'],
        courseId: selectedCourse,
        markType: selectedMarkType,
        score: mark,
        maxScore: 20.0,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(' Mark saved for ${student['name']}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
