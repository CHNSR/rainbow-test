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
    // on<ConfirmOrderEvent>((event, emit) {
    //   print("[Bloc] ConfirmOrderEvent received");

    //   if (event.items.isEmpty) {
    //     print("[Bloc] Cart is empty");
    //     return;
    //   }

    //   // Map -> OrderItem
    //   final newOrders = event.items.map((item) {
    //     return OrderItem(
    //       foodId: item['foodId'],
    //       quantity: item['quantity'],
    //       foodName: '',
    //       foodPrice: 0,
    //       foodSetId: '',
    //     );
    //   }).toList();

    //   /// 🔹 print newOrders
    //   print("----------- NEW ORDERS -----------");

    //   for (int i = 0; i < newOrders.length; i++) {
    //     final order = newOrders[i];

    //     print(
    //       "[Order $i] "
    //       "foodId: ${order.foodId} | "
    //       "quantity: ${order.quantity}",
    //     );
    //   }

    //   /// รวมกับ order เก่า
    //   //final updatedOrders = [...state.orders, ...newOrders];
    //   final updatedOrders = [...newOrders];

    //   /// 🔹 print updatedOrders
    //   print("----------- ALL ORDERS IN STATE -----------");

    //   for (int i = 0; i < updatedOrders.length; i++) {
    //     final order = updatedOrders[i];

    //     print(
    //       "[State Order $i] "
    //       "foodId: ${order.foodId} | "
    //       "quantity: ${order.quantity}",
    //     );
    //   }

    //   if (state is OrderLoaded) {
    //     final currentState = state as OrderLoaded;
    //     print("Orders before: ${currentState.orders.length}");
    //     print("Orders after: ${updatedOrders.length}");

    //     // สามารถสั่ง emit(OrderLoading()) ตรงนี้ถ้าต้องการทำ Loading State ได้ในอนาคต
    //     emit(currentState.copyWith(orders: updatedOrders));
    //   } else {
    //     print("Orders before: 0");
    //     print("Orders after: ${updatedOrders.length}");
    //     emit(OrderLoaded(orders: updatedOrders));
    //   }

    //   print("[Bloc] State updated successfully");
    // });

    on<ConfirmOrderEvent>((event, emit) async {
      print("[Bloc] ConfirmOrderEvent received");

      if (event.items.isEmpty) {
        print("[Bloc] Cart is empty");
        return;
      }

      final newOrders = event.items.map((item) {
        return OrderItem(
          foodId: item['foodId'] as String,
          quantity: item['quantity'] as int,
          foodName: item['foodName'] as String,
          foodPrice: (item['foodPrice'] as num).toDouble(),
          foodSetId: item['foodSetId'] as String,
        );
      }).toList();

      print("\n[Bloc] 📦 Parsed ${newOrders.length} items for order:");
      for (var o in newOrders) {
        print(
            "       -> x${o.quantity} [${o.foodId}] ${o.foodName} | \$${o.foodPrice}");
      }

      final updatedOrders = [...newOrders];

      // Get the current state, or a default OrderLoaded state if it's not loaded yet.
      final currentState =
          state is OrderLoaded ? (state as OrderLoaded) : OrderLoaded();

      print("\n========== 🧾 ORDER SUCCESS ==========");

      print("Total items: ${updatedOrders.length}");

      double total = 0;

      for (int i = 0; i < updatedOrders.length; i++) {
        final o = updatedOrders[i];

        print(
          "[Item $i] "
          "x${o.quantity} | "
          "ID: ${o.foodId} | "
          "Name: ${o.foodName} | "
          "Price: ${o.foodPrice} | "
          "Total: ${o.totalPrice}",
        );

        total += o.totalPrice;
      }

      print("--------------------------------------");
      print("TOTAL PRICE: $total");
      print("======================================\n");

      // First, emit the success state for the listener to catch.
      emit(OrderSuccess(updatedOrders));

      // Then, immediately emit the new loaded state to keep the UI consistent and stable.
      emit(currentState.copyWith(orders: updatedOrders));

      print("[Bloc] Order Success emitted");
    });
  }
}
