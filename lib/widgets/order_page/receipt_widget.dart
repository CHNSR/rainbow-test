import 'package:barcode_widget/barcode_widget.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:intl/intl.dart';

class ReceiptWidget {
  static Widget customerRecieptWidget(
      {required List<OrderItem> orders,
      required double width,
      required String orderType}) {
    double total = orders.fold<double>(0, (sum, item) => sum + item.totalPrice);

    return Container(
      color: Colors.white,
      width: width,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  🖼️ Logo 🏪 Shop Name
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Column(
              children: [
                DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.1,
                  dashLength: 4.0,
                  dashColor: Colors.black,
                  dashGapLength: 2.0,
                ),
                const SizedBox(height: 2),
                DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.1,
                  dashLength: 4.0,
                  dashColor: Colors.black,
                  dashGapLength: 2.0,
                )
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo/smile_logo.png',
                width: 18,
              ),
              const SizedBox(width: 10),
              Text(
                "Soi Siam Restaurant",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          const Center(child: Text("Authentic Thai Cuisine")),

          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Column(
              children: [
                DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.0,
                  dashLength: 4.0,
                  dashColor: Colors.black,
                  dashGapLength: 2.0,
                ),
                const SizedBox(height: 2),
                DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.0,
                  dashLength: 4.0,
                  dashColor: Colors.black,
                  dashGapLength: 2.0,
                )
              ],
            ),
          ),

          // ☎️ Phone
          Row(
            children: [
              const Text("Tel : 66-5842111"),
              Text("Order Type: $orderType"),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Date: ${DateFormat.yMd().format(DateTime.now())}"),
              Text("Time: ${DateFormat.Hm().format(DateTime.now())}")
            ],
          ),

          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: DottedLine(
              direction: Axis.horizontal,
              lineLength: double.infinity,
              lineThickness: 1.0,
              dashLength: 4.0,
              dashColor: Colors.black,
              dashGapLength: 2.0,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(flex: 1, child: Text("QTY")),
              Expanded(flex: 7, child: Text("ITEM")),
              Expanded(
                  flex: 2,
                  child: Align(
                      alignment: Alignment.centerRight, child: Text("PRICE"))),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: DottedLine(
              direction: Axis.horizontal,
              lineLength: double.infinity,
              lineThickness: 1.0,
              dashLength: 4.0,
              dashColor: Colors.black,
              dashGapLength: 2.0,
            ),
          ),

          // 📦 Items
          ...orders.map((order) {
            return Row(
              children: [
                Expanded(flex: 1, child: Text("${order.quantity}")),
                Expanded(
                  flex: 7,
                  child: Text(" ${order.foodName}"),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(order.foodPrice.toStringAsFixed(2)),
                  ),
                ),
              ],
            );
          }),

          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: DottedLine(
              direction: Axis.horizontal,
              lineLength: double.infinity,
              lineThickness: 1.0,
              dashLength: 4.0,
              dashColor: Colors.black,
              dashGapLength: 2.0,
            ),
          ),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Subtotal:"),
            Text(total.toStringAsFixed(2))
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("TAX (0%)"), Text("0.00")],
          ),

          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: DottedLine(
              direction: Axis.horizontal,
              lineLength: double.infinity,
              lineThickness: 1.0,
              dashLength: 4.0,
              dashColor: Colors.black,
              dashGapLength: 2.0,
            ),
          ),
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
                    "\$ ${total.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: _divider(
              amountLine: 1,
              thickness: 1.0,
              dashLength: 4.0,
              dashGap: 2.0,
              spacing: 2.0,
            ),
          ),

          //barcode qr code section
          Center(
            child: BarcodeWidget(
              barcode: Barcode.code128(),
              data: "https://soisiam.com",
              width: double.infinity,
              height: 30,
              drawText: false,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: _divider(
              amountLine: 2,
              thickness: 1.0,
              dashLength: 4.0,
              dashGap: 2.0,
              spacing: 2.0,
            ),
          ),

          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: BarcodeWidget(
                      barcode: Barcode.qrCode(),
                      data: "https://soisiam.com",
                      drawText: false,
                    ),
                  ),
                  Text(
                    "feedback us!",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 5),
                  ),
                ],
              ),
              Column(
                children: [
                  Text("Thank you for your visit!",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 10)),
                  Text("Please come back and see us.",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 10)),
                ],
              ),
            ],
          )),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  static Widget kitchenRecieptWidget(
      {required List<OrderItem> orders,
      required double width,
      required String orderType}) {
    double total = orders.fold<double>(0, (sum, item) => sum + item.totalPrice);

    return Container(
      color: Colors.white,
      width: width,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  🖼️ Logo 🏪 Shop Name
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Column(
              children: [
                DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.1,
                  dashLength: 4.0,
                  dashColor: Colors.black,
                  dashGapLength: 2.0,
                ),
                const SizedBox(height: 2),
                DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.1,
                  dashLength: 4.0,
                  dashColor: Colors.black,
                  dashGapLength: 2.0,
                )
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo/smile_logo.png',
                width: 18,
              ),
              const SizedBox(width: 10),
              Text(
                "Soi Siam Restaurant",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          const Center(
              child: Text(
            "Kitchen Reciept",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )),

          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Column(
              children: [
                DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.0,
                  dashLength: 4.0,
                  dashColor: Colors.black,
                  dashGapLength: 2.0,
                ),
                const SizedBox(height: 2),
                DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.0,
                  dashLength: 4.0,
                  dashColor: Colors.black,
                  dashGapLength: 2.0,
                )
              ],
            ),
          ),

          // ☎️ Phone
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Order Type: $orderType"),
              const Text("Tel : 66-5842111"),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Date: ${DateFormat.yMd().format(DateTime.now())}"),
              Text("Time: ${DateFormat.Hm().format(DateTime.now())}")
            ],
          ),

          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: DottedLine(
              direction: Axis.horizontal,
              lineLength: double.infinity,
              lineThickness: 1.0,
              dashLength: 4.0,
              dashColor: Colors.black,
              dashGapLength: 2.0,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(flex: 1, child: Text("QTY")),
              Expanded(flex: 7, child: Text("ITEM")),
              Expanded(
                  flex: 2,
                  child: Align(
                      alignment: Alignment.centerRight, child: Text("PRICE"))),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: DottedLine(
              direction: Axis.horizontal,
              lineLength: double.infinity,
              lineThickness: 1.0,
              dashLength: 4.0,
              dashColor: Colors.black,
              dashGapLength: 2.0,
            ),
          ),

          // 📦 Items
          ...orders.map((order) {
            return Row(
              children: [
                Expanded(flex: 1, child: Text("${order.quantity}")),
                Expanded(
                  flex: 7,
                  child: Text(" ${order.foodName}"),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(order.foodPrice.toStringAsFixed(2)),
                  ),
                ),
              ],
            );
          }),

          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: DottedLine(
              direction: Axis.horizontal,
              lineLength: double.infinity,
              lineThickness: 1.0,
              dashLength: 4.0,
              dashColor: Colors.black,
              dashGapLength: 2.0,
            ),
          ),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Subtotal:"),
            Text(total.toStringAsFixed(2))
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("TAX (0%)"), Text("0.00")],
          ),

          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: DottedLine(
              direction: Axis.horizontal,
              lineLength: double.infinity,
              lineThickness: 1.0,
              dashLength: 4.0,
              dashColor: Colors.black,
              dashGapLength: 2.0,
            ),
          ),
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
                    "\$ ${total.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: _divider(
              amountLine: 1,
              thickness: 1.0,
              dashLength: 4.0,
              dashGap: 2.0,
              spacing: 2.0,
            ),
          ),

          //barcode qr code section
          Center(
            child: BarcodeWidget(
              barcode: Barcode.code128(),
              data: "https://soisiam.com",
              width: double.infinity,
              height: 30,
              drawText: false,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: _divider(
              amountLine: 2,
              thickness: 1.0,
              dashLength: 4.0,
              dashGap: 2.0,
              spacing: 2.0,
            ),
          ),

          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: BarcodeWidget(
                      barcode: Barcode.qrCode(),
                      data: "https://soisiam.com",
                      drawText: false,
                    ),
                  ),
                  Text(
                    "feedback us!",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 5),
                  ),
                ],
              ),
              Column(
                children: [
                  Text("Thank you for your visit!",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 10)),
                  Text("Please come back and see us.",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 10)),
                ],
              ),
            ],
          )),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
  // ------------------------------ component: divider ------------------------------

  static Widget _divider({
    int amountLine = 1,
    double thickness = 1,
    double dashLength = 4,
    double dashGap = 2,
    double spacing = 2,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(amountLine, (index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DottedLine(
              direction: Axis.horizontal,
              lineLength: double.infinity,
              lineThickness: thickness,
              dashLength: dashLength,
              dashGapLength: dashGap,
              dashColor: Colors.black,
            ),

            // ❗ เว้นช่องเฉพาะ "ไม่ใช่ตัวสุดท้าย"
            if (index != amountLine - 1) SizedBox(height: spacing),
          ],
        );
      }),
    );
  }
}
