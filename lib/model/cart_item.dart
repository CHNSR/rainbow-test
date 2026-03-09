import 'package:flutter_application_1/model/food_menu.dart';

class CartItem {
  final FoodMenu food;
  int quantity;

  CartItem({required this.food, this.quantity = 1});

  double get totalPrice => food.foodPrice * quantity;
}
