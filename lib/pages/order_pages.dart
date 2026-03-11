import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/widgets/order_page/cart_section.dart';
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
  bool showSearchBar = false;
  late ScrollController _menuScrollController;
  ScrollController subcategoryScrollController = ScrollController();
  Map<String, GlobalKey> categoryIndexMap = {};
  bool categoryVisble = true;

  final AutoSizeGroup nameGroup = AutoSizeGroup();
  final AutoSizeGroup descGroup = AutoSizeGroup();
  final AutoSizeGroup priceGroup = AutoSizeGroup();

  //load data from assets
  Future<void> loadData() async {
    sets = await FoodService.parseFoodSet();
    categories = await FoodService.parseFoodCategory();
    menus = await FoodService.parseFoodMenu();

    for (var cat in categories) {
      categoryIndexMap[cat.foodCatId] = GlobalKey();
    }

    if (sets.isNotEmpty) {
      selectedSetId = sets.first.foodSetId;

      final menusInSet = menus
          .where((m) => m.foodSetId == selectedSetId)
          .toList();

      if (menusInSet.isNotEmpty) {
        selectedCategoryId = null;
      }
    }

    buildCategoryKeys();

    setState(() {
      isLoading = false;
    });
  }

  void buildCategoryKeys() {
    categoryIndexMap.clear();

    for (var cat in categories) {
      categoryIndexMap[cat.foodCatId] = GlobalKey();
    }
  }

  List<FoodMenu> get filteredMenus {
    return MenuFilter.filterMenus(
      menus: MenuFilter.filterMenus(
        menus: menus,
        foodSetId: selectedSetId,
        searchText: searchText,
      ),
    );
  }

  List<SubFoodCategory> get filteredCategories {
    if (selectedSetId == null) return [];

    final foodCatsInSet = menus
        .where((m) => m.foodSetId == selectedSetId)
        .map((m) => m.foodCatId)
        .toSet();

    return categories
        .where((c) => foodCatsInSet.contains(c.foodCatId))
        .toList();
  }

  void scrollToCategory(String catId) {
    final key = categoryIndexMap[catId];
    if (key == null) return;

    final ctx = key.currentContext;
    if (ctx == null) return;

    final renderObject = ctx.findRenderObject();
    if (renderObject == null) return;

    final viewport = RenderAbstractViewport.of(renderObject);
    if (viewport == null) return;

    final offset = viewport.getOffsetToReveal(renderObject, 0.0).offset;

    _menuScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void addToCart(FoodMenu food) {
    setState(() {
      final index = cartItems.indexWhere(
        (item) => item.food.foodId == food.foodId,
      );

      if (index != -1) {
        cartItems[index].quantity++;
      } else {
        cartItems.add(CartItem(food: food, quantity: 1));
      }
    });
  }

  void _onMenuScroll() {
    for (var cat in filteredCategories) {
      final key = categoryIndexMap[cat.foodCatId];

      if (key == null) continue;

      final context = key.currentContext;
      if (context == null) continue;

      final box = context.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);

      const triggerOffset = 120; // ปรับตามความสูง TopBar + CategoryBar

      if (position.dy <= triggerOffset && position.dy > 0) {
        if (selectedCategoryId != cat.foodCatId) {
          setState(() {
            selectedCategoryId = cat.foodCatId;
          });

          _scrollSubCategory(cat.foodCatId);
        }
      }
    }
  }

  void _scrollSubCategory(String catId) {
    final index = filteredCategories.indexWhere((c) => c.foodCatId == catId);

    if (index == -1) return;

    const itemWidth = 120.0;

    subcategoryScrollController.animateTo(
      index * itemWidth,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();
    _menuScrollController = ScrollController();
    _menuScrollController.addListener(_onMenuScroll);
    loadData();
  }

  @override
  void dispose() {
    _menuScrollController.dispose();
    subcategoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.02),
              child: Row(
                children: [
                  /// 🔹 LEFT SIDE (MENU)
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: TopBar(
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
                        ),
                        if (!showSearchBar) ...[
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
                                  selectedCategoryId =
                                      menusInSet.first.foodCatId;
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
                            scrollController: subcategoryScrollController,
                            categories: filteredCategories,
                            selectedCategoryId: selectedCategoryId,
                            onSelect: (catId) {
                              setState(() {
                                selectedCategoryId = catId;
                              });
                              // Scroll ไปยัง category ที่เลือก
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                scrollToCategory(catId);
                              });
                            },
                          ),
                        ],

                        Expanded(
                          child: MenuGrid(
                            foods: filteredMenus,
                            subcategories: filteredCategories,
                            subcategoryScrollController:
                                subcategoryScrollController,
                            onAddToCart: addToCart,
                            categoryKeys: categoryIndexMap,
                            menuScrollController: _menuScrollController,
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
                    child: CartSection(cartItems: cartItems),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
