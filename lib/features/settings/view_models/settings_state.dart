part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final SettingsModel settings;

  const SettingsState({
    this.settings = const SettingsModel(),
  });

  SettingsState copyWith({
    SettingsModel? settings,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object> get props => [settings];
}
