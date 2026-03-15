import 'package:flutter_application_1/config/export.dart';

abstract class MenuEvent {}

class LoadMenuEvent extends MenuEvent {}

class SelectSetEvent extends MenuEvent {
  final String setId;
  SelectSetEvent(this.setId);
}

class SelectCategoryEvent extends MenuEvent {
  final String categoryId;
  SelectCategoryEvent(this.categoryId);
}

class SearchMenuEvent extends MenuEvent {
  final String searchText;
  SearchMenuEvent(this.searchText);
}
