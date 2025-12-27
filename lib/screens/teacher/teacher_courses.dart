import 'package:flutter/material.dart';

class TeacherCourses extends StatefulWidget {
  @override
  _TeacherCoursesState createState() => _TeacherCoursesState();
}

class _TeacherCoursesState extends State<TeacherCourses> {
  List<Map<String, dynamic>> courses = [
    {
      'name': 'DAM',
      'groups': ['G1', 'G2'],
      'files': [
        {'name': 'Chapter 1 - Flutter Basics.pdf', 'date': '2025-01-15'},
        {'name': 'TP 1 - First App.pdf', 'date': '2025-01-20'},
      ]
    },
    {
      'name': 'Mobile Dev',
      'groups': ['G2'],
      'files': [
        {'name': 'React Native Intro.pdf', 'date': '2025-01-10'},
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
              backgroundColor: Colors.green.shade100,
            ),
            title: Text(
              course['name'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text('Groups: ${(course['groups'] as List).join(', ')}'),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Course Materials',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _uploadFile(index),
                          icon: Icon(Icons.upload_file, size: 18),
                          label: Text('Upload'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    if ((course['files'] as List).isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'No files uploaded yet',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    else
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
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteFile(index, i),
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

  void _uploadFile(int courseIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Upload File'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select a file to upload for this course'),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('File picker will open here')),
                );
              },
              icon: Icon(Icons.folder_open),
              label: Text('Choose File'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _deleteFile(int courseIndex, int fileIndex) {
    setState(() {
      courses[courseIndex]['files'].removeAt(fileIndex);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('File deleted')),
    );
  }
}