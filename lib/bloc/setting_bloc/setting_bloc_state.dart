part of 'setting_bloc_bloc.dart';

@immutable
class SettingBlocState {
  final bool enableToStay;
  final bool enableToGo;

  const SettingBlocState({
    required this.enableToStay,
    required this.enableToGo,
  });

  SettingBlocState copyWith({bool? enableToStay, bool? enableToGo}) {
    return SettingBlocState(
      enableToStay: enableToStay ?? this.enableToStay,
      enableToGo: enableToGo ?? this.enableToGo,
    );
  }
}
