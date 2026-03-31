import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/model/print_result.dart';

part 'printer_event.dart';
part 'printer_state.dart';

class PrinterBloc extends Bloc<PrinterEvent, PrinterState> {
  PrinterBloc() : super(PrinterState()) {
    on<AddPrinter>((event, emit) {
      log("Bloc config save: ${state.printers}");
      final updateList = List<PrinterConfig>.from(state.printers ?? [])
        ..add(event.config);
      emit(state.copyWith(printers: updateList));
      log("Bloc config save: ${updateList.length}");
    });

    on<RemovePrinter>((event, emit) {
      final updateList = List<PrinterConfig>.from(state.printers ?? [])
        ..removeAt(event.index);
      emit(state.copyWith(printers: updateList));
      log("Bloc config remove: ${updateList.length}");
    });

    on<ClearPrinterConfig>((event, emit) {
      // คืนค่า State ใหม่ที่ว่างเปล่า (config เป็น null)
      log("Bloc config clear: null");
      emit(const PrinterState());
    });

    on<EditPrinter>((event, emit) {
      final currentList = List<PrinterConfig>.from(state.printers ?? []);

      if (event.index < 0 || event.index >= currentList.length) {
        log("❌ EditPrinter: index out of range");
        return;
      }

      currentList[event.index] = event.config;

      emit(state.copyWith(printers: currentList));
      log("Bloc config edit: ${currentList.length}");
    });
  }
}
