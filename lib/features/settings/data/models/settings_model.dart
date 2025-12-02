import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsModel extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;

  const SettingsModel({
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('en'),
  });

  SettingsModel copyWith({
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return SettingsModel(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      themeMode: ThemeMode.values[json['themeMode'] as int],
      locale: Locale(json['locale'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.index,
      'locale': locale.languageCode,
    };
  }

  @override
  List<Object?> get props => [themeMode, locale];
}
