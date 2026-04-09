import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_application_1/core/utils/deviceType.dart';

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
  bool _isAutoScrolling = false;
  final GlobalKey _menuGridKey = GlobalKey();
  final GlobalKey repaintKey = GlobalKey(); // for capture

  void scrollToCategory(String catId) async {
    final ctx = categoryIndexMap[catId]?.currentContext;
    if (ctx == null) return;

    final renderObject = ctx.findRenderObject();
    final viewport = RenderAbstractViewport.of(renderObject!);

    final offset = viewport.getOffsetToReveal(renderObject, 0.0).offset;

    _isAutoScrolling = true;
    await _menuScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _isAutoScrolling = false;
  }

  void _onMenuScroll() {
    if (_isAutoScrolling || !mounted) return;

    final menuState = context.read<MenuBloc>().state;
    if (menuState is! MenuLoaded) return;

    final menuGridContext = _menuGridKey.currentContext;
    if (menuGridContext == null) return;

    final menuGridBox = menuGridContext.findRenderObject() as RenderBox;
    final triggerOffset = menuGridBox.localToGlobal(Offset.zero).dy +
        20; // ใช้ค่าคงที่ 20px เผื่อระยะกระแทกขอบ

    String? activeCategoryId;

    for (var cat in menuState.filteredCategories) {
      final key = categoryIndexMap[cat.foodCatId];
      if (key == null || key.currentContext == null) continue;

      final box = key.currentContext!.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);

      if (position.dy <= triggerOffset) {
        activeCategoryId = cat.foodCatId;
      } else {
        break; // ข้ามตัวที่เหลือเพราะยังไงก็อยู่ข้างใต้
      }
    }

    if (activeCategoryId == null && menuState.filteredCategories.isNotEmpty) {
      activeCategoryId = menuState.filteredCategories.first.foodCatId;
    }

    // กรณีจอใหญ่ (Wide Screen) ScrollView อาจจะยาวไม่พอให้หมวดสุดท้ายไปสุดขอบบน
    // ถ้าชนขอบล่างสุดแล้ว ให้บังคับเปลี่ยนหมวดเป็นหมวดสุดท้าย
    if (_menuScrollController.hasClients &&
        _menuScrollController.position.pixels >=
            _menuScrollController.position.maxScrollExtent - 5) {
      if (menuState.filteredCategories.isNotEmpty) {
        activeCategoryId = menuState.filteredCategories.last.foodCatId;
      }
    }

    if (activeCategoryId != null &&
        menuState.selectedCategoryId != activeCategoryId) {
      context.read<MenuBloc>().add(SelectCategoryEvent(activeCategoryId));

      final screenSize = MediaQuery.of(context).size;
      final isLandscape = LandScapeUtils.isLandscape(context);
      final itemWidth =
          isLandscape ? screenSize.width * 0.1 : screenSize.width * 0.18;

      _scrollSubCategory(
          activeCategoryId, menuState.filteredCategories, itemWidth);
    }
  }

  void _scrollSubCategory(
    String catId,
    List<SubFoodCategory> filteredCategories,
    double itemWidth,
  ) {
    final index = filteredCategories.indexWhere(
      (c) => c.foodCatId == catId,
    );
    if (index < 0) return;

    if (!subcategoryScrollController.hasClients) return;

    final maxScroll = subcategoryScrollController.position.maxScrollExtent;

    final targetOffset = index * itemWidth;

    final safeOffset = targetOffset.clamp(0.0, maxScroll);

    // 🔥 กัน animate ซ้ำค่าเดิม (ลดกระพริบ)
    if ((subcategoryScrollController.offset - safeOffset).abs() < 1) return;

    subcategoryScrollController.animateTo(
      safeOffset,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void buildCategoryKeys(List<SubFoodCategory> categories) {
    // ห้าม clear map! เพราะเวลา state เปลี่ยนแค่ highlight สับหมวด กลายเป็นสร้าง Key ใหม่ที่ไม่มี Widget ไปผูก
    for (var cat in categories) {
      final id = cat.foodCatId;
      if (!categoryIndexMap.containsKey(id)) {
        categoryIndexMap[id] = GlobalKey();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _menuScrollController = ScrollController();
    _menuScrollController.addListener(_onMenuScroll);

    // Dispatch LoadMenuEvent
    context.read<MenuBloc>().add(LoadMenuEvent());
    // 👇 สั่งให้ PrinterBloc ดึงข้อมูลจาก Hive มาเก็บไว้ใน State (สมมติว่า Event ชื่อ LoadPrinters)
    context.read<PrinterBloc>().add(LoadPrinters());
  }

  @override
  void dispose() {
    _menuScrollController.dispose();
    subcategoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    bool isLandscape = LandScapeUtils.isLandscape(context);

    return BlocListener<OrderfullBloc, OrderfullState>(
      listener: (context, state) async {
        if (state is OrderfullSuccess) {
          final printers = context.read<PrinterBloc>().state.printers;

          if (printers == null || printers.isEmpty) {
            print("❌ [OrderPages] Error: ไม่มี Printer");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("❌ ยังไม่ได้ตั้งค่า Printer")),
            );
            return;
          }

          // ✅ แยก printer
          final kitchenPrinter =
              printers.where((p) => p.category == "kitchen").toList();

          final cashierPrinter =
              printers.where((p) => p.category == "cashier").toList();

          print("🍳 [OrderPages] Kitchen printers: ${kitchenPrinter.length}");
          print("💰 [OrderPages] Cashier printers: ${cashierPrinter.length}");

          List<Map<String, dynamic>> allPrintResults = [];
          bool hasFailed = false;

          // -----------------------------
          // 🔥 1. พิมพ์ Kitchen ก่อน
          // -----------------------------

          if (kitchenPrinter.isNotEmpty) {
            final kitchenResults =
                await OrderPageWidget().showReceiptAndPrintMulti(
              context: context,
              orders: state.orders,
              configs: kitchenPrinter,
              receptWidth: 384,
              category: "kitchen",
            );

            if (kitchenResults == null) return; // กดยกเลิก
            if (!context.mounted) return;

            allPrintResults.addAll(kitchenResults);

            if (kitchenResults.any((p) => p['status'] == 'failed')) {
              hasFailed = true;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("❌ พิมพ์ครัวล้มเหลว")),
              );
              // ❌ ไม่ต้องใส่ return; ตรงนี้แล้ว เพื่อให้มันไปพิมพ์ Cashier ต่อ และนำประวัติพังๆ ไปเซฟลง History ด้วย
            }
          }

          // -----------------------------
          // 💰 2. พิมพ์ Cashier
          // -----------------------------
          if (cashierPrinter.isNotEmpty) {
            final cashierResults =
                await OrderPageWidget().showReceiptAndPrintMulti(
              context: context,
              orders: state.orders,
              configs: cashierPrinter,
              receptWidth: 384,
              category: "cashier",
            );

            if (cashierResults == null) return;
            if (!context.mounted) return;

            allPrintResults.addAll(cashierResults);

            if (cashierResults.any((p) => p['status'] == 'failed')) {
              hasFailed = true;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("❌ พิมพ์ใบเสร็จล้มเหลว")),
              );
            }
          }

          // -----------------------------
          // ✅ success ทั้งหมด
          // -----------------------------

          if (!context.mounted) return;

          // เรียก SaveReceipt แทน ClearCart (เพราะ SaveReceipt จะบันทึกข้อมูลและเคลียร์ตะกร้าให้)
          context.read<OrderfullBloc>().add(SaveReceiptEvent(
                printStatus: hasFailed ? 'failed' : 'success',
                usedPrinters:
                    allPrintResults, // ส่งข้อมูลที่แพ็คสถานะแยกรายเครื่องไปให้ Bloc
              ));

          if (!hasFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("🧾 พิมพ์ครบทุกใบแล้ว")),
            );
          }
        }
      },
      child: Scaffold(
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
                      child: BlocConsumer<MenuBloc, MenuState>(
                          buildWhen: (previous, current) {
                        if (previous is MenuLoaded && current is MenuLoaded) {
                          // ให้ Rebuild ทางฝั่งซ้ายใหม่ เฉพาะตอนที่ข้อมูลรายการอาหารหรือหมวดหมู่เปลี่ยน (ไม่ใช่เพราะแค่เลื่อนหมวด)
                          return previous.selectedSetId !=
                                  current.selectedSetId ||
                              previous.searchText != current.searchText ||
                              previous.sets != current.sets ||
                              previous.menus != current.menus ||
                              previous.categories != current.categories;
                        }
                        return true;
                      }, listener: (context, state) {
                        if (state is MenuLoaded) {
                          buildCategoryKeys(state.categories);

                          if (state.selectedCategoryId == null &&
                              state.filteredCategories.isNotEmpty) {
                            context.read<MenuBloc>().add(
                                  SelectCategoryEvent(
                                    state.filteredCategories.first.foodCatId,
                                  ),
                                );
                          }
                        }
                      }, builder: (context, menuState) {
                        if (menuState is MenuLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (menuState is MenuError) {
                          return Center(
                              child: Text("Error: ${menuState.message}"));
                        } else if (menuState is! MenuLoaded) {
                          return const SizedBox();
                        }

                        return Column(
                          children: [
                            SizedBox(
                              child: OrderPageWidget.topBar(
                                context: context,
                                showSearchBar: showSearchBar,
                                onToggleSearch: () {
                                  setState(() {
                                    showSearchBar = !showSearchBar;
                                  });
                                  if (!showSearchBar) {
                                    context
                                        .read<MenuBloc>()
                                        .add(SearchMenuEvent(""));
                                  }
                                },
                                onSearchChanged: (value) {
                                  context
                                      .read<MenuBloc>()
                                      .add(SearchMenuEvent(value));
                                },
                              ),
                            ),
                            if (!showSearchBar) ...[
                              OrderPageWidget.categoryBar(
                                context: context,
                                sets: menuState.sets,
                                selectedSetId: menuState.selectedSetId,
                                onSelect: (setId) {
                                  context
                                      .read<MenuBloc>()
                                      .add(SelectSetEvent(setId));

                                  // Scroll ไปยัง item แรก
                                  _menuScrollController.animateTo(
                                    0.0,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              ),
                              SizedBox(
                                  height: isLandscape
                                      ? screenWidth * 0.005
                                      : screenWidth * 0.015),
                              Align(
                                alignment: Alignment.centerLeft,
                                widthFactor: 1,
                                child:
                                    BlocSelector<MenuBloc, MenuState, String?>(
                                  selector: (state) => state is MenuLoaded
                                      ? state.selectedCategoryId
                                      : null,
                                  builder: (context, selectedCategoryId) {
                                    return OrderPageWidget.subCategoryBar(
                                      context: context,
                                      scrollController:
                                          subcategoryScrollController,
                                      categories: menuState.filteredCategories,
                                      selectedCategoryId: selectedCategoryId,
                                      onSelect: (catId) {
                                        context
                                            .read<MenuBloc>()
                                            .add(SelectCategoryEvent(catId));

                                        // Scroll ไปยัง category ที่เลือก
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((
                                          _,
                                        ) {
                                          scrollToCategory(catId);
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                            Expanded(
                              key: _menuGridKey,
                              child: OrderPageWidget.menuGrid(
                                context: context,
                                foods: menuState.filteredMenus,
                                subcategories: menuState.filteredCategories,
                                subcategoryScrollController:
                                    subcategoryScrollController,
                                categoryKeys: categoryIndexMap,
                                menuScrollController: _menuScrollController,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),

                    /// 🔹 RIGHT SIDE (CART)
                    SizedBox(
                      width: DeviceType.isDesktop(context)
                          ? screenWidth * 0.20
                          : DeviceType.isTablet(context)
                              ? screenWidth * 0.25
                              : screenWidth * 0.35,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: screenWidth * 0.01,
                              right: screenWidth * 0.01),
                          child: CartSection()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
