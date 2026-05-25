/*
////////////////////////////////////////////////////////////
 TELEMETRY EXPORT SERVICE

 Enterprise data export and sharing functionality.

 Features:
 - CSV generation from Supabase data
 - Android scoped storage support
 - File cleanup
 - Share sheet integration
 - Progress tracking
 - Retry support
////////////////////////////////////////////////////////////
*/

import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/telemetry_sanitizer.dart';
import 'analytics_error_handler.dart';

class TelemetryExportService {
  final SupabaseClient supabase;

  TelemetryExportService(this.supabase);

  ////////////////////////////////////////////////////////////
  /// CSV EXPORT
  ////////////////////////////////////////////////////////////

  /// Export telemetry data to CSV
  Future<File?> exportTelemetryCSV({
    required String pondId,
    required DateTime startDate,
    required DateTime endDate,
    void Function(int progress)? onProgress,
  }) async {
    try {
      onProgress?.call(0);

      // Fetch raw sensor readings for telemetry export
      final response = await supabase
          .from('sensor_readings')
          .select('*')
          .eq('pond_id', pondId)
          .gte('created_at', startDate.toIso8601String())
          .lte('created_at', endDate.toIso8601String())
          .order('created_at', ascending: true);

      onProgress?.call(50);

      // Sanitize data
      final records = safeListMap(response);
      final csvData = _buildTelemetryCSV(records);

      onProgress?.call(75);

      // Write to file
      final file = await _writeCSVFile(
        'telemetry_${pondId}_${_formatDateForFilename(startDate)}.csv',
        csvData,
      );

      onProgress?.call(100);

      return file;
    } catch (e, st) {
      throw AnalyticsErrorHandler.parseException(e, st);
    }
  }

  /// Export alert history to CSV
  Future<File?> exportAlertsCSV({
    required String pondId,
    required DateTime startDate,
    required DateTime endDate,
    void Function(int progress)? onProgress,
  }) async {
    try {
      onProgress?.call(0);

      // Fetch alert history
      final response = await supabase
          .from('alerts_history')
          .select('*')
          .eq('pond_id', pondId)
          .gte('created_at', startDate.toIso8601String())
          .lte('created_at', endDate.toIso8601String())
          .order('created_at', ascending: true);

      onProgress?.call(50);

      // Sanitize data
      final records = safeListMap(response);
      final csvData = _buildAlertsCSV(records);

      onProgress?.call(75);

      // Write to file
      final file = await _writeCSVFile(
        'alerts_${pondId}_${_formatDateForFilename(startDate)}.csv',
        csvData,
      );

      onProgress?.call(100);

      return file;
    } catch (e, st) {
      throw AnalyticsErrorHandler.parseException(e, st);
    }
  }

  /// Export telemetry data to JSON
  Future<File?> exportTelemetryJSON({
    required String pondId,
    required DateTime startDate,
    required DateTime endDate,
    void Function(int progress)? onProgress,
  }) async {
    try {
      onProgress?.call(0);

      final response = await supabase
          .from('sensor_readings')
          .select('*')
          .eq('pond_id', pondId)
          .gte('created_at', startDate.toIso8601String())
          .lte('created_at', endDate.toIso8601String())
          .order('created_at', ascending: true);

      onProgress?.call(50);

      final records = safeListMap(response);
      final jsonString = JsonEncoder.withIndent('  ').convert(records);

      onProgress?.call(75);

      final file = await _writeTextFile(
        'telemetry_${pondId}_${_formatDateForFilename(startDate)}.json',
        jsonString,
      );

      onProgress?.call(100);
      return file;
    } catch (e, st) {
      throw AnalyticsErrorHandler.parseException(e, st);
    }
  }

  ////////////////////////////////////////////////////////////
  /// CSV BUILDERS
  ////////////////////////////////////////////////////////////

  /// Build telemetry CSV
  List<List<String>> _buildTelemetryCSV(List<Map<String, dynamic>> records) {
    final rows = <List<String>>[];

    // Header
    rows.add([
      'Timestamp',
      'Temperature (°C)',
      'Dissolved Oxygen (mg/L)',
      'pH',
      'Water Level (cm)',
      'Turbidity',
      'Salinity (ppt)',
      'Ammonia (mg/L)',
    ]);

    // Data rows
    for (final record in records) {
      final timestamp = safeDateTime(record['created_at'])?.toString() ?? '--';
      final temp =
          safeDouble(record['temperature'])?.toStringAsFixed(2) ?? '--';
      final do_ =
          safeDouble(record['dissolved_oxygen'])?.toStringAsFixed(2) ?? '--';
      final ph = safeDouble(record['ph'])?.toStringAsFixed(2) ?? '--';
      final level =
          safeDouble(record['water_level'])?.toStringAsFixed(2) ?? '--';
      final turbidity =
          safeDouble(record['turbidity'])?.toStringAsFixed(2) ?? '--';
      final salinity =
          safeDouble(record['salinity'])?.toStringAsFixed(2) ?? '--';
      final ammonia = safeDouble(record['ammonia'])?.toStringAsFixed(2) ?? '--';

      rows.add([timestamp, temp, do_, ph, level, turbidity, salinity, ammonia]);
    }

    return rows;
  }

  /// Build alerts CSV
  List<List<String>> _buildAlertsCSV(List<Map<String, dynamic>> records) {
    final rows = <List<String>>[];

    // Header
    rows.add([
      'Timestamp',
      'Parameter',
      'Alert Type',
      'Severity',
      'Status',
      'Resolved At',
      'Duration',
    ]);

    // Data rows
    for (final record in records) {
      final timestamp = safeDateTime(record['created_at'])?.toString() ?? '--';
      final parameter = safeString(record['parameter']);
      final alertType = safeString(record['alert_type']);
      final severity = safeString(record['severity']);
      final status = (record['is_resolved'] == true) ? 'Resolved' : 'Active';
      final resolvedAt =
          safeDateTime(record['resolved_at'])?.toString() ?? '--';

      String duration = '--';
      final created = safeDateTime(record['created_at']);
      final resolved = safeDateTime(record['resolved_at']);
      if (created != null && resolved != null) {
        final diff = resolved.difference(created);
        duration = _formatDuration(diff);
      }

      rows.add([
        timestamp,
        parameter,
        alertType,
        severity,
        status,
        resolvedAt,
        duration,
      ]);
    }

    return rows;
  }

  ////////////////////////////////////////////////////////////
  /// FILE OPERATIONS
  ////////////////////////////////////////////////////////////

  /// Write CSV data to file
  Future<File> _writeCSVFile(String filename, List<List<String>> rows) async {
    final csv = _convertToCSV(rows);

    final directory = await _exportDirectory();
    final file = File('${directory.path}/$filename');

    await file.writeAsString(csv);
    return file;
  }

  /// Write plain text data to file
  Future<File> _writeTextFile(String filename, String content) async {
    final directory = await _exportDirectory();
    final file = File('${directory.path}/$filename');

    await file.writeAsString(content);
    return file;
  }

  Future<Directory> _exportDirectory() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final externalDirs = await getExternalStorageDirectories(
          type: StorageDirectory.downloads,
        );
        if (externalDirs != null && externalDirs.isNotEmpty) {
          return externalDirs.first;
        }
      }
    } catch (_) {
      // Ignore unsupported or permission denied path providers.
    }

    try {
      final downloads = await getDownloadsDirectory();
      if (downloads != null) {
        return downloads;
      }
    } catch (_) {
      // Fallback if downloads directory is not available.
    }

    return await getApplicationDocumentsDirectory();
  }

  /// Share file
  Future<void> shareFile(File file) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: 'Aquaguard Telemetry Export',
          files: [XFile(file.path)],
        ),
      );
    } catch (e) {
      throw AnalyticsErrorHandler.parseException(e, StackTrace.current);
    }
  }

  /// Clean up temporary files
  Future<void> cleanupExportFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync();

      for (final file in files) {
        if (file is File && file.path.contains('telemetry_') ||
            file.path.contains('alerts_')) {
          final stat = await file.stat();
          final age = DateTime.now().difference(stat.changed);

          // Delete files older than 7 days
          if (age.inDays > 7) {
            await file.delete();
          }
        }
      }
    } catch (_) {
      // Silent fail - cleanup is non-critical
    }
  }

  ////////////////////////////////////////////////////////////
  /// FORMATTING
  ////////////////////////////////////////////////////////////

  /// Format date for filename
  String _formatDateForFilename(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String _formatDateForQuery(DateTime date, String column) {
    if (column == 'day' ||
        column == 'week' ||
        column == 'month' ||
        column == 'year') {
      return DateFormat('yyyy-MM-dd').format(date);
    }
    return date.toIso8601String();
  }

  String _tableForReportRange(DateTime startDate, DateTime endDate) {
    final durationDays = endDate.difference(startDate).inDays;
    if (durationDays <= 7) {
      return 'hourly_stats';
    }
    return 'daily_stats';
  }

  String _timeColumnForReportTable(String table) {
    switch (table) {
      case 'hourly_stats':
        return 'created_at';
      case 'daily_stats':
        return 'day';
      default:
        return 'created_at';
    }
  }

  /// Format duration as human-readable
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours == 0) {
      return '${minutes}m';
    }
    return '${hours}h ${minutes}m';
  }

  String _formatValue(Object? value) {
    if (value == null) return '--';
    if (value is num) return value.toString();
    return value.toString();
  }

  ////////////////////////////////////////////////////////////
  /// BATCH EXPORT
  ////////////////////////////////////////////////////////////

  /// Export comprehensive telemetry report
  Future<File?> exportFullReport({
    required String pondId,
    required DateTime startDate,
    required DateTime endDate,
    void Function(String status)? onStatus,
  }) async {
    try {
      onStatus?.call('Preparing telemetry data...');

      final telemetryTable = _tableForReportRange(startDate, endDate);
      final timeColumn = _timeColumnForReportTable(telemetryTable);
      final startValue = _formatDateForQuery(startDate, timeColumn);
      final endValue = _formatDateForQuery(endDate, timeColumn);

      final telemetryData = await supabase
          .from(telemetryTable)
          .select('*')
          .eq('pond_id', pondId)
          .gte(timeColumn, startValue)
          .lte(timeColumn, endValue)
          .order(timeColumn, ascending: true);

      onStatus?.call('Processing alerts...');

      final alertData = await supabase
          .from('alerts_history')
          .select('*')
          .eq('pond_id', pondId)
          .gte('created_at', startDate.toIso8601String())
          .lte('created_at', endDate.toIso8601String())
          .order('created_at', ascending: true);

      onStatus?.call('Generating operational report...');

      final telemetryRecords = safeListMap(telemetryData);
      final alertRecords = safeListMap(alertData);

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageTheme: const pw.PageTheme(margin: pw.EdgeInsets.all(32)),
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                'AQUAGUARD OPERATIONAL REPORT',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Text(
              'Generated: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
            pw.SizedBox(height: 14),
            pw.Text(
              'Telemetry Rollup',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.TableHelper.fromTextArray(
              headers: [
                'Timestamp',
                'Avg Temp (°C)',
                'Avg DO (mg/L)',
                'Avg pH',
              ],
              data: telemetryRecords.map((record) {
                final temperature =
                    safeDouble(record['temperature_avg']) ??
                    safeDouble(record['temp_avg']);
                final oxygen =
                    safeDouble(record['oxygen_avg']) ??
                    safeDouble(record['do_avg']);
                final ph = safeDouble(record['ph_avg']);

                return [
                  safeDateTime(record['created_at'])?.toIso8601String() ?? '--',
                  temperature != null ? temperature.toStringAsFixed(2) : '--',
                  oxygen != null ? oxygen.toStringAsFixed(2) : '--',
                  ph != null ? ph.toStringAsFixed(2) : '--',
                ];
              }).toList(),
            ),
            pw.SizedBox(height: 22),
            pw.Text(
              'Alert History',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.TableHelper.fromTextArray(
              headers: ['Timestamp', 'Parameter', 'Type', 'Status', 'Value'],
              data: alertRecords.map((record) {
                return [
                  safeDateTime(record['created_at'])?.toIso8601String() ?? '--',
                  safeString(record['parameter']),
                  safeString(record['alert_type']),
                  record['is_resolved'] == true ? 'Resolved' : 'Active',
                  _formatValue(record['value']),
                ];
              }).toList(),
            ),
            pw.SizedBox(height: 24),
            pw.Text(
              'Notes',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),
            pw.Text(
              'This report surfaces operational telemetry, alert history, and historical drift in the Aquaguard monitoring system. All values are derived from raw Supabase readings and aggregated analytics.',
              style: pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final filename =
          'aquaguard_report_${_formatDateForFilename(startDate)}_${_formatDateForFilename(endDate)}.pdf';
      final file = File('${directory.path}/$filename');
      await file.writeAsBytes(await pdf.save());

      onStatus?.call('Report ready');
      return file;
    } catch (e, st) {
      throw AnalyticsErrorHandler.parseException(e, st);
    }
  }

  /// Convert list of lists to CSV string format
  /// Handles quoted fields containing commas or newlines
  String _convertToCSV(List<List<String>> rows) {
    final buffer = StringBuffer();

    for (int i = 0; i < rows.length; i++) {
      final row = rows[i];

      for (int j = 0; j < row.length; j++) {
        final field = row[j];

        // Quote field if it contains comma, newline, or quotes
        if (field.contains(',') ||
            field.contains('\n') ||
            field.contains('"')) {
          // Escape quotes by doubling them
          final escaped = field.replaceAll('"', '""');
          buffer.write('"$escaped"');
        } else {
          buffer.write(field);
        }

        // Add comma separator except for last field
        if (j < row.length - 1) {
          buffer.write(',');
        }
      }

      // Add newline except for last row
      if (i < rows.length - 1) {
        buffer.write('\n');
      }
    }

    return buffer.toString();
  }
}
