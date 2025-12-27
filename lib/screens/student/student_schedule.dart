import 'package:flutter/material.dart';

class StudentSchedule extends StatelessWidget {
  final List<Map<String, dynamic>> schedule = [
    {
      'day': 'Sunday',
      'sessions': [
        {'time': '08:00-10:00', 'course': 'DAM', 'room': 'A101'},
        {'time': '10:15-12:15', 'course': 'Database', 'room': 'B203'},
      ]
    },
    {
      'day': 'Monday',
      'sessions': [
        {'time': '08:00-10:00', 'course': 'Web Dev', 'room': 'C105'},
        {'time': '13:00-15:00', 'course': 'Mobile Dev', 'room': 'A201'},
      ]
    },
    {
      'day': 'Tuesday',
      'sessions': [
        {'time': '10:15-12:15', 'course': 'DAM', 'room': 'A101'},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          color: Colors.blue.shade700,
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.white),
              SizedBox(width: 12),
              Text(
                'My Schedule - Group G2',
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
            itemCount: schedule.length,
            itemBuilder: (context, index) {
              final day = schedule[index];
              return Card(
                margin: EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                      child: Text(
                        day['day'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                    ...List.generate(
                      (day['sessions'] as List).length,
                      (i) {
                        final session = day['sessions'][i];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.schedule, size: 20),
                            backgroundColor: Colors.blue.shade100,
                          ),
                          title: Text(
                            session['course'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Room ${session['room']}'),
                          trailing: Text(
                            session['time'],
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w600,
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
