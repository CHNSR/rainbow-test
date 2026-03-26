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
    return Container(
      color: Colors.white,
      width: 300, // 🔥 สำคัญ (ใกล้เคียง 58mm)
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼️ Logo
          Center(
            child: Image.asset(
              'assets/logo/smile_logo.png',
              width: 120,
            ),
          ),

          const SizedBox(height: 8),

          // 🏪 Shop Name
          const Center(
            child: Text(
              "Soi Siam Restaurant",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          const SizedBox(height: 4),

          // ☎️ Phone
          const Center(
            child: Text("66-5842111"),
          ),

          const SizedBox(height: 4),

          // 📅 Date Time
          Center(
            child: Text(
              "Date: ${DateFormat.yMd().format(DateTime.now())}  "
              "Time: ${DateFormat.Hms().format(DateTime.now())}",
              style: const TextStyle(fontSize: 10),
            ),
          ),

          const SizedBox(height: 8),
          const Divider(),

          // 📦 Items
          ...orders.map((order) {
            return Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Text("x${order.quantity} ${order.foodName}"),
                ),
                Expanded(
                  flex: 4,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(order.foodPrice.toStringAsFixed(2)),
                  ),
                ),
              ],
            );
          }),

          const Divider(),

          // 💰 TOTAL
          Row(
            children: [
              const Expanded(
                flex: 6,
                child: Text(
                  "TOTAL",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 6,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    total.toStringAsFixed(2),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
