import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderFullPageCore {
  //confirm order func
  void confirmOrder(BuildContext context) {
    final cartItems = context.read<OrderfullBloc>().state.cartItems;

    if (cartItems.isNotEmpty) {
      context.read<OrderfullBloc>().add(
            ConfirmOrderEvent(),
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
