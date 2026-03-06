import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/menu_filter.dart';
import 'package:flutter_application_1/model/food_category.dart';
import 'package:flutter_application_1/model/food_menu.dart';
import 'package:flutter_application_1/service/food_service.dart';
import 'package:flutter_application_1/widgets/order_page/category_tabs.dart';
import 'package:flutter_application_1/widgets/order_page/menu_grid.dart';
import 'package:flutter_application_1/widgets/order_page/search_widget.dart';
import 'package:flutter_application_1/widgets/order_page/sub_category_tabs.dart';
import 'package:flutter_application_1/widgets/order_page/topbar.dart';

class OrderPages extends StatefulWidget {
  const OrderPages({super.key});

  @override
  State<OrderPages> createState() => _OrderPagesState();
}

class _OrderPagesState extends State<OrderPages> {
  List<FoodSet> sets = [];
  List<SubFoodCategory> categories = [];
  List<FoodMenu> menus = [];

  String? selectedSetId;
  String? selectedCategoryId;
  String searchText = "";

  bool isLoading = true;
  final AutoSizeGroup nameGroup = AutoSizeGroup();
  final AutoSizeGroup descGroup = AutoSizeGroup();
  final AutoSizeGroup priceGroup = AutoSizeGroup();
  bool showSearchBar = false;

  @override
  void initState() {
    super.initState();
    loadData();
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
    return categories.where((c) => c.foodCatId == selectedSetId).toList();
  }

  void loadData() async {
    sets = await FoodService.parseFoodSet();
    categories = await FoodService.parseFoodCategory();
    menus = await FoodService.parseFoodMenu();

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
                        },
                      ),
                      SubCategoryBar(
                        categories: filteredCategories,
                        selectedCategoryId: selectedCategoryId,
                        onSelect: (catId) {
                          setState(() {
                            selectedCategoryId = catId;
                          });
                        },
                      ),
                      Expanded(child: MenuGrid(foods: filteredMenus)),
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

          const Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: AutoSizeText(
                  "No order selected",
                  maxLines: 1,
                  minFontSize: 8,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    AutoSizeText(
                      "Subtotal",
                      maxLines: 1,
                      minFontSize: 8,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    AutoSizeText(
                      "\$0.00",
                      maxLines: 1,
                      minFontSize: 8,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.grey.shade500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: const Text(
                      "Confirm Order (0)",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
