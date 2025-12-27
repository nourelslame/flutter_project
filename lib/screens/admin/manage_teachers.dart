import 'package:flutter/material.dart';

class ManageTeachers extends StatefulWidget {
  @override
  _ManageTeachersState createState() => _ManageTeachersState();
}

class _ManageTeachersState extends State<ManageTeachers> {
  List<Map<String, dynamic>> teachers = [
    {'name': 'Dr. Amina Karim', 'courses': ['DAM', 'Mobile Dev'], 'groups': ['G1', 'G2']},
    {'name': 'Prof. Youcef Hamid', 'courses': ['Web Dev'], 'groups': ['G3']},
    {'name': 'Dr. Salima Nour', 'courses': ['Database'], 'groups': ['G1', 'G4']},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: _showAssignDialog,
            icon: Icon(Icons.add),
            label: Text('Assign Course to Teacher'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: teachers.length,
            itemBuilder: (context, index) {
              final teacher = teachers[index];
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    child: Text(teacher['name'][0]),
                    backgroundColor: Colors.green,
                  ),
                  title: Text(teacher['name']),
                  subtitle: Text('${teacher['courses'].length} courses'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Courses:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: (teacher['courses'] as List)
                                .map((c) => Chip(label: Text(c)))
                                .toList(),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Groups:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: (teacher['groups'] as List)
                                .map((g) => Chip(
                                      label: Text(g),
                                      backgroundColor: Colors.blue.shade100,
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

 void _showAssignDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Assign Course & Group'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Teacher',
            ),
            items: teachers
                .map<DropdownMenuItem<String>>((t) {
              return DropdownMenuItem<String>(
                value: t['name'].toString(),
                child: Text(t['name'].toString()),
              );
            }).toList(),
            onChanged: (value) {},
          ),

          SizedBox(height: 16),

          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Course Name',
            ),
          ),

          SizedBox(height: 16),

          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Group',
            ),
            items: ['G1', 'G2', 'G3', 'G4']
                .map<DropdownMenuItem<String>>(
                  (g) => DropdownMenuItem<String>(
                    value: g,
                    child: Text(g),
                  ),
                )
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
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Course assigned!')),
            );
          },
          child: Text('Assign'),
        ),
      ],
    ),
  );
}
}