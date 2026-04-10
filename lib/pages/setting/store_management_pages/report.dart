import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text("Reports & Analytics",
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          bottom: const TabBar(
            labelColor: Color(0xFF496EE2),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF496EE2),
            tabs: [
              Tab(icon: Icon(Icons.show_chart), text: "Sales"),
              Tab(icon: Icon(Icons.people_alt_outlined), text: "Staff"),
              Tab(icon: Icon(Icons.inventory_2_outlined), text: "Stock"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSalesReport(),
            _buildStaffReport(),
            _buildStockReport(),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 1. SALES REPORT TAB
  // ==========================================
  Widget _buildSalesReport() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary Cards
        Row(
          children: [
            Expanded(
                child: _buildSummaryCard("Total Sales", "\$1,245.50",
                    Icons.attach_money, Colors.green)),
            const SizedBox(width: 12),
            Expanded(
                child: _buildSummaryCard(
                    "Orders", "84", Icons.receipt_long, Colors.blue)),
          ],
        ),
        const SizedBox(height: 24),

        // Section Title
        const Text("Top Selling Items",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        const SizedBox(height: 12),

        // Top Items List (Mock Data)
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              _buildTopItemTile("1", "Pad Thai Goong", "32 orders", "\$384.00"),
              const Divider(height: 1),
              _buildTopItemTile("2", "Tom Yum Soup", "24 orders", "\$288.00"),
              const Divider(height: 1),
              _buildTopItemTile("3", "Green Curry", "18 orders", "\$216.00"),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Export Z-Report Button
        SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Printing Z-Report...")));
            },
            icon: const Icon(Icons.print),
            label: const Text("Print Z-Report (End of Day)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF496EE2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(value,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildTopItemTile(
      String rank, String name, String subtitle, String amount) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.amber.shade100,
        child: Text(rank,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.amber.shade900)),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: Text(amount,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
    );
  }

  // ==========================================
  // 2. STAFF REPORT TAB
  // ==========================================
  Widget _buildStaffReport() {
    // Mock Staff Data
    final staffData = [
      {
        "name": "Alice (Manager)",
        "orders": "45",
        "sales": "\$750.00",
        "status": "Active"
      },
      {
        "name": "Bob (Cashier)",
        "orders": "39",
        "sales": "\$495.50",
        "status": "Active"
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: staffData.length,
      itemBuilder: (context, index) {
        final staff = staffData[index];
        return Card(
          color: Colors.white,
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(Icons.person, color: Colors.blue),
                        ),
                        const SizedBox(width: 12),
                        Text(staff["name"]!,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(staff["status"]!,
                          style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStaffStat("Processed Orders", staff["orders"]!),
                    _buildStaffStat("Total Revenue", staff["sales"]!),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStaffStat(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }

  // ==========================================
  // 3. STOCK REPORT TAB
  // ==========================================
  Widget _buildStockReport() {
    // Mock Stock Data
    final stockData = [
      {"name": "Jasmine Rice", "unit": "kg", "amount": 45.0, "min": 10.0},
      {
        "name": "Chicken Breast",
        "unit": "kg",
        "amount": 8.5,
        "min": 10.0
      }, // Low Stock
      {
        "name": "Fish Sauce",
        "unit": "liters",
        "amount": 2.0,
        "min": 5.0
      }, // Low Stock
      {"name": "Fresh Prawns", "unit": "kg", "amount": 12.0, "min": 5.0},
      {"name": "Coconut Milk", "unit": "liters", "amount": 15.0, "min": 5.0},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stockData.length,
      itemBuilder: (context, index) {
        final item = stockData[index];
        final name = item["name"] as String;
        final unit = item["unit"] as String;
        final amount = item["amount"] as double;
        final min = item["min"] as double;
        final isLowStock = amount <= min;

        return Card(
          color: Colors.white,
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
                color: isLowStock ? Colors.red.shade200 : Colors.grey.shade200,
                width: isLowStock ? 1.5 : 1),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isLowStock ? Colors.red.shade50 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isLowStock ? Icons.warning_amber_rounded : Icons.inventory_2,
                color: isLowStock ? Colors.red : Colors.grey.shade600,
              ),
            ),
            title:
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: isLowStock
                ? Text("Low Stock (Min: $min $unit)",
                    style: const TextStyle(color: Colors.red, fontSize: 12))
                : Text("In Stock",
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "$amount",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isLowStock ? Colors.red : Colors.black87),
                ),
                Text(unit,
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
        );
      },
    );
  }
}
