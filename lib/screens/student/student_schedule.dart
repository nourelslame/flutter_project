import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/database_service.dart';

class StudentSchedule extends StatefulWidget {
  @override
  _StudentScheduleState createState() => _StudentScheduleState();
}

class _StudentScheduleState extends State<StudentSchedule> {
  List<Map<String, dynamic>> schedule = [];
  DatabaseService db = DatabaseService();
  bool isLoading = true;
  String studentGroup = 'G1';

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    setState(() => isLoading = true);

    try {
      // Get student's group
      final userData = await db.getCurrentUserData();
      studentGroup = userData?['group'] ?? 'G1';

      // Get schedule from Firebase
      schedule = await _getScheduleFromFirebase(studentGroup);

      // If empty, use fake data
      if (schedule.isEmpty) {
        schedule = _getFakeSchedule();
      }
    } catch (e) {
      schedule = _getFakeSchedule();
    }

    setState(() => isLoading = false);
  }

  // Get schedule from Firebase
  Future<List<Map<String, dynamic>>> _getScheduleFromFirebase(String group) async {
    try {
      final firestore = FirebaseFirestore.instance;

      final snapshot = await firestore
          .collection('schedules')
          .where('groupId', isEqualTo: group)
          .get();

      List<Map<String, dynamic>> result = [];
      for (var doc in snapshot.docs) {
        result.add(doc.data() as Map<String, dynamic>);
      }
      return result;
    } catch (e) {
      return [];
    }
  }

  // Fake schedule
  List<Map<String, dynamic>> _getFakeSchedule() {
    return [
      {'day': 'Sunday', 'time': '08:00-10:00', 'course': 'DAM', 'room': 'A101'},
      {'day': 'Sunday', 'time': '10:15-12:15', 'course': 'Database', 'room': 'B203'},
      {'day': 'Monday', 'time': '08:00-10:00', 'course': 'Web Dev', 'room': 'C105'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // HEADER
        Container(
          padding: EdgeInsets.all(16),
          color: Colors.blue.shade700,
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.white),
              SizedBox(width: 12),
              Text(
                'Schedule - Group $studentGroup',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // SCHEDULE LIST
        Expanded(
          child: schedule.isEmpty
              ? Center(child: Text('No schedule'))
              : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: schedule.length,
            itemBuilder: (context, index) {
              final session = schedule[index];
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(Icons.schedule, color: Colors.blue),
                  title: Text(session['course'], style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${session['day']} • Room ${session['room']}'),
                  trailing: Text(session['time'], style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                ),
              );
            },
          ),
        ),

        // REFRESH BUTTON
        Padding(
          padding: EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _loadSchedule,
            child: Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ),
      ],
    );
  }
}
