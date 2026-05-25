import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io' show Platform;

enum ExportFormat { csv, pdf, json, share }

enum ExportProgress { preparing, generating, downloading, complete, error }

class ExportDialog extends StatefulWidget {
  final String pondId;
  final String deviceId;
  final Future<void> Function(ExportFormat) onExport;

  const ExportDialog({
    Key? key,
    required this.pondId,
    required this.deviceId,
    required this.onExport,
  }) : super(key: key);

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  ExportFormat? _selectedFormat;
  ExportProgress? _exportProgress;
  String _exportedFilePath = '';
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? Color(0xFF1A1F2E) : Colors.white;
    final cardColor = isDark ? Color(0xFF242B3B) : Color(0xFFF9FAFB);
    final textColor = isDark ? Colors.white : Color(0xFF1A1F2E);
    final subtleColor = isDark ? Color(0xFF8A92A6) : Color(0xFF6B7280);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(top: 8, bottom: 16),
                decoration: BoxDecoration(
                  color: subtleColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Export Analytics',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Choose format to download your data',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: subtleColor,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Progress or Export Options
                  if (_exportProgress == null)
                    _buildExportOptions(
                      context,
                      cardColor,
                      textColor,
                      subtleColor,
                    )
                  else
                    _buildProgressView(context, textColor, subtleColor),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportOptions(
    BuildContext context,
    Color cardColor,
    Color textColor,
    Color subtleColor,
  ) {
    return Column(
      children: [
        _buildExportOption(
          context,
          'CSV',
          'Sensor readings data',
          Icons.table_chart,
          ExportFormat.csv,
          cardColor,
        ),
        SizedBox(height: 12),
        _buildExportOption(
          context,
          'PDF',
          'Premium analytics report',
          Icons.picture_as_pdf,
          ExportFormat.pdf,
          cardColor,
        ),
        SizedBox(height: 12),
        _buildExportOption(
          context,
          'JSON',
          'Latest snapshot data',
          Icons.data_object,
          ExportFormat.json,
          cardColor,
        ),
        SizedBox(height: 12),
        _buildExportOption(
          context,
          'Share',
          'Share via native share',
          Icons.share,
          ExportFormat.share,
          cardColor,
        ),
      ],
    );
  }

  Widget _buildExportOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    ExportFormat format,
    Color cardColor,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final subtleColor = isDark ? Color(0xFF8A92A6) : Color(0xFF6B7280);

    return GestureDetector(
      onTap: () => _handleExport(format),
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: theme.primaryColor.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: theme.primaryColor,
                size: 22,
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: subtleColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: subtleColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressView(
    BuildContext context,
    Color textColor,
    Color subtleColor,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Center(
          child: SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation(
                theme.primaryColor,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          _getProgressMessage(_exportProgress),
          style: theme.textTheme.bodySmall?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          'This may take a few moments...',
          style: theme.textTheme.labelSmall?.copyWith(
            color: subtleColor,
          ),
          textAlign: TextAlign.center,
        ),
        if (_exportProgress == ExportProgress.error) ...[
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.red[200]!,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 18,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage ?? 'Export failed',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.red[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _exportProgress = null;
                    _errorMessage = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                ),
                child: Text('Dismiss'),
              ),
              ElevatedButton(
                onPressed: () {
                  _handleExport(_selectedFormat!);
                },
                child: Text('Retry'),
              ),
            ],
          ),
        ] else if (_exportProgress == ExportProgress.complete) ...[
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  _openExportedFile();
                },
                icon: Icon(Icons.folder_open),
                label: Text('Open'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _shareExportedFile();
                },
                icon: Icon(Icons.share),
                label: Text('Share'),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Future<void> _handleExport(ExportFormat format) async {
    try {
      setState(() {
        _selectedFormat = format;
        _exportProgress = ExportProgress.preparing;
        _errorMessage = null;
      });

      // Simulate progress through stages
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        _exportProgress = ExportProgress.generating;
      });

      await Future.delayed(Duration(milliseconds: 1000));
      setState(() {
        _exportProgress = ExportProgress.downloading;
      });

      // Call the actual export function
      try {
        await widget.onExport(format);

        setState(() {
          _exportProgress = ExportProgress.complete;
          _exportedFilePath =
              _getExportFilePath(format); // Mock path
        });

        // Auto-close after 2 seconds on success
        await Future.delayed(Duration(seconds: 2));
        if (mounted && _exportProgress == ExportProgress.complete) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        setState(() {
          _exportProgress = ExportProgress.error;
          _errorMessage = _getErrorMessage(e);
        });
      }
    } catch (e) {
      setState(() {
        _exportProgress = ExportProgress.error;
        _errorMessage = 'Unexpected error occurred';
      });
    }
  }

  Future<void> _openExportedFile() async {
    // This would normally open the file with the default app
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening file: $_exportedFilePath'),
      ),
    );
  }

  Future<void> _shareExportedFile() async {
    try {
      await Share.shareXFiles(
        [XFile(_exportedFilePath)],
        text: 'AquaGuard Analytics Report',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Share failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getProgressMessage(ExportProgress? progress) {
    switch (progress) {
      case ExportProgress.preparing:
        return 'Preparing report...';
      case ExportProgress.generating:
        return 'Generating analytics...';
      case ExportProgress.downloading:
        return 'Downloading...';
      case ExportProgress.complete:
        return 'Export complete!';
      case ExportProgress.error:
        return 'Export failed';
      case null:
        return '';
    }
  }

  String _getExportFilePath(ExportFormat format) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final basePath = Platform.isAndroid
        ? '/storage/emulated/0/Download/AquaGuard'
        : '/Documents/AquaGuard';

    switch (format) {
      case ExportFormat.csv:
        return '$basePath/sensor_readings_$timestamp.csv';
      case ExportFormat.pdf:
        return '$basePath/analytics_report_$timestamp.pdf';
      case ExportFormat.json:
        return '$basePath/snapshot_$timestamp.json';
      case ExportFormat.share:
        return '$basePath/report_$timestamp.pdf';
    }
  }

  String _getErrorMessage(Object error) {
    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('network') || errorStr.contains('internet')) {
      return 'No internet connection. Check your connection and try again.';
    } else if (errorStr.contains('empty')) {
      return 'No data available to export.';
    } else if (errorStr.contains('timeout')) {
      return 'Request timed out. Please try again.';
    } else if (errorStr.contains('storage') || errorStr.contains('permission')) {
      return 'Storage permission denied. Check app permissions.';
    } else if (errorStr.contains('malformed')) {
      return 'Data format error. Please contact support.';
    } else {
      return 'Export failed: ${error.toString().length > 50 ? error.toString().substring(0, 50) : error.toString()}';
    }
  }
}

class ExportDialogButton extends StatelessWidget {
  final String pondId;
  final String deviceId;
  final Future<void> Function(ExportFormat) onExport;

  const ExportDialogButton({
    Key? key,
    required this.pondId,
    required this.deviceId,
    required this.onExport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.download),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => ExportDialog(
            pondId: pondId,
            deviceId: deviceId,
            onExport: onExport,
          ),
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
        );
      },
      tooltip: 'Export',
    );
  }
}
