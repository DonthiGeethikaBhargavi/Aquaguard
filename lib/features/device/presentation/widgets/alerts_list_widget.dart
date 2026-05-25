import 'package:flutter/material.dart';

class AlertsListWidget extends StatelessWidget {
  const AlertsListWidget({
    super.key,
    required this.pondId,
    required this.deviceId,
  });

  final String pondId;
  final String deviceId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Alerts List for Pond $pondId, Device $deviceId Coming Soon',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
