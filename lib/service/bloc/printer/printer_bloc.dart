import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/model/print_result.dart';
import 'package:flutter_application_1/service/hive_ce/hive_ce.dart';

part 'printer_event.dart';
part 'printer_state.dart';

class PrinterBloc extends Bloc<PrinterEvent, PrinterState> {
  PrinterBloc() : super(const PrinterInitial()) {
    on<LoadPrinters>(_onLoadPrinters);
    on<AddPrinter>(_onAddPrinter);
    on<RemovePrinter>(_onRemovePrinter);
    on<EditPrinter>(_onEditPrinter);
    on<ClearPrinterConfig>(_onClearPrinterConfig);

    // โหลดข้อมูลเริ่มต้นเมื่อสร้าง BLoC
    add(LoadPrinters());
  }

  Future<void> _onLoadPrinters(
      LoadPrinters event, Emitter<PrinterState> emit) async {
    emit(PrinterLoading(printers: state.printers));
    try {
      final printers = HiveService.getPrinters();
      emit(PrinterLoaded(printers: printers));
    } catch (e) {
      log("❌ LoadPrinters Error: $e");
      emit(PrinterFailure(e.toString(), printers: state.printers));
    }
  }

  Future<void> _onAddPrinter(
      AddPrinter event, Emitter<PrinterState> emit) async {
    emit(PrinterLoading(printers: state.printers));
    try {
      await HiveService.addPrinter(event.config);
      final printers = HiveService.getPrinters();
      emit(PrinterOperationSuccess("เพิ่มเครื่องพิมพ์สำเร็จ",
          printers: printers));
      emit(PrinterLoaded(printers: printers));
    } catch (e) {
      log("❌ AddPrinter Error: $e");
      emit(PrinterFailure(e.toString(), printers: state.printers));
    }
  }

  Future<void> _onEditPrinter(
      EditPrinter event, Emitter<PrinterState> emit) async {
    emit(PrinterLoading(printers: state.printers));
    try {
      await HiveService.updatePrinter(event.index, event.config);
      final printers = HiveService.getPrinters();
      emit(PrinterOperationSuccess("แก้ไขเครื่องพิมพ์สำเร็จ",
          printers: printers));
      emit(PrinterLoaded(printers: printers));
    } catch (e) {
      log("❌ EditPrinter Error: $e");
      emit(PrinterFailure(e.toString(), printers: state.printers));
    }
  }

  Future<void> _onRemovePrinter(
      RemovePrinter event, Emitter<PrinterState> emit) async {
    emit(PrinterLoading(printers: state.printers));
    try {
      await HiveService.removePrinter(event.index);
      final printers = HiveService.getPrinters();
      emit(PrinterOperationSuccess("ลบเครื่องพิมพ์สำเร็จ", printers: printers));
      emit(PrinterLoaded(printers: printers));
    } catch (e) {
      log("❌ RemovePrinter Error: $e");
      emit(PrinterFailure(e.toString(), printers: state.printers));
    }
  }

  Future<void> _onClearPrinterConfig(
      ClearPrinterConfig event, Emitter<PrinterState> emit) async {
    emit(PrinterLoading(printers: state.printers));
    try {
      await HiveService.clearAllPrinters();
      final printers = HiveService.getPrinters();
      emit(PrinterOperationSuccess("ล้างการตั้งค่าสำเร็จ", printers: printers));
      emit(PrinterLoaded(printers: printers));
    } catch (e) {
      log("❌ ClearPrinterConfig Error: $e");
      emit(PrinterFailure(e.toString(), printers: state.printers));
    }
  }
}
