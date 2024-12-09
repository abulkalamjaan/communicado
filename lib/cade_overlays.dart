import 'package:flutter/material.dart';

class CadeOverlays {

  /// [CadeOverlays] is a class that provides a set of overlay widgets for Flutter.
  /// It provides a set of methods to show loading, warning, and error dialogs.
  /// It also provides a method to show a loading overlay on the screen.
  static final CadeOverlays _instance = CadeOverlays._privateConstructor();
  factory CadeOverlays() => _instance;
  CadeOverlays._privateConstructor();


  static CadeOverlays get instance => _instance;

  OverlayEntry showLoading({
    required BuildContext context,
  }) {
    OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => const Material(
              color: Colors.white24,
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ));
    Overlay.of(context).insert(overlayEntry);

    return overlayEntry;
  }

  /// Show a dialog with a [title] and [warning]. Returns a Future<void>.
  static Future<void> showWarningDialog({
    required BuildContext context,
    required String title,
    String? warning,
    IconData icon = Icons.warning,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          icon: Icon(
            icon,
            size: 40,
            color: Colors.yellow,
          ),
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          content: Text(warning ?? "A warning occurred"),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  /// Show a dialog with a [title] and [error]. Returns a Future<void>.
  showError(
      {
      /// The context of the application to show the dialog.
      required BuildContext context,

      /// The title of the dialog.
      required String title,

      /// The error message to be shown in the dialog.
      String? error,

      /// The icon to be shown in the dialog.
      IconData icon = Icons.error}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(title),
          icon: Icon(
            icon,
            size: 40,
            color: Colors.red,
          ),
          titleTextStyle: const TextStyle(
            color: Colors.red,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          content: Text(error ?? "An error occurred"),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            )
          ],
        );
      },
    );
  }
}
