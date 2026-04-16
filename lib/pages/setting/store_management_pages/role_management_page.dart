import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/app_user.dart';
import 'package:flutter_application_1/service/bloc/store_management/store_management_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoleManagementPage extends StatefulWidget {
  const RoleManagementPage({super.key});

  @override
  State<RoleManagementPage> createState() => _RoleManagementPageState();
}

class _RoleManagementPageState extends State<RoleManagementPage> {
  @override
  void initState() {
    super.initState();
    // สั่งให้ BLoC โหลดข้อมูล User ทันทีที่เปิดหน้า
    context.read<StoreManagementBloc>().add(LoadStoreDataEvent());
  }

  void _showUserDialog({Employee? user}) {
    final isEditing = user != null;
    final nameController = TextEditingController(text: user?.name ?? '');
    final pinController = TextEditingController(text: user?.pin ?? '');
    final wageController =
        TextEditingController(text: user?.hourlyWage?.toString() ?? '0');
    String selectedRole =
        user?.role ?? 'Staff'; // Default to Staff for new users
    bool isActive = user?.isActive ?? true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              title: Text(
                isEditing ? "Edit User" : "Add New User",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: pinController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 4,
                      decoration: const InputDecoration(
                        labelText: "4-Digit PIN Code",
                        prefixIcon: Icon(Icons.password),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: wageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Hourly Wage (THB)",
                        prefixIcon: Icon(Icons.money),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      decoration: const InputDecoration(
                        labelText: "Role",
                        prefixIcon: Icon(Icons.shield_outlined),
                        border: OutlineInputBorder(),
                      ),
                      items: ['Owner', 'Manager', 'Staff']
                          .map((role) => DropdownMenuItem(
                                value: role,
                                child: Text(role),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value!;
                        });
                      },
                    ),
                    if (isEditing) ...[
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text("Active Account"),
                        subtitle: const Text("Allow user to login"),
                        value: isActive,
                        activeColor: Colors.green,
                        onChanged: (value) {
                          setState(() {
                            isActive = value;
                          });
                        },
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel",
                      style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF496EE2),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (nameController.text.trim().isEmpty ||
                        pinController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please fill all fields!")));
                      return;
                    }

                    if (isEditing) {
                      // สร้าง Object ใหม่เพื่อส่งไปอัปเดตใน BLoC
                      context.read<StoreManagementBloc>().add(
                            UpdateEmployeeEvent(
                              employeeId: user!.id,
                              name: nameController.text.trim(),
                              role: selectedRole,
                              password: pinController.text.trim(),
                              hourlyWage:
                                  double.tryParse(wageController.text) ?? 0.0,
                            ),
                          );
                    } else {
                      context.read<StoreManagementBloc>().add(AddEmployeeEvent(
                            name: nameController.text.trim(),
                            role: selectedRole,
                            password: pinController.text.trim(),
                          ));
                    }

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(isEditing
                              ? "User updated!"
                              : "User added successfully!")),
                    );
                  },
                  child: Text(isEditing ? "Save Changes" : "Add User"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(Employee user, List<Employee> users) {
    // ป้องกันการลบ Owner ถ้าเหลือเพียงคนเดียวในระบบ
    if (user.role.toLowerCase() == 'owner' &&
        users.where((u) => u.role.toLowerCase() == 'owner').length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Cannot delete the only owner account!"),
            backgroundColor: Colors.red),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text("Delete User",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to delete ${user.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              context
                  .read<StoreManagementBloc>()
                  .add(DeleteEmployeeEvent(user.id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User deleted successfully!")),
              );
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Role Management",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUserDialog(),
        backgroundColor: const Color(0xFF496EE2),
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text("Add User",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: BlocListener<StoreManagementBloc, StoreManagementState>(
        listener: (context, state) {
          if (state is StoreManagementError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("Error: ${state.message}"),
                  backgroundColor: Colors.red),
            );
          }
        },
        child: BlocBuilder<StoreManagementBloc, StoreManagementState>(
          builder: (context, state) {
            if (state is StoreManagementLoading ||
                state is StoreManagementInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is StoreManagementLoaded) {
              final users = state.employees;
              if (users.isEmpty) {
                return const Center(
                    child: Text("No users found. Press '+' to add one."));
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 1,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor:
                            _getRoleColor(user.role).withOpacity(0.2),
                        radius: 25,
                        child: Icon(
                          _getRoleIcon(user.role),
                          color: _getRoleColor(user.role),
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          decoration: user.isActive
                              ? TextDecoration.none
                              : TextDecoration.lineThrough,
                          color: user.isActive ? Colors.black : Colors.grey,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color:
                                      _getRoleColor(user.role).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  user.role,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _getRoleColor(user.role),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (!user.isActive)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "Inactive",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red.shade700),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined,
                                color: Colors.grey),
                            onPressed: () => _showUserDialog(user: user),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () => _confirmDelete(user, users),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: Text("Something went wrong."));
          },
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'owner':
        return Colors.purple;
      case 'manager':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'owner':
        return Icons.admin_panel_settings;
      case 'manager':
        return Icons.manage_accounts;
      default:
        return Icons.person;
    }
  }
}
