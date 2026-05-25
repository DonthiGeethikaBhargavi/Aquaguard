// lib/core/theme/app_shadows.dart

import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> soft = [
    BoxShadow(
      color: Colors.black.withOpacity(0.18),
      blurRadius: 30,
      spreadRadius: -8,
      offset: const Offset(0, 16),
    ),
  ];

  static List<BoxShadow> glow = [
    BoxShadow(
      color: const Color(0xFF7DD3FC).withOpacity(0.10),
      blurRadius: 40,
      spreadRadius: -10,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> floating = [
    BoxShadow(
      color: Colors.black.withOpacity(0.28),
      blurRadius: 50,
      spreadRadius: -12,
      offset: const Offset(0, 20),
    ),
  ];
}
