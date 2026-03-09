part of 'setting_bloc_bloc.dart';

@immutable
sealed class SettingBlocEvent {}

class ToggleToStay extends SettingBlocEvent {
  final bool value;

  ToggleToStay(this.value);
}

class ToggleToGo extends SettingBlocEvent {
  final bool value;

  ToggleToGo(this.value);
}
