import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/export.dart';

class StoreMainPage extends StatefulWidget {
  final String loggedInUserRole;
  final String loggedInUserName;

  const StoreMainPage(
      {super.key,
      required this.loggedInUserRole,
      required this.loggedInUserName});

  @override
  State<StoreMainPage> createState() => _StoreMainPageState();
}

class _StoreMainPageState extends State<StoreMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Store Management",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildStoreInfoCard(),
          const SizedBox(height: 24),
          _buildSection(
            title: "Menu & Inventory",
            children: [
              _buildNavigationTile(
                icon: Icons.restaurant_menu,
                title: "Menu Management",
                subtitle: "Add, Edit, Sold out status",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MenuManagement()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: "Sales & Data",
            children: [
              _buildNavigationTile(
                icon: Icons.bar_chart,
                title: "Sales Report",
                subtitle: "View daily, weekly sales & Z-Report",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Report()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: "Administration",
            children: [
              _buildNavigationTile(
                icon: Icons.people_outline,
                title: "Employee Management",
                subtitle: "Manage staff accounts and PINs",
                enabled: widget.loggedInUserRole.toLowerCase() ==
                    'owner', // เฉพาะ owner
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RoleManagementPage()),
                  );
                },
              ),
              _buildDivider(),
              _buildNavigationTile(
                icon: Icons.store_mall_directory_outlined,
                title: "Store Settings",
                subtitle: "Receipt info, Tax, and General info",
                enabled: widget.loggedInUserRole.toLowerCase() ==
                    'owner', // เฉพาะ owner
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StoreSetting()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStoreInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF496EE2), Color(0xFF2B4CB2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF496EE2).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                      'assets/logo/chonsom.png'), // ใช้โลโก้ร้าน (ถ้าไม่มีจะใช้ Icon ก็ได้)
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Soi Siam Restaurant",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.circle,
                            color: Colors.greenAccent, size: 10),
                        const SizedBox(width: 6),
                        Text(
                          "Store is Open",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text("Name: ${widget.loggedInUserName}",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        )),
                    const SizedBox(height: 4),
                    Text("Role: ${widget.loggedInUserRole}",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BlocBuilder<StoreManagementBloc, StoreManagementState>(
                  builder: (context, state) {
                    String staffCount = "0";
                    if (state is StoreManagementLoaded) {
                      staffCount = state.employees.length.toString();
                    }
                    return _buildStatItem("Staff", staffCount, Icons.badge);
                  },
                ),
                Container(width: 1, height: 30, color: Colors.white30),
                _buildStatItem("Menus", "128", Icons.restaurant),
                Container(width: 1, height: 30, color: Colors.white30),
                _buildStatItem("Printers", "2", Icons.print),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSection(
      {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap, // เปลี่ยนเป็น VoidCallback?
    bool enabled = true, // เพิ่ม enabled parameter
  }) {
    return ListTile(
      leading: Container(
        // Wrap with Opacity for disabled effect
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF496EE2).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF496EE2)),
      ),
      title: Text(title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: enabled
                ? Colors.black
                : Colors.grey.shade500, // สีเทาเมื่อ disabled
          )),
      subtitle: Text(subtitle,
          style: TextStyle(
            fontSize: 13,
            color: enabled
                ? Colors.grey.shade600
                : Colors.grey.shade400, // สีเทาอ่อนลง
          )),
      trailing: Icon(Icons.chevron_right,
          color: enabled ? Colors.grey : Colors.grey.shade300), // สีเทาอ่อนลง
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: enabled ? onTap : null, // ถ้า disabled ก็เป็น null ทำให้กดไม่ได้
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 64),
      child: Divider(height: 1, color: Colors.grey.shade200),
    );
  }
}
