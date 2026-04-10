part of 'role_bloc.dart';

sealed class RoleEvent extends Equatable {
  const RoleEvent();

  @override
  List<Object> get props => [];
}

class LoadUsersEvent extends RoleEvent {}

class AddUserEvent extends RoleEvent {
  final AppUser user;
  const AddUserEvent(this.user);

  @override
  List<Object> get props => [user];
}

class UpdateUserEvent extends RoleEvent {
  final AppUser user;
  const UpdateUserEvent(this.user);

  @override
  List<Object> get props => [user];
}
