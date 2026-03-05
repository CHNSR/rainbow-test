import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/food_category.dart';
import 'package:flutter_application_1/service/food_service.dart';

class OrderPages extends StatefulWidget {
  const OrderPages({super.key});

  @override
  State<OrderPages> createState() => _OrderPagesState();
}

class _OrderPagesState extends State<OrderPages> {
  List<SubFoodCategory> categories = [];

  void loadCategory() async {
    categories = await FoodService.parseFoodCategory();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                      _buildTopBar(),
                      _buildCategoryTabs(),
                      _buildSubCategoryTabs(),
                      Expanded(child: _buildMenuGrid()),
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

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back),
            label: const Text("Back"),
          ),
          const Spacer(),
          const Icon(Icons.search),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.1)),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Container(color: Colors.grey.shade300),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text("Food Name"),
              ),
              const Text("\$12.95"),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryTabs() {
    return FutureBuilder<List<FoodSet>>(
      future: FoodService.parseFoodSet(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Text("Error loading categories");
        }

        final categories = snapshot.data!;

        return DefaultTabController(
          length: categories.length,
          child: Column(
            children: [
              /// TAB BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TabBar(
                  isScrollable: true,
                  indicatorColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  dividerColor: Colors.transparent,
                  dividerHeight: 0,
                  tabs: categories
                      .map((e) => Tab(text: e.foodSetName))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
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

  Widget _buildSubCategoryTabs() {
    return FutureBuilder<List<SubFoodCategory>>(
      future: FoodService.parseFoodCategory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Text("Error loading categories");
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("No categories");
        }

        final subcategories = snapshot.data!;

        return DefaultTabController(
          length: subcategories.length,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TabBar(
              isScrollable: true,

              indicatorColor: Colors.transparent,

              indicator: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),

              indicatorSize: TabBarIndicatorSize.tab,

              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,

              labelPadding: const EdgeInsets.symmetric(horizontal: 10),

              dividerColor: Colors.transparent,

              tabs: subcategories
                  .map(
                    (category) => Tab(
                      child: Text(
                        category.foodCatName,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _subCategoryChip(String title, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.blue.shade100 : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          color: selected ? Colors.blue : Colors.black54,
        ),
      ),
    );
  }
}
