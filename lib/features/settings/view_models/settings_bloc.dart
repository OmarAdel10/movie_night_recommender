import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/settings_model.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<SettingsThemeChanged>(_onThemeChanged);
    on<SettingsLocaleChanged>(_onLocaleChanged);
    on<SettingsLocalAuthChanged>(_onLocalAuthChanged);
  }

  void _onThemeChanged(SettingsThemeChanged event, Emitter<SettingsState> emit) {
    emit(state.copyWith(
      settings: state.settings.copyWith(themeMode: event.themeMode),
    ));
  }

  void _onLocaleChanged(SettingsLocaleChanged event, Emitter<SettingsState> emit) {
    emit(state.copyWith(
      settings: state.settings.copyWith(locale: event.locale),
    ));
  }

  void _onLocalAuthChanged(SettingsLocalAuthChanged event, Emitter<SettingsState> emit) {
    emit(state.copyWith(
      settings: state.settings.copyWith(isLocalAuthEnabled: event.isEnabled),
    ));
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    try {
      final settings = SettingsModel.fromJson(json);
      return SettingsState(settings: settings);
    } catch (_) {
      return const SettingsState();
    }
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return state.settings.toJson();
  }
}
