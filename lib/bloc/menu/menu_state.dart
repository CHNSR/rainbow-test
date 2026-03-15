import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/config/export.dart';

abstract class MenuState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<FoodSet> sets;
  final List<SubFoodCategory> categories;
  final List<FoodMenu> menus;

  final String? selectedSetId;
  final String? selectedCategoryId;
  final String searchText;

  MenuLoaded({
    required this.sets,
    required this.categories,
    required this.menus,
    this.selectedSetId,
    this.selectedCategoryId,
    this.searchText = "",
  });

  MenuLoaded copyWith({
    List<FoodSet>? sets,
    List<SubFoodCategory>? categories,
    List<FoodMenu>? menus,
    String? selectedSetId,
    String? selectedCategoryId,
    String? searchText,
  }) {
    return MenuLoaded(
      sets: sets ?? this.sets,
      categories: categories ?? this.categories,
      menus: menus ?? this.menus,
      selectedSetId: selectedSetId ?? this.selectedSetId,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchText: searchText ?? this.searchText,
    );
  }

  @override
  List<Object?> get props => [
    sets,
    categories,
    menus,
    selectedSetId,
    selectedCategoryId,
    searchText,
  ];

  // Helper getters (logic moved from order_controller)
  List<FoodMenu> get filteredMenus {
    return MenuFilter.filterMenus(
      menus: MenuFilter.filterMenus(
        menus: menus,
        foodSetId: selectedSetId,
        searchText: searchText,
      ),
    );
  }

  List<SubFoodCategory> get filteredCategories {
    if (selectedSetId == null) return [];

    final foodCatsInSet = menus
        .where((m) => m.foodSetId == selectedSetId)
        .map((m) => m.foodCatId)
        .toSet();

    return categories
        .where((c) => foodCatsInSet.contains(c.foodCatId))
        .toList();
  }
}

class MenuError extends MenuState {
  final String message;
  MenuError(this.message);

  @override
  List<Object?> get props => [message];
}
