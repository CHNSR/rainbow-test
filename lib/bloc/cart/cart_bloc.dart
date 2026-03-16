import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/config/export.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    final List<CartItem> updatedCart = List.from(state.cartItems);
    print('[BLOC]: updatedCart.length :$updatedCart');
    final index = updatedCart.indexWhere(
      (item) => item.food.foodId == event.food.foodId,
    );

    if (index != -1) {
      // Modify the item within the new list to maintain immutability
      final existingItem = updatedCart[index];
      updatedCart[index] = CartItem(
          food: existingItem.food, quantity: existingItem.quantity + 1);
    } else {
      updatedCart.add(CartItem(food: event.food, quantity: 1));
    }

    emit(state.copyWith(cartItems: updatedCart));
  }

  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) {
    final List<CartItem> updatedCart = List.from(state.cartItems);

    final index = updatedCart.indexWhere(
      (item) => item.food.foodId == event.food.foodId,
    );

    if (index != -1) {
      final existingItem = updatedCart[index];
      if (existingItem.quantity > 1) {
        updatedCart[index] = CartItem(
            food: existingItem.food, quantity: existingItem.quantity - 1);
      } else {
        updatedCart.removeAt(index);
      }
      emit(state.copyWith(cartItems: updatedCart));
    }
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    emit(const CartState(cartItems: []));
  }
}
