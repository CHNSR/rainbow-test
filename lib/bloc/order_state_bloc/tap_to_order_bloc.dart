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
      print("[Bloc] ConfirmOrderEvent received!");
      print("[Bloc] Event foodSetId: ${event.foodSetId}");
      print("[Bloc] Event cartItems length: ${event.cartItems.length}");
      
      // พิมพ์ข้อมูล cartItems ที่มาถึง
      for (var i = 0; i < event.cartItems.length; i++) {
        final cartItem = event.cartItems[i];
        print("[Bloc] CartItem[$i]: foodId=${cartItem.food.foodId}, foodName=${cartItem.food.foodName}, quantity=${cartItem.quantity}");
      }
      
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

      print("[Bloc] newOrders length: ${newOrders.length}");
      for (var i = 0; i < newOrders.length; i++) {
        final order = newOrders[i];
        print("[Bloc] NewOrder[$i]: foodId=${order.foodId}, foodName=${order.foodName}, quantity=${order.quantity}");
      }

      // รวม orders เหล่าใหม่เข้า state
      final updatedOrders = [...state.orders, ...newOrders];

      print("[Bloc] State.orders before: ${state.orders.length}");
      print("[Bloc] updatedOrders after: ${updatedOrders.length}");
      print("[Bloc] Order Confirmed! Total items: ${updatedOrders.length}");
      print("[Bloc] List in Orders: $updatedOrders");
      print("[Bloc] Total Price: \$${(updatedOrders.fold(0.0, (sum, item) => sum + item.totalPrice)).toStringAsFixed(2)}");

      emit(state.copyWith(orders: updatedOrders));
      print("[Bloc] State emitted! New state orders: ${state.orders.length}");
    });
  }
}
