part of 'setting_bloc.dart';

sealed class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}

class LoadSettingEvent extends SettingEvent {}

class ToggleTogoEvent extends SettingEvent {
  final bool isTogo;
  const ToggleTogoEvent(this.isTogo);

  @override
  List<Object> get props => [isTogo];
}

class ToggleTostayEvent extends SettingEvent {
  final bool isStay;
  const ToggleTostayEvent(this.isStay);

  @override
  List<Object> get props => [isStay];
}

class ToggleShowFoodSetEvent extends SettingEvent {
  final bool isShowFoodSet;
  const ToggleShowFoodSetEvent(this.isShowFoodSet);

  @override
  List<Object> get props => [isShowFoodSet];
}
