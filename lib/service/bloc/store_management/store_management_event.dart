part of 'store_management_bloc.dart';

sealed class StoreManagementEvent extends Equatable {
  const StoreManagementEvent();

  @override
  List<Object> get props => [];
}

// ================= การตั้งค่าผู้ใช้งานปัจจุบัน (Login/Logout) =================
class SetCurrentUserEvent extends StoreManagementEvent {
  final Employee?
      user; // ส่งค่า null ได้ในกรณีที่ Logout หรือต้องการให้ออกเป็น customer
  const SetCurrentUserEvent(this.user);

  @override
  List<Object> get props => [user ?? ''];
}

class LogOutEvent extends StoreManagementEvent {
  const LogOutEvent();

  @override
  List<Object> get props => [];
}

// ================= โหลดข้อมูล =================
class LoadStoreDataEvent extends StoreManagementEvent {}

class AddEmployeeEvent extends StoreManagementEvent {
  final String name;
  final String role;
  final String password;

  const AddEmployeeEvent(
      {required this.name, required this.role, required this.password});

  @override
  List<Object> get props => [name, role, password];
}

// ================= จัดการพนักงาน =================
class UpdateEmployeeEvent extends StoreManagementEvent {
  final String employeeId; // ควรมี ID เพื่อใช้ค้นหาและอัปเดต
  final String name;
  final String role;
  final String password;
  final double hourlyWage; // เพิ่มข้อมูลค่าจ้างรายชั่วโมง

  const UpdateEmployeeEvent(
      {required this.employeeId,
      required this.name,
      required this.role,
      required this.password,
      required this.hourlyWage});

  @override
  List<Object> get props => [employeeId, name, role, password, hourlyWage];
}

class DeleteEmployeeEvent extends StoreManagementEvent {
  final String employeeId;
  const DeleteEmployeeEvent(this.employeeId);

  @override
  List<Object> get props => [employeeId];
}

// ================= จัดการร้านค้า =================
class AddStoreSettingEvent extends StoreManagementEvent {
  final String storeName;
  final String phoneNumber;
  final String address;
  final Map<String, dynamic> extra;

  const AddStoreSettingEvent(
      {required this.storeName,
      required this.phoneNumber,
      required this.address,
      required this.extra});

  @override
  List<Object> get props => [storeName, phoneNumber, address, extra];
}

class ToggleStoreStatusEvent extends StoreManagementEvent {
  final bool isOpen; // true = ร้านเปิด, false = ร้านปิด
  const ToggleStoreStatusEvent(this.isOpen);

  @override
  List<Object> get props => [isOpen];
}

class UpdateInfomationStoreEvent extends StoreManagementEvent {
  final String storeName;
  final String phoneNumber;
  final String address;
  final double taxRate; // เพิ่มข้อมูลอัตราภาษี

  const UpdateInfomationStoreEvent(
      {required this.storeName,
      required this.phoneNumber,
      required this.address,
      required this.taxRate});

  @override
  List<Object> get props => [storeName, phoneNumber, address, taxRate];
}
