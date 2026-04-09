import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/config/export.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(MenuLoading()) {
    on<LoadMenuEvent>(_onLoadMenu);
    on<SelectSetEvent>(_onSelectSet);
    on<SelectCategoryEvent>(_onSelectCategory);
    on<SearchMenuEvent>(_onSearchMenu);
  }

  Future<void> _onLoadMenu(LoadMenuEvent event, Emitter<MenuState> emit) async {
    emit(MenuLoading());
    try {
      final sets = await FoodService.parseFoodSet();
      final categories = await FoodService.parseFoodCategory();
      final menus = await FoodService.parseFoodMenu();

      String? initialSetId;
      String? initialCategoryId;

      if (sets.isNotEmpty) {
        initialSetId = sets.first.foodSetId;

        /// 🔥 หา menu ที่อยู่ใน set นี้
        final menusInSet =
            menus.where((m) => m.foodSetId == initialSetId).toList();

        /// 🔥 เอา categoryId ที่มีอยู่จริงใน set นี้
        final categoryIdsInSet = menusInSet.map((m) => m.foodCatId).toSet();

        /// 🔥 filter category ให้ตรงกับ set
        final categoriesInSet = categories
            .where((c) => categoryIdsInSet.contains(c.foodCatId))
            .toList();

        if (categoriesInSet.isNotEmpty) {
          initialCategoryId = categoriesInSet.first.foodCatId;
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

      /// 🔥 หา menu ใน set นี้
      final menusInSet =
          currentState.menus.where((m) => m.foodSetId == event.setId).toList();

      /// 🔥 เอา categoryId ที่มีอยู่จริง
      final categoryIds = menusInSet.map((m) => m.foodCatId).toSet();

      /// 🔥 filter category ให้ตรงกับ set
      final categoriesInSet = currentState.categories
          .where((c) => categoryIds.contains(c.foodCatId))
          .toList();

      /// 🔥 เลือก category แรก
      final firstCategoryId =
          categoriesInSet.isNotEmpty ? categoriesInSet.first.foodCatId : null;

      emit(currentState.copyWith(
        selectedSetId: event.setId,
        selectedCategoryId: firstCategoryId, // 🔥 ตรงนี้สำคัญ
      ));
    }
  }

  void _onSelectCategory(SelectCategoryEvent event, Emitter<MenuState> emit) {
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
