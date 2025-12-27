import 'package:flutter/material.dart';

class StudentCourses extends StatelessWidget {
  final List<Map<String, dynamic>> courses = [
    {
      'name': 'DAM',
      'teacher': 'Dr. Amina Karim',
      'files': [
        {'name': 'Chapter 1 - Flutter Basics.pdf', 'date': '2025-01-15'},
        {'name': 'TP 1 - First App.pdf', 'date': '2025-01-20'},
      ]
    },
    {
      'name': 'Database',
      'teacher': 'Dr. Salima Nour',
      'files': [
        {'name': 'SQL Introduction.pdf', 'date': '2025-01-12'},
        {'name': 'ER Diagrams.pdf', 'date': '2025-01-18'},
      ]
    },
    {
      'name': 'Web Dev',
      'teacher': 'Prof. Youcef Hamid',
      'files': [
        {'name': 'HTML & CSS Basics.pdf', 'date': '2025-01-10'},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            leading: CircleAvatar(
              child: Icon(Icons.book),
              backgroundColor: Colors.orange.shade100,
            ),
            title: Text(
              course['name'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(course['teacher']),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Course Materials',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 12),
                    ...List.generate(
                      (course['files'] as List).length,
                      (i) {
                        final file = course['files'][i];
                        return Card(
                          margin: EdgeInsets.only(bottom: 8),
                          color: Colors.grey.shade50,
                          child: ListTile(
                            leading: Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                            ),
                            title: Text(file['name']),
                            subtitle: Text('Uploaded: ${file['date']}'),
                            trailing: IconButton(
                              icon: Icon(Icons.download),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Downloading ${file['name']}'),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}