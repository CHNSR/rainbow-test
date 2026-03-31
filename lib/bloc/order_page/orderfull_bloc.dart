import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_application_1/model/order_item.dart';

part 'orderfull_event.dart';
part 'orderfull_state.dart';

class OrderfullBloc extends Bloc<OrderfullEvent, OrderfullState> {
  OrderfullBloc() : super(OrderfullInitial()) {
    on<AddToCartEvent>((event, emit) {
      emit(OrderfullLoading(
        cartItems: state.cartItems,
        orders: state.orders,
        orderType: state.orderType,
      ));

      final List<CartItem> updatedCart = List.from(state.cartItems);

      final index = updatedCart.indexWhere(
        (item) => item.food.foodId == event.food.foodId,
      );

      if (index != -1) {
        final existingItem = updatedCart[index];

        updatedCart[index] = CartItem(
          food: existingItem.food,
          quantity: existingItem.quantity + 1,
        );
      } else {
        updatedCart.add(
          CartItem(
            food: event.food,
            quantity: 1,
          ),
        );
      }

      emit(OrderfullLoaded(
        cartItems: updatedCart,
        orders: state.orders,
        orderType: state.orderType,
      ));
    });

    on<RemoveFromCartEvent>((event, emit) {
      emit(OrderfullLoading(
        cartItems: state.cartItems,
        orders: state.orders,
        orderType: state.orderType,
      ));

      final List<CartItem> updatedCart = List.from(state.cartItems);

      final index = updatedCart
          .indexWhere((item) => item.food.foodId == event.food.foodId);

      if (index != -1) {
        final existingItem = updatedCart[index];
        if (existingItem.quantity > 1) {
          updatedCart[index] = CartItem(
            food: existingItem.food,
            quantity: existingItem.quantity - 1,
          );
        } else {
          updatedCart.removeAt(index);
        }
        emit(OrderfullLoaded(
          cartItems: updatedCart,
          orders: state.orders,
          orderType: state.orderType,
        ));
      } else {
        emit(OrderfullLoaded(
          cartItems: state.cartItems,
          orders: state.orders,
          orderType: state.orderType,
        ));
      }
    });

    on<ClearCartEvent>((event, emit) {
      emit(OrderfullLoading(
        cartItems: state.cartItems,
        orders: state.orders,
        orderType: state.orderType,
      ));
      emit(OrderfullLoaded(
        cartItems: [],
        orders: state.orders,
        orderType: state.orderType,
      ));
    });

    // ---------------------------clear cart event---------------------------

    on<SetOrderTypeEvent>(
      (event, emit) {
        if (state is OrderfullLoaded) {
          emit((state as OrderfullLoaded).copyWith(orderType: event.orderType));
        } else {
          emit(OrderfullLoaded(
            orderType: event.orderType,
            cartItems: state.cartItems,
            orders: state.orders,
          ));
        }
      },
    );

    on<ConfirmOrderEvent>((event, emit) {
      if (state.cartItems.isEmpty) return;

      final newOrders = state.cartItems.map((item) {
        return OrderItem(
          foodId: item.food.foodId,
          foodName: item.food.foodName,
          foodPrice: item.food.foodPrice,
          quantity: item.quantity,
          foodSetId: item.food.foodSetId,
        );
      }).toList();

      final prevState = state;

      emit(OrderfullSuccess(
        cartItems: prevState.cartItems,
        orders: newOrders,
        orderType: prevState.orderType,
      ));

      emit(OrderfullLoaded(
        cartItems: prevState.cartItems, // เคลียร์ cart
        orders: newOrders,
        orderType: prevState.orderType,
      ));
    });
  }
}
