import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderPageCore {
  // confirm order func
  void confirmOrder(BuildContext context) {
    final cartItems = context.read<CartBloc>().state.cartItems;
    final orderItems = cartItems.map((item) {
      return {
        "foodId": item.food.foodId,
        "quantity": item.quantity,
      };
    }).toList();

    if (cartItems.isNotEmpty) {
      /// clear cart
      context.read<CartBloc>().add(
            ClearCartEvent(),
          );

      /// send order ใหม่
      context.read<OrderBloc>().add(
            ConfirmOrderEvent(orderItems),
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Order confirmed!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  dynamic cartTotal(List<CartItem> cartItems) {
    double total = cartItems.fold(
      0,
      (sum, item) => sum + item.totalPrice,
    );
    return total.toStringAsFixed(2);
  }
}
