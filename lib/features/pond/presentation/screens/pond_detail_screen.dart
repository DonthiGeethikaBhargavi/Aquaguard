import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../device/application/providers/device_provider.dart';
import '../../../device/presentation/screens/device_dashboard_screen.dart';

class PondDetailScreen extends ConsumerWidget {
  final Map<String, dynamic> pond;

  const PondDetailScreen({super.key, required this.pond});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(deviceListProvider(pond['pond_id']));

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      appBar: AppBar(
        title: Text(pond['pond_name'] ?? ''),
        backgroundColor: Colors.transparent,
      ),
      body: devices.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Text(
                "No devices",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final d = list[i];

              return ListTile(
                title: Text(
                  d['device_id'],
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  d['is_online'] == true ? "Online" : "Offline",
                  style: TextStyle(
                    color: d['is_online'] == true ? Colors.green : Colors.red,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DeviceDashboardScreen(
                        deviceId: d['device_id'] as String,
                        pondId: pond['pond_id'] as String,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text("Error loading devices")),
      ),
    );
  }
}
