import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsModel extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;
  final bool isLocalAuthEnabled;

  const SettingsModel({
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('en'),
    this.isLocalAuthEnabled = false,
  });

  SettingsModel copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? isLocalAuthEnabled,
  }) {
    return SettingsModel(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      isLocalAuthEnabled: isLocalAuthEnabled ?? this.isLocalAuthEnabled,
    );
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      themeMode: ThemeMode.values[json['themeMode'] as int],
      locale: Locale(json['locale'] as String),
      isLocalAuthEnabled: json['isLocalAuthEnabled'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.index,
      'locale': locale.languageCode,
      'isLocalAuthEnabled': isLocalAuthEnabled,
    };
  }

  @override
  List<Object?> get props => [themeMode, locale, isLocalAuthEnabled];
}
