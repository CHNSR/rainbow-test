// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:meta/meta.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
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

      print("[Bloc] Stored Order state Success ");
    });
  }
}
