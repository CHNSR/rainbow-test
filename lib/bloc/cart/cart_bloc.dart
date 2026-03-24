import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/config/export.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartInitial()) {
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    emit(CartLoading(cartItems: state.cartItems));

    final List<CartItem> updatedCart = List.from(state.cartItems);
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

    emit(CartLoaded(cartItems: updatedCart));
  }

  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) {
    emit(CartLoading(cartItems: state.cartItems));

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
      emit(CartLoaded(cartItems: updatedCart));
    } else {
      emit(CartLoaded(cartItems: state.cartItems));
    }
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    emit(const CartLoading(cartItems: []));
    emit(const CartLoaded(cartItems: []));
  }
}
