import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_data.dart';

class PrefService extends ChangeNotifier {
  final SharedPreferences _prefs;
  PrefService._(this._prefs);

  static const _kOpenCount = 'open_count';
  static const _kProfile = 'profile_data';
  static const _kOnboarding = 'has_seen_onboarding';
  static const _kThemeMode = 'theme_mode';
  static const _kThemeColor = 'theme_color';

  static Future<PrefService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return PrefService._(prefs);
  }

  int get openCount => _prefs.getInt(_kOpenCount) ?? 0;
  Future<void> increaseOpenCount() async {
    await _prefs.setInt(_kOpenCount, openCount + 1);
    notifyListeners(); 
  }

  bool get hasSeenOnboarding => _prefs.getBool(_kOnboarding) ?? false;
  Future<void> setHasSeenOnboarding() async {
    await _prefs.setBool(_kOnboarding, true);
    notifyListeners();
  }
  ThemeMode get themeMode {
    final index = _prefs.getInt(_kThemeMode) ?? ThemeMode.system.index;
    return ThemeMode.values[index];
  }
  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setInt(_kThemeMode, mode.index);
    notifyListeners();
  }

  Color get themeColor {
    final colorValue = _prefs.getInt(_kThemeColor);
    return colorValue != null ? Color(colorValue) : Colors.indigo;
  }
  Future<void> setThemeColor(Color color) async {
    await _prefs.setInt(_kThemeColor, color.value);
    notifyListeners();
  }

  ProfileData get profile {
    final raw = _prefs.getString(_kProfile);
    if (raw == null) return ProfileData.defaults;
    try {
      return ProfileData.fromJson(raw);
    } catch (_) {
      return ProfileData.defaults;
    }
  }
  Future<void> saveProfile(ProfileData profileData) async {
    await _prefs.setString(_kProfile, profileData.toJson());
    notifyListeners(); // Langsung update UI profil otomatis!
  }
  Future<void> clearProfile() async {
    await _prefs.remove(_kProfile);
    notifyListeners();
  }
}