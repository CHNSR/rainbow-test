import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/config/export.dart';

class CartState extends Equatable {
  final List<CartItem> cartItems;

  const CartState({this.cartItems = const []});

  CartState copyWith({
    List<CartItem>? cartItems,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
    );
  }

  @override
  List<Object?> get props => [cartItems];

  // Helper properties
  double get totalPrice {
    return cartItems.fold(
        0, (total, item) => total + (item.food.foodPrice * item.quantity));
  }

  int get totalItems {
    return cartItems.fold(0, (total, item) => total + item.quantity);
  }
}
