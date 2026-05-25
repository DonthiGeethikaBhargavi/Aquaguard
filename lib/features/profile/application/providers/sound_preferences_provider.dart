import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 🔊 SOUND PREFERENCES MODEL
class SoundPreferences {
  final bool rainSoundEnabled;
  final bool thunderSoundEnabled;

  const SoundPreferences({
    this.rainSoundEnabled = true,
    this.thunderSoundEnabled = true,
  });

  SoundPreferences copyWith({
    bool? rainSoundEnabled,
    bool? thunderSoundEnabled,
  }) {
    return SoundPreferences(
      rainSoundEnabled: rainSoundEnabled ?? this.rainSoundEnabled,
      thunderSoundEnabled: thunderSoundEnabled ?? this.thunderSoundEnabled,
    );
  }

  /// Create default
  factory SoundPreferences.defaults() =>
      const SoundPreferences(rainSoundEnabled: true, thunderSoundEnabled: true);
}

/// 🔊 SHARED PREFERENCES PROVIDER
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return await SharedPreferences.getInstance();
});

/// 🔊 SOUND PREFERENCES NOTIFIER
class SoundPreferencesNotifier extends StateNotifier<SoundPreferences> {
  final SharedPreferences? _prefs;

  SoundPreferencesNotifier([this._prefs]) : super(SoundPreferences.defaults()) {
    if (_prefs != null) {
      _loadPreferences();
    }
  }

  Future<void> _loadPreferences() async {
    try {
      final rainEnabled = _prefs?.getBool('rain_sound_enabled') ?? true;
      final thunderEnabled = _prefs?.getBool('thunder_sound_enabled') ?? true;
      state = SoundPreferences(
        rainSoundEnabled: rainEnabled,
        thunderSoundEnabled: thunderEnabled,
      );
    } catch (_) {
      state = SoundPreferences.defaults();
    }
  }

  Future<void> toggleRainSound() async {
    final updated = state.copyWith(rainSoundEnabled: !state.rainSoundEnabled);
    state = updated;
    if (_prefs != null) {
      await _prefs.setBool('rain_sound_enabled', updated.rainSoundEnabled);
    }
  }

  Future<void> toggleThunderSound() async {
    final updated = state.copyWith(
      thunderSoundEnabled: !state.thunderSoundEnabled,
    );
    state = updated;
    if (_prefs != null) {
      await _prefs.setBool(
        'thunder_sound_enabled',
        updated.thunderSoundEnabled,
      );
    }
  }
}

/// 📱 SOUND PREFERENCES PROVIDER
final soundPreferencesProvider =
    StateNotifierProvider<SoundPreferencesNotifier, SoundPreferences>((ref) {
      final prefsAsync = ref.watch(sharedPreferencesProvider);

      return prefsAsync.maybeWhen(
        data: (prefs) => SoundPreferencesNotifier(prefs),
        orElse: () => SoundPreferencesNotifier(),
      );
    });
