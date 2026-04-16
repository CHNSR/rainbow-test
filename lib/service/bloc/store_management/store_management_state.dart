part of 'store_management_bloc.dart';

sealed class StoreManagementState extends Equatable {
  const StoreManagementState();

  @override
  List<Object> get props => [];
}

final class StoreManagementInitial extends StoreManagementState {}

final class StoreManagementLoaded extends StoreManagementState {
  final List<Employee> employees;

  const StoreManagementLoaded(this.employees);

  @override
  List<Object> get props => [employees];
}

final class StoreManagementError extends StoreManagementState {
  final String message;

  const StoreManagementError(this.message);

  @override
  List<Object> get props => [message];
}

final class StoreManagementLoading extends StoreManagementState {}
