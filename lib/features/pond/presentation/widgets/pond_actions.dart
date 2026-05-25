import 'package:flutter/material.dart';

Future<bool> confirmDelete(BuildContext context, String text) async {
  return await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Confirm"),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete"),
            ),
          ],
        ),
      ) ??
      false;
}
