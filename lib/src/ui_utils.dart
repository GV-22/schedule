import 'package:flutter/material.dart';

abstract class UiUtils {
  static void customAltertDialog(
    BuildContext context,
    String title,
    String message, {
    List<Widget>? actions,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext bCtx) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: actions,
        );
      },
    );
  }

  static Future<bool> showConfirmationDialog(
    BuildContext context,
    String message,
  ) async {
    bool result = false;
    await showDialog(
      context: context,
      builder: (BuildContext bCtx) {
        return AlertDialog(
          title: const Text(
            "Confirmation",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                result = true;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "No",
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );

    return result;
  }

  static void customSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: const TextStyle(fontSize: 13, color: Colors.white),
          // softWrap: true,
        ),
      ),
    );
  }
}
