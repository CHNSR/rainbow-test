import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/config/export.dart';

import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(MenuLoading()) {
    on<LoadMenuEvent>(_onLoadMenu);
    on<SelectSetEvent>(_onSelectSet);
    on<SelectCategoryEvent>(_onSelectCategory);
    on<SearchMenuEvent>(_onSearchMenu);
  }

  Future<void> _onLoadMenu(
      LoadMenuEvent event, Emitter<MenuState> emit) async {
    emit(MenuLoading());
    try {
      final sets = await FoodService.parseFoodSet();
      final categories = await FoodService.parseFoodCategory();
      final menus = await FoodService.parseFoodMenu();

      String? initialSetId;
      String? initialCategoryId;

      if (sets.isNotEmpty) {
        initialSetId = sets.first.foodSetId;

        final menusInSet = menus
            .where((m) => m.foodSetId == initialSetId)
            .toList();
        print("[MenuBloc] Menu Set: ${menusInSet.first.foodSetId}");
        
        if (menusInSet.isNotEmpty) {
          initialCategoryId = menusInSet.first.foodCatId;
        }
      }

      emit(MenuLoaded(
        sets: sets,
        categories: categories,
        menus: menus,
        selectedSetId: initialSetId,
        selectedCategoryId: initialCategoryId,
      ));
    } catch (e) {
      emit(MenuError(e.toString()));
    }
  }

  void _onSelectSet(SelectSetEvent event, Emitter<MenuState> emit) {
    if (state is MenuLoaded) {
      final currentState = state as MenuLoaded;
      
      String? newCategoryId;
      final menusInSet = currentState.menus
          .where((m) => m.foodSetId == event.setId)
          .toList();

      if (menusInSet.isNotEmpty) {
        newCategoryId = menusInSet.first.foodCatId;
      }

      emit(currentState.copyWith(
        selectedSetId: event.setId,
        selectedCategoryId: newCategoryId,
      ));
    }
  }

  void _onSelectCategory(
      SelectCategoryEvent event, Emitter<MenuState> emit) {
    if (state is MenuLoaded) {
      final currentState = state as MenuLoaded;
      emit(currentState.copyWith(selectedCategoryId: event.categoryId));
    }
  }

  void _onSearchMenu(SearchMenuEvent event, Emitter<MenuState> emit) {
    if (state is MenuLoaded) {
      final currentState = state as MenuLoaded;
      emit(currentState.copyWith(searchText: event.searchText));
    }
  }
}
