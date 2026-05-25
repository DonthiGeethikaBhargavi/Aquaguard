import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/repositories/device_repository_interface.dart';
import 'package:aquaguard/features/device/presentation/providers/chart_range.dart';

class ExportService {
  final DeviceRepository repository;

  ExportService(this.repository);

  Future<void> exportPdf({
    required String pondId,
    required String deviceId,
    required ChartRange range,
    required List<String> sensors,
    DateTime? start,
    DateTime? end,
  }) async {
    final doc = pw.Document();

    final now = DateTime.now();
    final dateFmt = DateFormat('yyyy-MM-dd HH:mm');

    // Fetch data
    final rows = await repository.getChartReadings(
      pondId: pondId,
      deviceId: deviceId,
      range: range,
    );
    final alerts = await repository.getAlerts(
      pondId: pondId,
      deviceId: deviceId,
    );

    // Build a compact sparkline representation for each selected sensor
    pw.Widget sparkline(List<double> points) {
      if (points.isEmpty) return pw.Text('No data');

      final max = points.reduce((a, b) => a > b ? a : b);
      final min = points.reduce((a, b) => a < b ? a : b);
      final span = (max - min) == 0 ? 1.0 : (max - min);

      return pw.Row(
        children: points.map((v) {
          final h = ((v - min) / span) * 40 + 4;
          return pw.Container(
            width: 4,
            height: h,
            margin: const pw.EdgeInsets.symmetric(horizontal: 1),
            color: PdfColor.fromInt(0xFF00FFFF),
          );
        }).toList(),
      );
    }

    // gather numeric series per sensor
    final series = <String, List<double>>{};

    for (final row in rows) {
      for (final s in sensors) {
        final key = s.toLowerCase().replaceAll(' ', '_');
        final v = (row[key] as num?)?.toDouble();
        series.putIfAbsent(s, () => []);
        series[s]!.add(v ?? 0.0);
      }
    }

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'AquaGuard Telemetry Report',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                'Generated: ${dateFmt.format(now)}',
                style: pw.TextStyle(fontSize: 10),
              ),
              pw.SizedBox(height: 12),
              pw.Text('Device: $deviceId', style: pw.TextStyle(fontSize: 12)),
              pw.Text('Pond: $pondId', style: pw.TextStyle(fontSize: 12)),
              pw.SizedBox(height: 12),
              pw.Text(
                'Sensor summaries',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Column(
                children: sensors.map((s) {
                  final points = series[s] ?? [];
                  final avg = points.isEmpty
                      ? 0.0
                      : (points.reduce((a, b) => a + b) / points.length);
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        '$s · avg: ${avg.toStringAsFixed(2)}',
                        style: pw.TextStyle(fontSize: 11),
                      ),
                      pw.SizedBox(height: 6),
                      sparkline(points),
                      pw.SizedBox(height: 8),
                    ],
                  );
                }).toList(),
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                'Alerts',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              if (alerts.isEmpty)
                pw.Text('No alerts', style: pw.TextStyle(fontSize: 11))
              else
                pw.Column(
                  children: alerts.map((a) {
                    return pw.Container(
                      margin: const pw.EdgeInsets.only(bottom: 6),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            a.alertType.isNotEmpty ? a.alertType : 'Alert',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(a.message, style: pw.TextStyle(fontSize: 10)),
                          pw.Text(
                            'Severity: ${a.severity.name.toUpperCase()} · ${a.createdAt.toIso8601String()}',
                            style: pw.TextStyle(
                              fontSize: 9,
                              color: PdfColor.fromInt(0xFF777777),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],
          );
        },
      ),
    );

    final bytes = await doc.save();

    // Share via printing package for consistent UX across platforms
    await Printing.sharePdf(
      bytes: bytes,
      filename:
          'aquaguard_report_${deviceId}_${DateTime.now().toIso8601String()}.pdf',
    );
  }

  Future<File> exportCsv({
    required String pondId,
    required String deviceId,
    required ChartRange range,
    required String sensorKey,
  }) async {
    final rows = await repository.getChartReadings(
      pondId: pondId,
      deviceId: deviceId,
      range: range,
    );

    final buffer = StringBuffer();
    buffer.writeln('timestamp,${sensorKey}');

    for (final row in rows) {
      final ts = row['created_at'] ?? row['timestamp'] ?? row['date'] ?? '';
      final v = row[sensorKey] ?? '';
      buffer.writeln('$ts,$v');
    }

    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/aquaguard_${deviceId}_${sensorKey}_${DateTime.now().millisecondsSinceEpoch}.csv',
    );
    await file.writeAsString(buffer.toString());

    return file;
  }
}
