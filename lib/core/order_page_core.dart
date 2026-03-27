import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderPageCore {
  //confirm order func
  void confirmOrder(BuildContext context) {
    final cartItems = context.read<CartBloc>().state.cartItems;
    final orderItems = cartItems.map((item) {
      return {
        "foodId": item.food.foodId,
        "quantity": item.quantity,
        "foodName": item.food.foodName,
        "foodPrice": item.food.foodPrice,
        "foodSetId": item.food.foodSetId,
      };
    }).toList();

    if (cartItems.isNotEmpty) {
      /// send order ใหม่
      context.read<OrderBloc>().add(
            ConfirmOrderEvent(orderItems),
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
