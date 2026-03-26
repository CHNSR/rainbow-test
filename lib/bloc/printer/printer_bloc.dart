import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/model/print_result.dart';

part 'printer_event.dart';
part 'printer_state.dart';

class PrinterBloc extends Bloc<PrinterEvent, PrinterState> {
  PrinterBloc() : super(PrinterState()) {
    on<SetPrinterConfig>((event, emit) {
      emit(state.copyWith(config: event.config));
    });

    on<ClearPrinterConfig>((event, emit) {
      // คืนค่า State ใหม่ที่ว่างเปล่า (config เป็น null)
      log("Bloc config clear: null");
      emit(const PrinterState());
    });
  }
}
