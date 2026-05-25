import 'package:flutter/material.dart';

class NavBottomPanel extends StatelessWidget {
  final double distanceKm;
  final int eta;
  final VoidCallback onCancel;

  const NavBottomPanel({
    super.key,
    required this.distanceKm,
    required this.eta,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${distanceKm.toStringAsFixed(1)} km • $eta min",
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: onCancel,
          ),
        ],
      ),
    );
  }
}
