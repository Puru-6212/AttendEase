import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'login_screen.dart';
import 'attendance_sheet_screen.dart';
import 'notes_screen.dart'; // Import the new notes screen

class TeacherDashboard extends StatelessWidget {
  final List<String> subjects = [
    'Subject 1',
    'Subject 2',
    'Subject 3',
    'Subject 4',
    'Subject 5',
  ];

  void _showOptions(BuildContext context, String subject) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Options for $subject',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: Icon(Icons.check_box),
                title: Text('Attendance'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _navigateToAttendanceSheet(context, subject);
                },
              ),
              ListTile(
                leading: Icon(Icons.note),
                title: Text('Notes'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _navigateToNotesScreen(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToAttendanceSheet(BuildContext context, String subject) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceSheetScreen(subject: subject),
      ),
    );
  }

  void _navigateToNotesScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotesScreen(), // Navigate to the notes screen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userModel = userProvider.user!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Dashboard'),
        backgroundColor: const Color.fromARGB(255, 156, 210, 255),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              userProvider.clearUser();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen(role: 'Teacher')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${userModel.email}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20),
            Text(
              'Select a Subject:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () => _showOptions(context, subjects[index]),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Color.fromARGB(255, 105, 183, 252),
                      ),
                      child: Text(
                        subjects[index],
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
