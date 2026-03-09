import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:meta/meta.dart';

part 'tap_to_order_event.dart';
part 'tap_to_order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const OrderState()) {
    on<SetOrderType>((event, emit) {
      print("[Bloc] OrderType selected: ${event.orderType}");
      emit(state.copyWith(orderType: event.orderType));
    });

    on<ConfirmOrderEvent>((event, emit) {
      // สร้าง OrderItem list จาก CartItem
      final newOrders = event.cartItems.map((cartItem) {
        return OrderItem(
          foodSetId: event.foodSetId,
          foodId: cartItem.food.foodId,
          foodName: cartItem.food.foodName,
          foodPrice: cartItem.food.foodPrice,
          quantity: cartItem.quantity,
        );
      }).toList();

      // รวม orders เหล่าใหม่เข้า state
      final updatedOrders = [...state.orders, ...newOrders];

      print("[Bloc] Order Confirmed! Total items: ${updatedOrders.length}");
      print("[Bloc] Total Price: \$${state.totalPrice.toStringAsFixed(2)}");

      emit(state.copyWith(orders: updatedOrders));
    });
  }
}
