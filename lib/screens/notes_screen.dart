import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, String>> _pdfFiles = []; // Store file name and URL

  @override
  void initState() {
    super.initState();
    _loadPdfUrls();
  }

  Future<void> _loadPdfUrls() async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('notes');
      final listResult = await storageRef.listAll();

      List<Map<String, String>> files = [];
      for (var item in listResult.items) {
        String url = await item.getDownloadURL();
        String name = item.name; // Get the file name
        files.add({'name': name, 'url': url});
      }

      setState(() {
        _pdfFiles = files;
      });
    } catch (e) {
      print('Error loading file URLs: $e');
    }
  }

  Future<void> _uploadPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    
    if (result != null) {
      File file = File(result.files.single.path!);
      try {
        final storageRef = FirebaseStorage.instance.ref().child('notes/${result.files.single.name}');
        await storageRef.putFile(file);

        // Refresh the list of PDFs after upload
        await _loadPdfUrls();
      } catch (e) {
        print('Error uploading file: $e');
      }
    }
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      // Handle permission denied case
      print('Storage permission not granted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        backgroundColor: const Color.fromARGB(255, 151, 189, 255), // Update to your preferred color
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _pdfFiles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_pdfFiles[index]['name'] ?? 'Unknown'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfViewerScreen(pdfUrl: _pdfFiles[index]['url']!),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                await _requestPermissions();
                _uploadPdf();
              },
              child: Text('Upload Notes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 161, 196, 255), // Update to your preferred color
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PdfViewerScreen extends StatelessWidget {
  final String pdfUrl;

  PdfViewerScreen({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
        backgroundColor: Colors.blueAccent, // Update to your preferred color
      ),
      body: SfPdfViewer.network(pdfUrl),
    );
  }
}
