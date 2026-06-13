import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeService {
  static final ValueNotifier<bool> isDarkMode =
      ValueNotifier(false);

  static Future<void> init() async {
    final box = await Hive.openBox('settings');

    isDarkMode.value = box.get(
      'dark_mode',
      defaultValue: true,
    );
  }

  static Future<void> setDarkMode(
    bool value,
  ) async {
    final box = Hive.box('settings');

    await box.put(
      'dark_mode',
      value,
    );

    isDarkMode.value = value;
  }
}