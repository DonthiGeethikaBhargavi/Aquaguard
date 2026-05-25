import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert_model.freezed.dart';

////////////////////////////////////////////////////////////
/// ALERT SEVERITY
////////////////////////////////////////////////////////////

enum AlertSeverity { info, warning, critical }

////////////////////////////////////////////////////////////
/// ALERT STATUS
////////////////////////////////////////////////////////////

enum AlertStatus { active, resolved, escalated }

////////////////////////////////////////////////////////////
/// ALERT MODEL
////////////////////////////////////////////////////////////

@freezed
class AlertModel with _$AlertModel {
  const AlertModel._();

  const factory AlertModel({
    //////////////////////////////////////////////////////////
    /// IDS
    //////////////////////////////////////////////////////////
    required String id,

    required String deviceId,

    required String pondId,

    //////////////////////////////////////////////////////////
    /// ALERT DETAILS
    //////////////////////////////////////////////////////////
    required String alertType,

    required String parameter,

    required String message,

    //////////////////////////////////////////////////////////
    /// VALUE
    //////////////////////////////////////////////////////////
    @Default(0.0) double value,

    //////////////////////////////////////////////////////////
    /// RESOLUTION
    //////////////////////////////////////////////////////////
    @Default(false) bool isResolved,

    @Default(false) bool isRead,

    //////////////////////////////////////////////////////////
    /// TIMESTAMPS
    //////////////////////////////////////////////////////////
    required DateTime createdAt,

    DateTime? resolvedAt,

    //////////////////////////////////////////////////////////
    /// PRIORITY
    //////////////////////////////////////////////////////////
    @Default('warning') String priority,

    //////////////////////////////////////////////////////////
    /// ESCALATION
    //////////////////////////////////////////////////////////
    @Default(false) bool escalated,

    //////////////////////////////////////////////////////////
    /// TRACKING
    //////////////////////////////////////////////////////////
    DateTime? firstSeen,

    DateTime? lastSeen,

    //////////////////////////////////////////////////////////
    /// GROUPING
    //////////////////////////////////////////////////////////
    String? groupId,

    //////////////////////////////////////////////////////////
    /// ACKNOWLEDGEMENT
    //////////////////////////////////////////////////////////
    String? acknowledgedBy,

    //////////////////////////////////////////////////////////
    /// NOTES
    //////////////////////////////////////////////////////////
    String? notes,
  }) = _AlertModel;

  ////////////////////////////////////////////////////////////
  /// FROM JSON
  ////////////////////////////////////////////////////////////

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id']?.toString() ?? '',

      deviceId: json['device_id']?.toString() ?? '',

      pondId: json['pond_id']?.toString() ?? '',

      alertType: json['alert_type']?.toString() ?? '',

      parameter: json['parameter']?.toString() ?? '',

      message: json['message']?.toString() ?? '',

      value: (json['value'] as num?)?.toDouble() ?? 0.0,

      isResolved: json['is_resolved'] ?? false,
      isRead: json['is_read'] ?? false,

      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),

      resolvedAt: json['resolved_at'] != null
          ? DateTime.tryParse(json['resolved_at'].toString())
          : null,

      priority: json['priority']?.toString() ?? 'warning',

      escalated: json['escalated'] ?? false,

      firstSeen: json['first_seen'] != null
          ? DateTime.tryParse(json['first_seen'].toString())
          : null,

      lastSeen: json['last_seen'] != null
          ? DateTime.tryParse(json['last_seen'].toString())
          : null,

      groupId: json['group_id']?.toString(),

      acknowledgedBy: json['acknowledged_by']?.toString(),

      notes: json['notes']?.toString(),
    );
  }

  ////////////////////////////////////////////////////////////
  /// TO JSON
  ////////////////////////////////////////////////////////////

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'device_id': deviceId,

      'pond_id': pondId,

      'alert_type': alertType,

      'parameter': parameter,

      'message': message,

      'value': value,

      'is_resolved': isResolved,
      'is_read': isRead,

      'created_at': createdAt.toIso8601String(),

      'resolved_at': resolvedAt?.toIso8601String(),

      'priority': priority,

      'escalated': escalated,

      'first_seen': firstSeen?.toIso8601String(),

      'last_seen': lastSeen?.toIso8601String(),

      'group_id': groupId,

      'acknowledged_by': acknowledgedBy,

      'notes': notes,
    };
  }

  ////////////////////////////////////////////////////////////
  /// SEVERITY
  ////////////////////////////////////////////////////////////

  AlertSeverity get severity {
    switch (priority.toLowerCase()) {
      case 'critical':
        return AlertSeverity.critical;

      case 'warning':
        return AlertSeverity.warning;

      default:
        return AlertSeverity.info;
    }
  }

  ////////////////////////////////////////////////////////////
  /// STATUS
  ////////////////////////////////////////////////////////////

  AlertStatus get status {
    if (isResolved) {
      return AlertStatus.resolved;
    }

    if (escalated) {
      return AlertStatus.escalated;
    }

    return AlertStatus.active;
  }

  ////////////////////////////////////////////////////////////
  /// ACTIVE
  ////////////////////////////////////////////////////////////

  bool get isActive {
    return !isResolved;
  }

  ////////////////////////////////////////////////////////////
  /// CRITICAL
  ////////////////////////////////////////////////////////////

  bool get isCritical {
    return severity == AlertSeverity.critical;
  }

  ////////////////////////////////////////////////////////////
  /// WARNING
  ////////////////////////////////////////////////////////////

  bool get isWarning {
    return severity == AlertSeverity.warning;
  }

  ////////////////////////////////////////////////////////////
  /// STALE
  ////////////////////////////////////////////////////////////

  bool get isStale {
    final seen = lastSeen ?? createdAt;

    final elapsed = DateTime.now().difference(seen);

    return elapsed.inHours > 6;
  }

  ////////////////////////////////////////////////////////////
  /// ACTIVE DURATION
  ////////////////////////////////////////////////////////////

  Duration get activeDuration {
    final end = resolvedAt ?? DateTime.now();

    return end.difference(createdAt);
  }

  ////////////////////////////////////////////////////////////
  /// FORMATTED DURATION
  ////////////////////////////////////////////////////////////

  String get formattedDuration {
    final duration = activeDuration;

    if (duration.inDays > 0) {
      return '${duration.inDays}d';
    }

    if (duration.inHours > 0) {
      return '${duration.inHours}h';
    }

    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    }

    return '${duration.inSeconds}s';
  }

  ////////////////////////////////////////////////////////////
  /// FORMATTED VALUE
  ////////////////////////////////////////////////////////////

  String get formattedValue {
    return value.toStringAsFixed(2);
  }

  ////////////////////////////////////////////////////////////
  /// TIMELINE LABEL
  ////////////////////////////////////////////////////////////

  String get timelineLabel {
    if (isResolved) {
      return 'Resolved';
    }

    if (escalated) {
      return 'Escalated';
    }

    return 'Active';
  }
}
