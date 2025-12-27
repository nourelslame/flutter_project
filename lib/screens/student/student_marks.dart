import 'package:flutter/material.dart';

class StudentMarks extends StatelessWidget {
  final List<Map<String, dynamic>> marks = [
    {
      'course': 'DAM',
      'marks': [
        {'type': 'TD', 'score': 15, 'max': 20},
        {'type': 'TP', 'score': 18, 'max': 20},
        {'type': 'Exam', 'score': 14, 'max': 20},
      ]
    },
    {
      'course': 'Database',
      'marks': [
        {'type': 'TD', 'score': 16, 'max': 20},
        {'type': 'TP', 'score': 17, 'max': 20},
      ]
    },
    {
      'course': 'Web Dev',
      'marks': [
        {'type': 'TD', 'score': 14, 'max': 20},
        {'type': 'TP', 'score': 19, 'max': 20},
        {'type': 'Exam', 'score': 15, 'max': 20},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          color: Colors.green.shade700,
          child: Row(
            children: [
              Icon(Icons.grade, color: Colors.white),
              SizedBox(width: 12),
              Text(
                'My Marks',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: marks.length,
            itemBuilder: (context, index) {
              final course = marks[index];
              double total = 0;
              int count = 0;
              for (var mark in course['marks']) {
                total += (mark['score'] / mark['max']) * 20;
                count++;
              }
              double average = count > 0 ? total / count : 0;

              return Card(
                margin: EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            course['course'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: average >= 10
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Avg: ${average.toStringAsFixed(2)}/20',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...List.generate(
                      (course['marks'] as List).length,
                      (i) {
                        final mark = course['marks'][i];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(mark['type'][0]),
                            backgroundColor: Colors.green.shade100,
                          ),
                          title: Text(mark['type']),
                          trailing: Text(
                            '${mark['score']}/${mark['max']}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        );
                      },
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
}