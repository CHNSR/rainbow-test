import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/config/export.dart';

abstract class CartState extends Equatable {
  final List<CartItem> cartItems;

  const CartState({this.cartItems = const []});

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

class CartInitial extends CartState {
  const CartInitial() : super(cartItems: const []);
}

class CartLoading extends CartState {
  const CartLoading({super.cartItems});
}

class CartLoaded extends CartState {
  const CartLoaded({super.cartItems});

  CartLoaded copyWith({
    List<CartItem>? cartItems,
  }) {
    return CartLoaded(
      cartItems: cartItems ?? this.cartItems,
    );
  }
}

class CartError extends CartState {
  final String message;

  const CartError(this.message, {super.cartItems});

  @override
  List<Object?> get props => [message, cartItems];
}
