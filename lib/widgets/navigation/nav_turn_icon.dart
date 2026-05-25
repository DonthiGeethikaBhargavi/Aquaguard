import 'package:flutter/material.dart';

IconData getTurnIcon(String type) {
  switch (type) {
    case "turn":
      return Icons.turn_right;
    case "merge":
      return Icons.merge;
    case "roundabout":
      return Icons.roundabout_right;
    case "arrive":
      return Icons.flag;
    default:
      return Icons.navigation;
  }
}
