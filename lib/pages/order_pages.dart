import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_application_1/utils/deviceType.dart';

class OrderPages extends StatefulWidget {
  const OrderPages({super.key});

  @override
  State<OrderPages> createState() => _OrderPagesState();
}

class _OrderPagesState extends State<OrderPages> {
  bool showSearchBar = false;
  late ScrollController _menuScrollController;
  ScrollController subcategoryScrollController = ScrollController();
  Map<String, GlobalKey> categoryIndexMap = {};

  void scrollToCategory(String catId) {
    final ctx = categoryIndexMap[catId]?.currentContext;
    if (ctx == null) return;

    final renderObject = ctx.findRenderObject();
    final viewport = RenderAbstractViewport.of(renderObject!);

    final offset = viewport.getOffsetToReveal(renderObject, 0.0).offset;

    _menuScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onMenuScroll() {
    final menuState = context.read<MenuBloc>().state;
    if (menuState is! MenuLoaded) return;

    for (var cat in menuState.filteredCategories) {
      final key = categoryIndexMap[cat.foodCatId];

      if (key == null) continue;

      final contextValue = key.currentContext;
      if (contextValue == null) continue;

      final box = contextValue.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);

      const triggerOffset = 120; // ปรับตามความสูง TopBar + CategoryBar

      if (position.dy <= triggerOffset && position.dy > 0) {
        if (menuState.selectedCategoryId != cat.foodCatId) {
          context.read<MenuBloc>().add(SelectCategoryEvent(cat.foodCatId));
          _scrollSubCategory(cat.foodCatId, menuState.filteredCategories);
        }
      }
    }
  }

  void _scrollSubCategory(String catId, List<SubFoodCategory> filteredCategories) {
    final index = filteredCategories.indexWhere(
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

  void buildCategoryKeys(List<SubFoodCategory> categories) {
    categoryIndexMap.clear();
    for (var cat in categories) {
      categoryIndexMap[cat.foodCatId] = GlobalKey();
    }
  }

  @override
  void initState() {
    super.initState();
    _menuScrollController = ScrollController();
    _menuScrollController.addListener(_onMenuScroll);
    
    // Dispatch LoadMenuEvent
    context.read<MenuBloc>().add(LoadMenuEvent());
  }

  @override
  void dispose() {
    _menuScrollController.dispose();
    subcategoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
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
                    child: BlocConsumer<MenuBloc, MenuState>(
                      listener: (context, state) {
                        if (state is MenuLoaded) {
                          buildCategoryKeys(state.categories);
                        }
                      },
                      builder: (context, menuState) {
                        if (menuState is MenuLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (menuState is MenuError) {
                          return Center(child: Text("Error: \${menuState.message}"));
                        } else if (menuState is! MenuLoaded) {
                          return const SizedBox();
                        }
                        return Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.08,
                              child: TopBar(
                                showSearchBar: showSearchBar,
                                onToggleSearch: () {
                                  setState(() {
                                    showSearchBar = !showSearchBar;
                                  });
                                  if (!showSearchBar) {
                                    context.read<MenuBloc>().add(SearchMenuEvent(""));
                                  }
                                },
                                onSearchChanged: (value) {
                                  context.read<MenuBloc>().add(SearchMenuEvent(value));
                                },
                              ),
                            ),
                            if (!showSearchBar) ...[
                              CategoryBar(
                                sets: menuState.sets,
                                selectedSetId: menuState.selectedSetId,
                                onSelect: (setId) {
                                  context.read<MenuBloc>().add(SelectSetEvent(setId));
                                  
                                  // Scroll ไปยัง item แรก
                                  _menuScrollController.animateTo(
                                    0.0,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              ),
                              SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerLeft,
                                widthFactor: 1,
                                child: SubCategoryBar(
                                  scrollController: subcategoryScrollController,
                                  categories: menuState.filteredCategories,
                                  selectedCategoryId: menuState.selectedCategoryId,
                                  onSelect: (catId) {
                                    context.read<MenuBloc>().add(SelectCategoryEvent(catId));

                                    // Scroll ไปยัง category ที่เลือก
                                    WidgetsBinding.instance.addPostFrameCallback((
                                      _,
                                    ) {
                                      scrollToCategory(catId);
                                    });
                                  },
                                ),
                              ),
                            ],

                            Expanded(
                              child: MenuGrid(
                                foods: menuState.filteredMenus,
                                subcategories: menuState.filteredCategories,
                                subcategoryScrollController:
                                    subcategoryScrollController,
                                onAddToCart: (food) {
                                  context.read<CartBloc>().add(AddToCartEvent(food));
                                },
                                categoryKeys: categoryIndexMap,
                                menuScrollController: _menuScrollController,
                              ),
                            ),
                          ],
                        );
                      }
                    ),
                  ),

                  /// 🔹 RIGHT SIDE (CART)
                  Container(
                    width: DeviceType.isDesktop(context)
                        ? screenWidth * 0.20
                        : DeviceType.isTablet(context)
                        ? screenWidth * 0.25
                        : screenWidth * 0.30,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: BlocBuilder<CartBloc, CartState>(
                        builder: (context, cartState) {
                          return CartSection(cartItems: cartState.cartItems);
                        }
                      ),
                    ),
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
