// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:meta/meta.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  //
  OrderBloc() : super(OrderLoaded()) {
    /// select category order
    on<SetOrderType>((event, emit) {
      print("[Bloc] OrderType selected: ${event.orderType}");
      if (state is OrderLoaded) {
        emit((state as OrderLoaded).copyWith(orderType: event.orderType));
      } else {
        emit(OrderLoaded(orderType: event.orderType));
      }
    });

    /// confirm order
    on<ConfirmOrderEvent>((event, emit) {
      print("[Bloc] ConfirmOrderEvent received");

      if (event.items.isEmpty) {
        print("[Bloc] Cart is empty");
        return;
      }

      // Map -> OrderItem
      final newOrders = event.items.map((item) {
        return OrderItem(
          foodId: item['foodId'],
          quantity: item['quantity'],
          foodName: '',
          foodPrice: 0,
          foodSetId: '',
        );
      }).toList();

      /// 🔹 print newOrders
      print("----------- NEW ORDERS -----------");

      for (int i = 0; i < newOrders.length; i++) {
        final order = newOrders[i];

        print(
          "[Order $i] "
          "foodId: ${order.foodId} | "
          "quantity: ${order.quantity}",
        );
      }

      /// รวมกับ order เก่า
      //final updatedOrders = [...state.orders, ...newOrders];
      final updatedOrders = [...newOrders];

      /// 🔹 print updatedOrders
      print("----------- ALL ORDERS IN STATE -----------");

      for (int i = 0; i < updatedOrders.length; i++) {
        final order = updatedOrders[i];

        print(
          "[State Order $i] "
          "foodId: ${order.foodId} | "
          "quantity: ${order.quantity}",
        );
      }

      if (state is OrderLoaded) {
        final currentState = state as OrderLoaded;
        print("Orders before: ${currentState.orders.length}");
        print("Orders after: ${updatedOrders.length}");

        // สามารถสั่ง emit(OrderLoading()) ตรงนี้ถ้าต้องการทำ Loading State ได้ในอนาคต
        emit(currentState.copyWith(orders: updatedOrders));
      } else {
        print("Orders before: 0");
        print("Orders after: ${updatedOrders.length}");
        emit(OrderLoaded(orders: updatedOrders));
      }

      print("[Bloc] State updated successfully");
    });
  }
}
