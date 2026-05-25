import 'dart:async';

import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();

  factory SoundManager() => _instance;

  SoundManager._internal();

  // ━━━━━━━━━━━━━━━━━━━━
  // PLAYERS
  // ━━━━━━━━━━━━━━━━━━━━

  late final AudioPlayer _uiPlayer;
  late final AudioPlayer _alertPlayer;

  bool _initialized = false;

  DateTime? _lastClickTime;

  // ━━━━━━━━━━━━━━━━━━━━
  // INITIALIZE
  // ━━━━━━━━━━━━━━━━━━━━

  Future<void> initialize() async {
    if (_initialized) return;

    _initialized = true;

    _uiPlayer = AudioPlayer();
    _alertPlayer = AudioPlayer();

    // Lower latency config
    await _uiPlayer.setVolume(0.7);
    await _alertPlayer.setVolume(1.0);

    // Preload UI click sound
    try {
      await _uiPlayer.setAsset('assets/sounds/water_click.mp3');
    } catch (_) {}
  }

  // ━━━━━━━━━━━━━━━━━━━━
  // WATER CLICK
  // ━━━━━━━━━━━━━━━━━━━━

  Future<void> playWaterClick() async {
    try {
      // Prevent rapid spam
      final now = DateTime.now();

      if (_lastClickTime != null &&
          now.difference(_lastClickTime!) < const Duration(milliseconds: 120)) {
        return;
      }

      _lastClickTime = now;

      // Haptic feedback
      HapticFeedback.lightImpact();

      // Restart sound instantly
      await _uiPlayer.seek(Duration.zero);

      await _uiPlayer.play();
    } catch (_) {}
  }

  // ━━━━━━━━━━━━━━━━━━━━
  // ALERT SOUND
  // ━━━━━━━━━━━━━━━━━━━━

  Future<void> playAlertSound(String alertType) async {
    try {
      HapticFeedback.mediumImpact();

      final assetPath = _resolveAlertAsset(alertType);

      await _alertPlayer.stop();

      await _alertPlayer.setAsset(assetPath);

      await _alertPlayer.seek(Duration.zero);

      await _alertPlayer.play();
    } catch (_) {}
  }

  // ━━━━━━━━━━━━━━━━━━━━
  // ALERT ASSET MAPPER
  // ━━━━━━━━━━━━━━━━━━━━

  String _resolveAlertAsset(String alertType) {
    switch (alertType.toLowerCase()) {
      case 'low_water':
        return 'assets/sounds/low_water_warning.mp3';

      case 'high_temperature':
        return 'assets/sounds/thermal_warning.mp3';

      case 'low_do':
        return 'assets/sounds/oxygen_alert.mp3';

      case 'critical_ph':
        return 'assets/sounds/critical_ph_alert.mp3';

      case 'device_offline':
        return 'assets/sounds/device_offline.mp3';

      case 'critical_ai_risk':
        return 'assets/sounds/critical_ai_risk.mp3';

      default:
        return 'assets/sounds/default_alert.mp3';
    }
  }

  // ━━━━━━━━━━━━━━━━━━━━
  // STOP ALERTS
  // ━━━━━━━━━━━━━━━━━━━━

  Future<void> stopAlerts() async {
    try {
      await _alertPlayer.stop();
    } catch (_) {}
  }

  // ━━━━━━━━━━━━━━━━━━━━
  // DISPOSE
  // ━━━━━━━━━━━━━━━━━━━━

  Future<void> dispose() async {
    await _uiPlayer.dispose();
    await _alertPlayer.dispose();
  }
}
