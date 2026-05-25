////////////////////////////////////////////////////////////
/// TELEMETRY EXPORT & SHARE PROVIDER
///
/// Handles CSV export, file management, and sharing.
/// Integrates with Android scoped storage.
///
/// Features:
/// - Real Supabase data export
/// - CSV generation
/// - Progress tracking
/// - File management
/// - Share integration
/// - Error recovery
////////////////////////////////////////////////////////////

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:aquaguard/core/services/analytics_error_handler.dart';
import 'package:aquaguard/core/services/telemetry_export_service.dart';

/// Telemetry export service provider
final telemetryExportServiceProvider = Provider<TelemetryExportService>((ref) {
  final supabase = Supabase.instance.client;
  return TelemetryExportService(supabase);
});

/// Export telemetry CSV
final exportTelemetryProvider =
    FutureProvider.family<File?, ExportTelemetryParams>((ref, params) async {
      try {
        final exportService = ref.watch(telemetryExportServiceProvider);

        final file = await exportService.exportTelemetryCSV(
          pondId: params.pondId,
          startDate: params.startDate,
          endDate: params.endDate,
          onProgress: params.onProgress,
        );

        return file;
      } catch (e, st) {
        throw AnalyticsErrorHandler.parseException(e, st);
      }
    });

/// Export alerts CSV
final exportAlertsProvider = FutureProvider.family<File?, ExportAlertsParams>((
  ref,
  params,
) async {
  try {
    final exportService = ref.watch(telemetryExportServiceProvider);

    final file = await exportService.exportAlertsCSV(
      pondId: params.pondId,
      startDate: params.startDate,
      endDate: params.endDate,
      onProgress: params.onProgress,
    );

    return file;
  } catch (e, st) {
    throw AnalyticsErrorHandler.parseException(e, st);
  }
});

/// Export full report
final exportFullReportProvider =
    FutureProvider.family<File?, ExportReportParams>((ref, params) async {
      try {
        final exportService = ref.watch(telemetryExportServiceProvider);

        final file = await exportService.exportFullReport(
          pondId: params.pondId,
          startDate: params.startDate,
          endDate: params.endDate,
          onStatus: params.onStatus,
        );

        return file;
      } catch (e, st) {
        throw AnalyticsErrorHandler.parseException(e, st);
      }
    });

/// Cleanup old export files
final cleanupExportFilesProvider = FutureProvider<void>((ref) async {
  try {
    final exportService = ref.watch(telemetryExportServiceProvider);
    await exportService.cleanupExportFiles();
  } catch (_) {
    // Silent cleanup failure
  }
});

/// Export parameters
class ExportTelemetryParams {
  final String pondId;
  final DateTime startDate;
  final DateTime endDate;
  final void Function(int progress)? onProgress;

  ExportTelemetryParams({
    required this.pondId,
    required this.startDate,
    required this.endDate,
    this.onProgress,
  });
}

class ExportAlertsParams {
  final String pondId;
  final DateTime startDate;
  final DateTime endDate;
  final void Function(int progress)? onProgress;

  ExportAlertsParams({
    required this.pondId,
    required this.startDate,
    required this.endDate,
    this.onProgress,
  });
}

class ExportReportParams {
  final String pondId;
  final DateTime startDate;
  final DateTime endDate;
  final void Function(String status)? onStatus;

  ExportReportParams({
    required this.pondId,
    required this.startDate,
    required this.endDate,
    this.onStatus,
  });
}
