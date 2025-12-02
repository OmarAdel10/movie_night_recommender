part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

final class SettingsThemeChanged extends SettingsEvent {
  final ThemeMode themeMode;

  const SettingsThemeChanged(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

final class SettingsLocaleChanged extends SettingsEvent {
  final Locale locale;

  const SettingsLocaleChanged(this.locale);

  @override
  List<Object> get props => [locale];
}


