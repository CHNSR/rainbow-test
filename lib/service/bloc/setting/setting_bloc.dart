import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive_ce.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingInitial()) {
    on<LoadSettingEvent>((event, emit) async {
      try {
        final box = await Hive.openBox('settings');
        final isTogo = box.get('isTogo', defaultValue: true);
        final isStay = box.get('isStay', defaultValue: true);
        final isShowFoodSet = box.get('isShowFoodSet', defaultValue: true);

        emit(SettingLoaded(
          isTogo: isTogo,
          isStay: isStay,
          isShowFoodSet: isShowFoodSet,
        ));
      } catch (e) {
        emit(SettingLoadingFailure(e.toString()));
      }
    });

    on<ToggleTogoEvent>((event, emit) async {
      if (state is SettingLoaded) {
        final currentState = state as SettingLoaded;
        final box = await Hive.openBox('settings');
        await box.put('isTogo', event.isTogo);
        emit(currentState.copyWith(isTogo: event.isTogo));
      }
    });

    on<ToggleTostayEvent>((event, emit) async {
      if (state is SettingLoaded) {
        final currentState = state as SettingLoaded;
        final box = await Hive.openBox('settings');
        await box.put('isStay', event.isStay);
        emit(currentState.copyWith(isStay: event.isStay));
      }
    });

    on<ToggleShowFoodSetEvent>((event, emit) async {
      if (state is SettingLoaded) {
        final currentState = state as SettingLoaded;
        final box = await Hive.openBox('settings');
        await box.put('isShowFoodSet', event.isShowFoodSet);
        emit(currentState.copyWith(isShowFoodSet: event.isShowFoodSet));
      }
    });
  }
}
