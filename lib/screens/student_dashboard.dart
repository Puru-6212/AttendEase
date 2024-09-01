import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'login_screen.dart';

class StudentDashboard extends StatelessWidget {
  final List<Map<String, String>> attendanceRecords = [
    {'classId': 'class123', 'date': '2024-09-01', 'status': 'Present'},
    {'classId': 'class124', 'date': '2024-09-01', 'status': 'Absent'},
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userModel = userProvider.user!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Student Dashboard'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              userProvider.clearUser();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen(role: 'Student',)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Hello, ${userModel.email}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20),
            ...attendanceRecords.map((record) {
              return Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text('Class ID: ${record['classId']}'),
                  subtitle: Text('Date: ${record['date']} - Status: ${record['status']}'),
                  trailing: Icon(
                    record['status'] == 'Present' ? Icons.check_circle : Icons.cancel,
                    color: record['status'] == 'Present' ? Colors.green : Colors.red,
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
