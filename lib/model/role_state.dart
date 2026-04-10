part of 'role_bloc.dart';

sealed class RoleState extends Equatable {
  const RoleState();

  @override
  List<Object> get props => [];
}

final class RoleInitial extends RoleState {}

final class RoleLoaded extends RoleState {
  final List<AppUser> users;
  const RoleLoaded(this.users);

  @override
  List<Object> get props => [users];
}

final class RoleError extends RoleState {
  final String message;
  const RoleError(this.message);

  @override
  List<Object> get props => [message];
}
