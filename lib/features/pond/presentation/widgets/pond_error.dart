import 'package:flutter/material.dart';

class PondError extends StatelessWidget {
  final VoidCallback onRetry;

  const PondError({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
            const SizedBox(height: 10),
            const Text(
              "Failed to load ponds",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
          ],
        ),
      ),
    );
  }
}
