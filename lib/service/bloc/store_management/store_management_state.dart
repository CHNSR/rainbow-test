part of 'store_management_bloc.dart';

sealed class StoreManagementState extends Equatable {
  const StoreManagementState();

  @override
  List<Object> get props => [];
}

final class StoreManagementInitial extends StoreManagementState {}

final class StoreManagementLoaded extends StoreManagementState {
  final List<Employee> employees;
  final Employee?
      currentUser; // 👈 เก็บสถานะผู้ใช้งานที่ล็อกอินอยู่ปัจจุบัน (ถ้า null = customer)

  const StoreManagementLoaded(this.employees, {this.currentUser});

  @override
  List<Object> get props => [employees, currentUser ?? ''];
}

final class StoreManagementError extends StoreManagementState {
  final String message;

  const StoreManagementError(this.message);

  @override
  List<Object> get props => [message];
}

final class StoreManagementLoading extends StoreManagementState {}
