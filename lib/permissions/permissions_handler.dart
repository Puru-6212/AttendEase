// permissions_handler.dart
import 'package:permission_handler/permission_handler.dart';

class PermissionsHandler {
  /// Requests the necessary permissions for the app.
  static Future<void> requestPermissions() async {
    // Check and request storage permission
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    // Optionally handle other permissions if needed
    // e.g., camera, location, etc.
  }
}
