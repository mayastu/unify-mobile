import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/system_settings_model.dart';
import '../../data/repositories/system_settings_repository.dart';

abstract class SystemSettingsState {}

class SystemSettingsInitial extends SystemSettingsState {}

class SystemSettingsLoading extends SystemSettingsState {}

class SystemSettingsSuccess extends SystemSettingsState {
  final SystemSettingsModel settings;

  SystemSettingsSuccess(this.settings);
}

class SystemSettingsFailure extends SystemSettingsState {
  final String message;

  SystemSettingsFailure(this.message);
}

class SystemSettingsCubit extends Cubit<SystemSettingsState> {
  final SystemSettingsRepository repository;

  SystemSettingsCubit(this.repository) : super(SystemSettingsInitial());

  Future<void> getSettings() async {
    emit(SystemSettingsLoading());

    try {
      final settings = await repository.getSettings();
      emit(SystemSettingsSuccess(settings));
    } catch (e) {
      emit(SystemSettingsFailure(e.toString()));
    }
  }
}
