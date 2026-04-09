part of 'setting_bloc.dart';

sealed class SettingState extends Equatable {
  const SettingState();
  
  @override
  List<Object> get props => [];
}

final class SettingInitial extends SettingState {}
