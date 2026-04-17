import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/model/app_user.dart';
import 'package:flutter_application_1/service/hive_ce/hive_ce.dart';

part 'store_management_event.dart';
part 'store_management_state.dart';

class StoreManagementBloc
    extends Bloc<StoreManagementEvent, StoreManagementState> {
  StoreManagementBloc() : super(StoreManagementInitial()) {
    // ================= ตั้งค่าผู้ใช้งานปัจจุบัน =================
    on<SetCurrentUserEvent>((event, emit) {
      if (state is StoreManagementLoaded) {
        final currentState = state as StoreManagementLoaded;
        emit(StoreManagementLoaded(
          currentState.employees,
          currentUser: event.user,
        ));
      }
    });

    on<LoadStoreDataEvent>((event, emit) {
      emit(StoreManagementLoading());
      try {
        final rawUsers = HiveService.getAppUsersRaw();
        List<Employee> employees = [];
        if (rawUsers.isEmpty) {
          employees = [
            // เพิ่มค่าจ้างเริ่มต้นสำหรับ Owner
            Employee(
                id: "1",
                name: "Owner",
                role: "Owner",
                pin: "9999",
                hourlyWage: 0)
          ];
          _saveToHive(employees);
        } else {
          employees = rawUsers
              .map((str) => Employee.fromJson(jsonDecode(str)))
              .toList();
        }
        emit(StoreManagementLoaded(employees));
      } catch (e) {
        emit(StoreManagementError(e.toString()));
      }
    });

    on<AddEmployeeEvent>(
      (event, emit) {
        if (state is StoreManagementLoaded) {
          final employees =
              List<Employee>.from((state as StoreManagementLoaded).employees)
                ..add(Employee(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: event.name,
                  role: event.role,
                  pin: event.password,
                  hourlyWage: 0, // กำหนดค่าจ้างเริ่มต้นเป็น 0 สำหรับพนักงานใหม่
                  isActive: true,
                ));
          _saveToHive(employees);
          emit(StoreManagementLoaded(employees));
        }
      },
    );

    on<DeleteEmployeeEvent>(
      (event, emit) {
        if (state is StoreManagementLoaded) {
          final employees =
              List<Employee>.from((state as StoreManagementLoaded).employees)
                ..removeWhere((e) => e.id == event.employeeId);
          _saveToHive(employees);
          emit(StoreManagementLoaded(employees));
        }
      },
    );

    on<UpdateEmployeeEvent>((event, emit) {
      if (state is StoreManagementLoaded) {
        final employees =
            List<Employee>.from((state as StoreManagementLoaded).employees);
        final index = employees.indexWhere((e) => e.id == event.employeeId);
        if (index != -1) {
          final existingEmployee = employees[index];
          employees[index] = Employee(
            id: event.employeeId,
            name: event.name,
            role: event.role,
            pin: event.password,
            hourlyWage: event.hourlyWage, // อัปเดตค่าจ้าง
            isActive: existingEmployee.isActive, // ใช้ค่าสถานะเดิม
          );
          _saveToHive(employees);
          emit(StoreManagementLoaded(employees));
        }
      }
    });

    on<UpdateInfomationStoreEvent>((event, emit) {
      if (state is StoreManagementLoaded) {
        // ในที่นี้เราจะไม่จัดการข้อมูลร้านค้าใน Hive แต่สามารถเพิ่มโค้ดเพื่อจัดการได้ตามต้องการ
        // เช่น การบันทึกข้อมูลร้านค้าใน Hive หรือฐานข้อมูลอื่น ๆ
        emit(
            state); // แค่ส่งสถานะเดิมกลับไป เพราะยังไม่มีการเปลี่ยนแปลงข้อมูลพนักงาน
      }
    });
  }
  void _saveToHive(List<Employee> users) {
    final rawUsers = users.map((u) => jsonEncode(u.toJson())).toList();
    HiveService.saveAppUsersRaw(rawUsers);
  }
}
