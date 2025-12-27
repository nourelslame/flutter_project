import 'package:flutter/material.dart';

class TeacherMarks extends StatefulWidget {
  @override
  _TeacherMarksState createState() => _TeacherMarksState();
}

class _TeacherMarksState extends State<TeacherMarks> {
  String selectedCourse = 'DAM';
  String selectedGroup = 'G1';
  String selectedMarkType = 'TD';

  List<Map<String, dynamic>> students = [
    {'name': 'Ahmed Benali', 'id': 'STU001', 'marks': {'TD': 15, 'TP': 18}},
    {'name': 'Sara Amira', 'id': 'STU101', 'marks': {'TD': 16, 'TP': 17}},
    {'name': 'Mohamed Ali', 'id': 'STU102', 'marks': {'TD': 14, 'TP': 19}},
    {'name': 'Yasmine Nour', 'id': 'STU103', 'marks': {'TD': 17, 'TP': 16}},
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
                value: selectedMarkType,
                decoration: InputDecoration(
                  labelText: 'Mark Type',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: ['TD', 'TP', 'Exam']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMarkType = value!;
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              final currentMark = student['marks'][selectedMarkType] ?? 0;
              
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(student['name'][0]),
                    backgroundColor: Colors.green.shade100,
                  ),
                  title: Text(student['name']),
                  subtitle: Text(student['id']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: currentMark >= 10
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$currentMark/20',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: currentMark >= 10
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editMark(index, currentMark),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _editMark(int studentIndex, int currentMark) {
    final TextEditingController markController =
        TextEditingController(text: currentMark.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Mark'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Student: ${students[studentIndex]['name']}'),
            Text('Mark Type: $selectedMarkType'),
            SizedBox(height: 16),
            TextFormField(
              controller: markController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Mark (out of 20)',
                border: OutlineInputBorder(),
                suffixText: '/20',
              ),
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
              int newMark = int.tryParse(markController.text) ?? 0;
              if (newMark >= 0 && newMark <= 20) {
                setState(() {
                  students[studentIndex]['marks'][selectedMarkType] = newMark;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mark updated successfully')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mark must be between 0 and 20')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
            ),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}