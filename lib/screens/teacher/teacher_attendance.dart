import 'package:flutter/material.dart';

class TeacherAttendance extends StatefulWidget {
  @override
  _TeacherAttendanceState createState() => _TeacherAttendanceState();
}

class _TeacherAttendanceState extends State<TeacherAttendance> {
  String selectedCourse = 'DAM';
  String selectedGroup = 'G1';
  String selectedWeek = 'Week 1';

  List<Map<String, dynamic>> students = [
    {'name': 'Ahmed Benali', 'id': 'STU001', 'present': true},
    {'name': 'Sara Amira', 'id': 'STU101', 'present': true},
    {'name': 'Mohamed Ali', 'id': 'STU102', 'present': false},
    {'name': 'Yasmine Nour', 'id': 'STU103', 'present': true},
  ];

  @override
  Widget build(BuildContext context) {
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
                  subtitle: Text(student['id']),
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
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Attendance saved for $selectedWeek'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Save Attendance',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}