part of 'setting_bloc.dart';

sealed class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

final class SettingInitial extends SettingState {
  const SettingInitial();
}

final class SettingLoaded extends SettingState {
  final bool isTogo;
  final bool isStay;
  final bool isShowFoodSet;

  const SettingLoaded(
      {required this.isTogo,
      required this.isStay,
      required this.isShowFoodSet});

  @override
  List<Object> get props => [isTogo, isStay, isShowFoodSet];

  SettingLoaded copyWith({
    bool? isTogo,
    bool? isStay,
    bool? isShowFoodSet,
  }) {
    return SettingLoaded(
      isTogo: isTogo ?? this.isTogo,
      isStay: isStay ?? this.isStay,
      isShowFoodSet: isShowFoodSet ?? this.isShowFoodSet,
    );
  }
}

final class SettingLoadingFailure extends SettingState {
  final String message;

  const SettingLoadingFailure(this.message);

  @override
  List<Object> get props => [message];
}
