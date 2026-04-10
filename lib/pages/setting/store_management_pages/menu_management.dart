import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/config/export.dart';

class MenuManagement extends StatefulWidget {
  const MenuManagement({super.key});

  @override
  State<MenuManagement> createState() => _MenuManagementState();
}

class _MenuManagementState extends State<MenuManagement> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategoryId; // null = All Categories

  @override
  void initState() {
    super.initState();
    // รีโหลดเมนูทุกครั้งที่เข้ามาหน้านี้ เพื่อความชัวร์
    context.read<MenuBloc>().add(LoadMenuEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Menu Management",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: สร้างหน้า Add Menu
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Coming Soon: Add new menu")),
          );
        },
        backgroundColor: const Color(0xFF496EE2),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Menu",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MenuError) {
            return Center(child: Text("Error: ${state.message}"));
          } else if (state is! MenuLoaded) {
            return const Center(child: Text("No Data"));
          }

          // ดึงหมวดหมู่และเมนูทั้งหมดมา
          final categories = state.categories;
          final allMenus = state.menus;

          // คัดกรองเมนูตาม Search และ Category
          final filteredMenus = allMenus.where((menu) {
            final matchSearch = menu.foodName!
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
            final matchCategory = _selectedCategoryId == null ||
                menu.foodCatId == _selectedCategoryId;
            return matchSearch && matchCategory;
          }).toList();

          return Column(
            children: [
              // 1. Search Bar
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: "Search menu name...",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),

              // 2. Category Filter (แนวนอน)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildCategoryChip(
                        id: null,
                        name: "All Items",
                        isSelected: _selectedCategoryId == null,
                      ),
                      ...categories.map((cat) {
                        return _buildCategoryChip(
                          id: cat.foodCatId,
                          name: cat.foodCatName ?? "Unknown",
                          isSelected: _selectedCategoryId == cat.foodCatId,
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // 3. Menu List
              Expanded(
                child: filteredMenus.isEmpty
                    ? const Center(
                        child: Text("No menus found",
                            style: TextStyle(color: Colors.grey, fontSize: 16)))
                    : ListView.builder(
                        padding: const EdgeInsets.only(
                            top: 16, left: 16, right: 16, bottom: 80),
                        itemCount: filteredMenus.length,
                        itemBuilder: (context, index) {
                          final menu = filteredMenus[index];
                          // หาชื่อหมวดหมู่มาแสดง
                          final catName = categories
                                  .where((c) => c.foodCatId == menu.foodCatId)
                                  .firstOrNull
                                  ?.foodCatName ??
                              "Unknown Category";

                          // สมมติว่ามีสถานะ isSoldOut ใน Model (ถ้าไม่มีให้ลบเงื่อนไขนี้ หรือจำลองเป็น false ไว้ก่อน)
                          // bool isSoldOut = menu.isSoldOut ?? false;
                          bool isSoldOut = false; // Mock data

                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  // รูปภาพเมนู
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      menu.imageName ?? "",
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, err, stack) =>
                                          Container(
                                        width: 70,
                                        height: 70,
                                        color: Colors.grey.shade200,
                                        child: const Icon(Icons.fastfood,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // รายละเอียด
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          menu.foodName ?? "-",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          catName,
                                          style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 13),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "\$${menu.foodPrice.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                              color: Color(0xFF496EE2),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // ปุ่มควบคุม (Sold Out / Edit)
                                  Column(
                                    children: [
                                      const Text("Sold Out",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey)),
                                      Switch(
                                        value: isSoldOut,
                                        activeColor: Colors.red,
                                        onChanged: (val) {
                                          // TODO: ยิง Event ไปอัปเดต Database และ Bloc ว่าสินค้าหมด
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    "${menu.foodName} marked as ${val ? 'Sold Out' : 'Available'}")),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined,
                                        color: Colors.grey),
                                    onPressed: () {
                                      // TODO: เปิดหน้า Edit Menu
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip({
    required String? id,
    required String name,
    required bool isSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(name),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            _selectedCategoryId = id;
          });
        },
        selectedColor: const Color(0xFF496EE2),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: Colors.grey.shade100,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
