import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/config/export.dart';

class OrderPages extends StatefulWidget {
  const OrderPages({super.key});

  @override
  State<OrderPages> createState() => _OrderPagesState();
}

class _OrderPagesState extends State<OrderPages> {
  List<FoodSet> sets = [];
  List<SubFoodCategory> categories = [];
  List<FoodMenu> menus = [];
  List<CartItem> cartItems = [];

  String? selectedSetId;
  String? selectedCategoryId;
  String searchText = "";

  bool isLoading = true;
  final AutoSizeGroup nameGroup = AutoSizeGroup();
  final AutoSizeGroup descGroup = AutoSizeGroup();
  final AutoSizeGroup priceGroup = AutoSizeGroup();
  bool showSearchBar = false;

  late ScrollController _menuScrollController;

  @override
  void initState() {
    super.initState();
    _menuScrollController = ScrollController();
    loadData();
  }

  @override
  void dispose() {
    _menuScrollController.dispose();
    super.dispose();
  }

  //filter menu ตาม set, category, search
  List<FoodMenu> get filteredMenus {
    return MenuFilter.filterMenus(
      menus: menus,
      foodSetId: selectedSetId,
      foodCatId: selectedCategoryId,
      searchText: searchText,
    );
  }

  List<SubFoodCategory> get filteredCategories {
    if (selectedSetId == null) {
      return [];
    }

    // ได้ foodCatId ทั้งหมดจาก menu ที่อยู่ใน set นี้
    final foodCatsInSet = menus
        .where((m) => m.foodSetId == selectedSetId)
        .map((m) => m.foodCatId)
        .toSet();

    // Filter categories ให้เฉพาะที่มี foodCatId ใน set นี้
    return categories
        .where((c) => foodCatsInSet.contains(c.foodCatId))
        .toList();
  }

  void loadData() async {
    sets = await FoodService.parseFoodSet();
    categories = await FoodService.parseFoodCategory();
    menus = await FoodService.parseFoodMenu();

    // Set default: category แรก และ sub-category แรก
    if (sets.isNotEmpty) {
      // set ตัวแรก
      selectedSetId = sets.first.foodSetId;

      // menu ของ set นี้
      final menusInSet = menus
          .where((m) => m.foodSetId == selectedSetId)
          .toList();

      if (menusInSet.isNotEmpty) {
        selectedCategoryId = menusInSet.first.foodCatId;
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  void addToCart(FoodMenu food) {
    setState(() {
      // ตรวจสอบว่า item นี้มีใน cart แล้วหรือไม่
      final existingIndex = cartItems.indexWhere(
        (item) => item.food.foodId == food.foodId,
      );

      if (existingIndex != -1) {
        // ถ้ามีแล้ว เพิ่มจำนวน
        cartItems[existingIndex].quantity++;
      } else {
        // ถ้าไม่มี เพิ่ม item ใหม่
        cartItems.add(CartItem(food: food, quantity: 1));
      }
    });
  }

  double get cartTotal {
    return cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  void confirmOrder() {
    // ส่ง event ไป BLoC
    if (cartItems.isNotEmpty && selectedSetId != null) {
      context.read<OrderBloc>().add(
        ConfirmOrderEvent(foodSetId: selectedSetId!, cartItems: cartItems),
      );

      // ล้าง cart หลังสั่งซื้อ
      setState(() {
        cartItems.clear();
      });

      // Optional: แสดง snackbar ให้ user เห็น
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Order confirmed!"),
          duration: Duration(milliseconds: 1500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Row(
              children: [
                /// 🔹 LEFT SIDE (MENU)
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      TopBar(
                        showSearchBar: showSearchBar,
                        onToggleSearch: () {
                          setState(() {
                            showSearchBar = !showSearchBar;
                          });
                        },
                        onSearchChanged: (value) {
                          setState(() {
                            searchText = value;
                          });
                        },
                      ),

                      CategoryBar(
                        sets: sets,
                        selectedSetId: selectedSetId,
                        onSelect: (setId) {
                          setState(() {
                            selectedSetId = setId;

                            final menusInSet = menus
                                .where((m) => m.foodSetId == selectedSetId)
                                .toList();

                            if (menusInSet.isNotEmpty) {
                              selectedCategoryId = menusInSet.first.foodCatId;
                            }
                          });
                          // Scroll ไปยัง item แรก
                          _menuScrollController.animateTo(
                            0.0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                      SizedBox(height: 8),
                      SubCategoryBar(
                        categories: filteredCategories,
                        selectedCategoryId: selectedCategoryId,
                        onSelect: (catId) {
                          setState(() {
                            selectedCategoryId = catId;
                          });
                          // Scroll ไปยัง item แรก
                          _menuScrollController.animateTo(
                            0.0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                      Expanded(
                        child: MenuGrid(
                          foods: filteredMenus,
                          scrollController: _menuScrollController,
                          onAddToCart: addToCart,
                        ),
                      ),
                    ],
                  ),
                ),

                /// 🔹 RIGHT SIDE (CART)
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: _buildCartSection(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: AutoSizeText(
              "My Order",
              maxLines: 1,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const Divider(),

          // Cart Items List
          Expanded(
            child: cartItems.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        "No order selected",
                        maxLines: 1,
                        minFontSize: 8,
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200, // สีเทาอ่อน
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cartItem.food.foodName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "\$${cartItem.food.foodPrice.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (cartItem.quantity > 1) {
                                              cartItem.quantity--;
                                            } else {
                                              cartItems.removeAt(index);
                                            }
                                          });
                                        },
                                        child: const Text(
                                          "-",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${cartItem.quantity}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            cartItem.quantity++;
                                          });
                                        },
                                        child: const Text(
                                          "+",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AutoSizeText(
                      "Subtotal",
                      maxLines: 1,
                      minFontSize: 8,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    AutoSizeText(
                      "\$${cartTotal.toStringAsFixed(2)}",
                      maxLines: 1,
                      minFontSize: 8,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: confirmOrder,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: cartItems.isEmpty
                        ? Colors.grey.shade500
                        : Colors.lightGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Confirm Order (${cartItems.length})",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
