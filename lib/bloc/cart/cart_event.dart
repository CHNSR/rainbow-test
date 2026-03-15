import 'package:flutter_application_1/config/export.dart';

abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  final FoodMenu food;
  AddToCartEvent(this.food);
}

class RemoveFromCartEvent extends CartEvent {
  final FoodMenu food;
  RemoveFromCartEvent(this.food);
}

class ClearCartEvent extends CartEvent {}
