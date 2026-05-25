import 'package:flutter/material.dart';

class PondEmpty extends StatelessWidget {
  final VoidCallback? onAdd; // ✅ nullable

  const PondEmpty({super.key, this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ////////////////////////////////////////////////////////////
            /// ICON
            ////////////////////////////////////////////////////////////
            const Icon(
              Icons.water_drop_outlined,
              size: 64,
              color: Colors.white54,
            ),

            const SizedBox(height: 16),

            ////////////////////////////////////////////////////////////
            /// TITLE
            ////////////////////////////////////////////////////////////
            const Text(
              "No Ponds Yet",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            ////////////////////////////////////////////////////////////
            /// SUBTITLE
            ////////////////////////////////////////////////////////////
            const Text(
              "Add your first pond to start monitoring",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),

            const SizedBox(height: 20),

            ////////////////////////////////////////////////////////////
            /// BUTTON (OPTIONAL)
            ////////////////////////////////////////////////////////////
            if (onAdd != null)
              ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add),
                label: const Text("Add Pond"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
              ),
          ],
        ),
      ),
    );
  }
}
