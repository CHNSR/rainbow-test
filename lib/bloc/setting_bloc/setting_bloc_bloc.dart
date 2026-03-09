import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'setting_bloc_event.dart';
part 'setting_bloc_state.dart';

class SettingBloc extends Bloc<SettingBlocEvent, SettingBlocState> {
  SettingBloc()
    : super(SettingBlocState(enableToStay: true, enableToGo: true)) {
    on<ToggleToStay>((event, emit) {
      emit(state.copyWith(enableToStay: event.value));
    });
    on<ToggleToGo>((event, emit) {
      emit(state.copyWith(enableToGo: event.value));
    });
  }
}
