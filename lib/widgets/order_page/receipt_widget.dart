import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:intl/intl.dart';

class ReceiptWidget extends StatelessWidget {
  final List<OrderItem> orders;

  const ReceiptWidget({super.key, required this.orders});

  double get total =>
      orders.fold<double>(0, (sum, item) => sum + item.totalPrice);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Receipt"),
        ),
        body: Column());
  }
}
