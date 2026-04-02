import 'dart:math';
import 'dart:io';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_application_1/service/myprinter/myprinter.dart';
import 'package:flutter_application_1/widgets/order_page/receipt_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barcode/barcode.dart';
import 'package:intl/intl.dart';

class OrderPageWidget {
  static Widget topBar({
    required BuildContext context,
    required bool showSearchBar,
    required Function() onToggleSearch,
    required Function(String) onSearchChanged,
  }) {
    final Size size = LandScapeUtils.getResponsiveScreenSize(context);
    final bool isLandscape = LandScapeUtils.isLandscape(context);
    final double screenWidth = size.width;
    final double iconSize = ResponsiveSize.backButtonSize(screenWidth);

    return Padding(
      padding: EdgeInsets.only(
          right: 6,
          top: isLandscape ? screenWidth * 0.015 : screenWidth * 0.06,
          bottom: isLandscape ? screenWidth * 0.01 : screenWidth * 0.02),
      child: Row(
        children: [
          /// Back button
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: ResponsiveSize.backButtonheight(screenWidth),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  minimumSize:
                      Size(20, ResponsiveSize.subcategoryheight(screenWidth)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: Colors.black54,
                      size: iconSize,
                    ),
                    SizedBox(
                      width: screenWidth * 0.004,
                    ),
                    Text(
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      "Back",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: ResponsiveFont.backButton(screenWidth),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          /// Search area (ยาวขึ้น)
          Expanded(
            child: showSearchBar
                ? _SearchWidget(
                    onChanged: onSearchChanged,
                    onClear: onToggleSearch,
                  )
                : Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: ResponsiveSize.backButtonheight(screenWidth),
                      width: ResponsiveSize.backButtonheight(screenWidth),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.all(
                            isLandscape ? iconSize * 0.4 : iconSize * 0.32),
                        iconSize: iconSize,
                        onPressed: onToggleSearch,
                        icon: Image.asset('assets/logo/search_logo.png'),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  static Widget categoryBar({
    required BuildContext context,
    required List<FoodSet> sets,
    required String? selectedSetId,
    required Function(String) onSelect,
  }) {
    final screenWidth = LandScapeUtils.getResponsiveScreenSize(context).width;
    final isLandScape = LandScapeUtils.isLandscape(context);
    return SizedBox(
      height: ResponsiveSize.subcategoryheight(screenWidth),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sets.length,
        itemBuilder: (context, index) {
          final set = sets[index];
          final isSelected = set.foodSetId == selectedSetId;

          return Row(
            children: [
              GestureDetector(
                onTap: () => onSelect(set.foodSetId!),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        isLandScape ? screenWidth * 0.03 : screenWidth * 0.02,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF02CCFE)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6),
                    border: isSelected
                        ? Border.all(
                            color: Colors.grey.shade500,
                            width: 1.0,
                          )
                        : null,
                  ),
                  child: Text(
                    set.foodSetName ?? "",
                    style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: ResponsiveFont.titleCategory(screenWidth),
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              SizedBox(
                  width: isLandScape ? screenWidth * 0.01 : screenWidth * 0.01),
            ],
          );
        },
      ),
    );
  }

  static Widget subCategoryBar({
    required BuildContext context,
    required List<SubFoodCategory> categories,
    required String? selectedCategoryId,
    required Function(String) onSelect,
    required ScrollController scrollController,
  }) {
    final screenSize = LandScapeUtils.getResponsiveScreenSize(context);
    final isLandscape = LandScapeUtils.isLandscape(context);
    final screenWidth = screenSize.width;
    final itemWidth = isLandscape ? screenWidth * 0.1 : screenWidth * 0.18;

    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: ResponsiveSize.subcategoryheight(screenWidth),
        child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = category.foodCatId == selectedCategoryId;

            return GestureDetector(
              onTap: () {
                onSelect(category.foodCatId!);
                scrollController.animateTo(
                  index * itemWidth,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                );
              },
              child: Container(
                width: itemWidth,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF02CCFE)
                      : const Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  category.foodCatName ?? "",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ResponsiveFont.subcategory_size(screenWidth),
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget menuGrid({
    required BuildContext context,
    required List<FoodMenu> foods,
    required List<SubFoodCategory> subcategories,
    required ScrollController? subcategoryScrollController,
    required Map<String, GlobalKey> categoryKeys,
    required ScrollController menuScrollController,
  }) {
    Map<String, List<FoodMenu>> groupFoodByCategory(List<FoodMenu> foods) {
      final Map<String, List<FoodMenu>> map = {};
      for (var food in foods) {
        map.putIfAbsent(food.foodCatId, () => []);
        map[food.foodCatId]!.add(food);
      }
      return map;
    }

    final orientation = MediaQuery.of(context).orientation;
    final crossAxisCount = orientation == Orientation.landscape ? 4 : 2;

    final foodMap = groupFoodByCategory(foods);
    final double aspectRatio = 352 / 354;

    return CustomScrollView(
      controller: menuScrollController,
      slivers: subcategories.map((section) {
        final menu = foodMap[section.foodCatId] ?? [];

        if (menu.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox());
        }

        return SliverMainAxisGroup(
          slivers: [
            /// Category Header
            SliverToBoxAdapter(
              child: Padding(
                key: categoryKeys[section.foodCatId],
                padding: const EdgeInsets.only(
                    top: 16, left: 16, right: 8, bottom: 0),
                child: Text(
                  section.foodCatName,
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF4F4F4F),
                  ),
                ),
              ),
            ),

            /// Menu Grid
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, i) {
                  final food = menu[i];

                  return menuCard(
                    food: food,
                    onAddToCart: () {
                      context.read<OrderfullBloc>().add(
                            AddToCartEvent(food),
                          );
                    },
                  );
                }, childCount: menu.length > 8 ? 8 : menu.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: aspectRatio,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  static Widget menuCard({
    required FoodMenu food,
    required Function() onAddToCart,
  }) {
    return BlocBuilder<OrderfullBloc, OrderfullState>(
      builder: (context, state) {
        int quantity = 0;

        final index = state.cartItems.indexWhere(
          (item) => item.food.foodId == food.foodId,
        );

        if (index != -1) {
          quantity = state.cartItems[index].quantity;
        }

        return GestureDetector(
          onTap: onAddToCart,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  spreadRadius: 0,
                  blurRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double titleSize = constraints.maxWidth * 0.05;
                double descSize = constraints.maxWidth * 0.04;
                double priceSize = constraints.maxWidth * 0.05;

                return Column(
                  children: [
                    /// IMAGE
                    Expanded(
                      flex: 60,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        child: Image.network(
                          food.imageName ?? "",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.broken_image,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// TEXT SECTION
                    Expanded(
                      flex: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// TITLE + QUANTITY
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: titleSize,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          if (quantity > 0)
                                            TextSpan(
                                              text: 'X$quantity ',
                                              style: const TextStyle(
                                                color: Color(0xFF32CD32),
                                              ),
                                            ),
                                          TextSpan(
                                            text: food.foodName ?? '',
                                            style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w500,
                                              fontSize: titleSize,
                                              color: const Color(0xFF4F4F4F),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  /// DESCRIPTION
                                  if ((food.foodDesc ?? "").isNotEmpty)
                                    Text(
                                      food.foodDesc!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: descSize,
                                        color: Colors.grey,
                                      ),
                                    ),
                                ],
                              ),

                              /// PRICE
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "\$${food.foodPrice}",
                                  style: GoogleFonts.roboto(
                                    color: const Color(0xFF4F4F4F),
                                    fontWeight: FontWeight.w500,
                                    fontSize: priceSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  static Widget recieptWidget(
      {required List<OrderItem> orders, required double width}) {
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
          const Text("Tel : 66-5842111"),

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
                    child: FutureBuilder<Widget>(
                      future: Future.value(
                          // PrinterService().createQrCode("https://soisiam.com")
                          Myprinter().createQrCode("https://soisiam.com")),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) return snapshot.data!;
                        return const SizedBox(width: 10, height: 10);
                      },
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

  Future<bool?> showReceiptAndPrint({
    required BuildContext context,
    required List<OrderItem> orders,
    required PrinterConfig config,
    required double receptWidth,
    required String category,
  }) async {
    final GlobalKey repaintKey = GlobalKey();
    // final printerService = PrinterService();
    final myprinter = Myprinter();
    final Size screenSize = LandScapeUtils.getResponsiveScreenSize(context);
    bool isLandscape = LandScapeUtils.isLandscape(context);

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height:
                LandScapeUtils.getResponsiveScreenSize(context).height * 0.7,
            width:
                isLandscape ? screenSize.width * 0.2 : screenSize.width * 0.85,
            child: Column(
              children: [
                /// 🧾 Receipt
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        RepaintBoundary(
                          key: repaintKey,
                          child: category == "kitchen"
                              ? ReceiptWidget.kitchenRecieptWidget(
                                  orders: orders,
                                  width: receptWidth,
                                )
                              : ReceiptWidget.customerRecieptWidget(
                                  orders: orders,
                                  width: receptWidth,
                                ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

                /// 🔘 ปุ่ม
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          final success =
                              // await printerService.addPrintJob(() async {
                              await myprinter.addPrintJob(() async {
                            return await myprinter.printWidgetReceipt(
                              //printerService.printWidgetReceipt(
                              config: config,
                              repaintKey: repaintKey,
                              //orders: orders,
                            );
                          });

                          Navigator.pop(context, success); // ✅ ใช้ได้แล้ว
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text("🖨️ Print"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () =>
                            Navigator.pop(context, null), // ❌ cancel = null
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool?> showReceiptAndPrintMulti({
    required BuildContext context,
    required List<OrderItem> orders,
    required List<PrinterConfig> configs,
    required double receptWidth,
    required String category,
  }) async {
    final GlobalKey repaintKey = GlobalKey();
    // final printerService = PrinterService();
    final myprinter = Myprinter();
    final Size screenSize = LandScapeUtils.getResponsiveScreenSize(context);
    bool isLandscape = LandScapeUtils.isLandscape(context);

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height:
                LandScapeUtils.getResponsiveScreenSize(context).height * 0.7,
            width:
                isLandscape ? screenSize.width * 0.2 : screenSize.width * 0.85,
            child: Column(
              children: [
                /// 🧾 Receipt
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        RepaintBoundary(
                          key: repaintKey,
                          child: category == "kitchen"
                              ? ReceiptWidget.kitchenRecieptWidget(
                                  orders: orders,
                                  width: receptWidth,
                                )
                              : ReceiptWidget.customerRecieptWidget(
                                  orders: orders,
                                  width: receptWidth,
                                ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

                /// 🔘 ปุ่ม
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          bool allSuccess = true;

                          for (final config in configs) {
                            final success =
                                // await printerService.addPrintJob(() async {
                                //   return await printerService.printWidgetReceipt(
                                await myprinter.addPrintJob(() async {
                              return await myprinter.printWidgetReceipt(
                                config: config,
                                repaintKey: repaintKey,
                              );
                            });

                            if (success == false) {
                              allSuccess = false;
                              break;
                            }
                          }

                          Navigator.pop(context, allSuccess);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text("🖨️ Print"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () =>
                            Navigator.pop(context, null), // ❌ cancel = null
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SearchWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchWidget({
    Key? key,
    required this.onChanged,
    required this.onClear,
  }) : super(key: key);

  @override
  State<_SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<_SearchWidget> {
  final TextEditingController controller = TextEditingController();

  void _clear() {
    if (controller.text.isEmpty) {
      widget.onClear();
    } else {
      controller.clear();
      widget.onChanged("");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenwidget = MediaQuery.of(context).size.width;
    final double buttonHeight = ResponsiveSize.backButtonheight(screenwidget);
    final double textSize = ResponsiveFont.backButton(screenwidget);
    return SizedBox(
      height: buttonHeight,
      child: TextField(
        controller: controller,
        onChanged: widget.onChanged,
        style: TextStyle(fontSize: textSize),
        decoration: InputDecoration(
          isDense: true,
          hint: Text("Search foods...",
              maxLines: 1, style: TextStyle(fontSize: textSize)),

          /// 🔹 ปรับ icon ให้ชิด text
          prefixIcon: Padding(
            padding: const EdgeInsets.all(1),
            child: const Icon(Icons.search, size: 12),
          ),

          prefixIconConstraints: const BoxConstraints(
            minWidth: 18,
            minHeight: 18,
          ),

          suffixIcon: IconButton(
            icon: Icon(Icons.clear, size: textSize),
            padding: EdgeInsets.zero,
            onPressed: _clear,
          ),

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),

          /// 🔹 ลด padding เพื่อให้ text ไม่โดนตัด
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 1,
            vertical: 1,
          ),
        ),
      ),
    );
  }
}
