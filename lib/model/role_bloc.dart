import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/model/app_user.dart';
import 'package:flutter_application_1/service/hive_ce/hive_ce.dart';

part 'role_event.dart';
part 'role_state.dart';

class RoleBloc extends Bloc<RoleEvent, RoleState> {
  RoleBloc() : super(RoleInitial()) {
    on<LoadUsersEvent>((event, emit) {
      try {
        final rawUsers = HiveService.getAppUsersRaw();
        List<AppUser> users = [];
        if (rawUsers.isEmpty) {
          users = [AppUser(id: "1", name: "Owner", role: "Owner", pin: "9999")];
          _saveToHive(users);
        } else {
          users =
              rawUsers.map((str) => AppUser.fromJson(jsonDecode(str))).toList();
        }
        emit(RoleLoaded(users));
      } catch (e) {
        emit(RoleError(e.toString()));
      }
    });

    on<AddUserEvent>((event, emit) {
      if (state is RoleLoaded) {
        final users = List<AppUser>.from((state as RoleLoaded).users)
          ..add(event.user);
        _saveToHive(users);
        emit(RoleLoaded(users));
      }
    });

    on<UpdateUserEvent>((event, emit) {
      if (state is RoleLoaded) {
        final users = List<AppUser>.from((state as RoleLoaded).users);
        final index = users.indexWhere((u) => u.id == event.user.id);
        if (index != -1) {
          users[index] = event.user;
          _saveToHive(users);
          emit(RoleLoaded(users));
        }
      }
    });
  }

  void _saveToHive(List<AppUser> users) {
    final rawUsers = users.map((u) => jsonEncode(u.toJson())).toList();
    HiveService.saveAppUsersRaw(rawUsers);
  }
}
