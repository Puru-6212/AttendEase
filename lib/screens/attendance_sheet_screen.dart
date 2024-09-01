import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AttendanceSheetScreen extends StatefulWidget {
  final String subject;

  AttendanceSheetScreen({required this.subject});

  @override
  _AttendanceSheetScreenState createState() => _AttendanceSheetScreenState();
}

class _AttendanceSheetScreenState extends State<AttendanceSheetScreen> {
  final List<Map<String, dynamic>> students = [
    {'rollNo': '68', 'name': 'AKRITI JHA', 'status': false},
    {'rollNo': '69', 'name': 'AKSHAT AGRAWAL', 'status': false},
    {'rollNo': '70', 'name': 'ANAMIKA KUMARI', 'status': false},
    {'rollNo': '71', 'name': 'ANIMESH KUMAR', 'status': false},
    {'rollNo': '73', 'name': 'ANUJ KUMAR', 'status': false},
    {'rollNo': '74', 'name': 'ANURAG GUPTA', 'status': false},
    {'rollNo': '75', 'name': 'ARTI KUMARI GUPTA', 'status': false},
    {'rollNo': '78', 'name': 'DESHRAJ GURJAR', 'status': false},
    {'rollNo': '79', 'name': 'DHARMENDRA PRAKASH PRAJAPATI', 'status': false},
    {'rollNo': '80', 'name': 'HANSRAJ SINGH RAWAT', 'status': false},
    {'rollNo': '81', 'name': 'MOHIT KUMAR', 'status': false},
    {'rollNo': '82', 'name': 'NAVJEEVAN KUMAR', 'status': false},
    {'rollNo': '83', 'name': 'PURNASISH PATTNAYAK', 'status': false},
    {'rollNo': '84', 'name': 'PURU JINDAL', 'status': false},
    {'rollNo': '85', 'name': 'RATNAVATH SANA', 'status': false},
    {'rollNo': '86', 'name': 'RITIKA KUMARI', 'status': false},
    {'rollNo': '87', 'name': 'SAGAR PANTHA', 'status': false},
    {'rollNo': '88', 'name': 'SAKSHAM KUMAR', 'status': false},
    {'rollNo': '89', 'name': 'SAMUEL NAMGYAL BHUTIA', 'status': false},
    {'rollNo': '91', 'name': 'SHORABH SINGH', 'status': false},
    {'rollNo': '92', 'name': 'SHRUTEE SONTAKKE', 'status': false},
    {'rollNo': '93', 'name': 'SIDDARTH RAI', 'status': false},
    {'rollNo': '94', 'name': 'SUJEET PATEL', 'status': false},
    {'rollNo': '96', 'name': 'VISHWAJEET KUMAR', 'status': false},
  ];

  final String _databaseUrl = 'attendease-e07ce-default-rtdb.firebaseio.com';

  Future<void> _saveAttendance() async {
    Map<String, String> attendanceMap = {};
    for (var student in students) {
      attendanceMap[student['rollNo']] = student['status'] ? 'present' : 'absent';
    }

    final String dateTime = DateTime.now().toIso8601String();
    final String classID = widget.subject;

    final data = {
      'dateTime': dateTime,
      'students': attendanceMap,
    };

    final url = Uri.https(_databaseUrl, 'classes/$classID.json');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attendance saved for ${widget.subject}')),
        );
      } else {
        throw Exception('Failed to save attendance');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save attendance: $e')),
      );
    }

    // For development purposes, print attendance status to console
    students.forEach((student) {
      print('${student['name']} is ${student['status'] ? 'Present' : 'Absent'}');
    });
  }

  Future<void> _fetchAttendance() async {
    final String classID = widget.subject;
    final url = Uri.https(_databaseUrl, 'classes/$classID.json');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final List<Map<String, dynamic>> fetchedStudents = [];

        data.forEach((key, value) {
          final studentsData = value['students'] as Map<String, dynamic>;
          studentsData.forEach((rollNo, status) {
            fetchedStudents.add({
              'rollNo': rollNo,
              'name': '', // You might need to fetch names separately or have them stored
              'status': status == 'present',
            });
          });
        });

        setState(() {
          // Update your student list with fetched data
          // Note: You might need to merge or handle duplicates if necessary
        });
      } else {
        throw Exception('Failed to fetch attendance');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch attendance: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAttendance(); // Fetch attendance data when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance for ${widget.subject}'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Reduced padding for more space
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 30.0, // Adjust column spacing for fitting data
                  columns: [
                    DataColumn(label: Text('R.No')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: students.map((student) {
                    return DataRow(cells: [
                      DataCell(Text(student['rollNo'])),
                      DataCell(Text(student['name'])),
                      DataCell(
                        Switch(
                          value: student['status'],
                          onChanged: (value) {
                            setState(() {
                              student['status'] = value;
                            });
                          },
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.red,
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAttendance,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.blue[600],
              ),
              child: Text('Save Attendance', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
