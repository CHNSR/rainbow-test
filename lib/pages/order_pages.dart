import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/config/export.dart';

class OrderPages extends StatefulWidget {
  const OrderPages({super.key});

  @override
  State<OrderPages> createState() => _OrderPagesState();
}

class _OrderPagesState extends State<OrderPages> {
  final controller = OrderController();
  bool showSearchBar = false;
  late ScrollController _menuScrollController;
  ScrollController subcategoryScrollController = ScrollController();
  Map<String, GlobalKey> categoryIndexMap = {};

  void scrollToCategory(String catId) {
    final ctx = categoryIndexMap[catId]?.currentContext;
    if (ctx == null) return;

    final renderObject = ctx.findRenderObject();
    final viewport = RenderAbstractViewport.of(renderObject!);

    final offset = viewport!.getOffsetToReveal(renderObject, 0.0).offset;

    _menuScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onMenuScroll() {
    for (var cat in controller.filteredCategories) {
      final key = categoryIndexMap[cat.foodCatId];

      if (key == null) continue;

      final context = key.currentContext;
      if (context == null) continue;

      final box = context.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);

      const triggerOffset = 120; // ปรับตามความสูง TopBar + CategoryBar

      if (position.dy <= triggerOffset && position.dy > 0) {
        if (controller.selectedCategoryId != cat.foodCatId) {
          setState(() {
            controller.selectedCategoryId = cat.foodCatId;
          });

          _scrollSubCategory(cat.foodCatId);
        }
      }
    }
  }

  void _scrollSubCategory(String catId) {
    final index = controller.filteredCategories.indexWhere(
      (c) => c.foodCatId == catId,
    );
    if (index < 0) return;
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

  Future<void> loadData() async {
    await controller.loadData();
    controller.buildCategoryKeys(categoryIndexMap);
    setState(() {});
  }

  @override
  void dispose() {
    _menuScrollController.dispose();
    subcategoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading) {
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
                                controller.searchText = value;
                              });
                            },
                          ),
                        ),
                        if (!showSearchBar) ...[
                          CategoryBar(
                            sets: controller.sets,
                            selectedSetId: controller.selectedSetId,
                            onSelect: (setId) {
                              setState(() {
                                controller.selectedSetId = setId;

                                final menusInSet = controller.menus
                                    .where(
                                      (m) =>
                                          m.foodSetId ==
                                          controller.selectedSetId,
                                    )
                                    .toList();

                                if (menusInSet.isNotEmpty) {
                                  controller.selectedCategoryId =
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
                            categories: controller.filteredCategories,
                            selectedCategoryId: controller.selectedCategoryId,
                            onSelect: (catId) {
                              setState(() {
                                controller.selectedCategoryId = catId;
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
                            foods: controller.filteredMenus,
                            subcategories: controller.filteredCategories,
                            subcategoryScrollController:
                                subcategoryScrollController,
                            onAddToCart: (food) {
                              setState(() {
                                controller.addToCart(food);
                              });
                            },
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
                    child: CartSection(cartItems: controller.cartItems),
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
