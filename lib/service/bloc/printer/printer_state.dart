part of 'printer_bloc.dart';

sealed class PrinterState extends Equatable {
  final List<PrinterConfig> printers;

  const PrinterState({this.printers = const []});

  @override
  List<Object?> get props => [printers];
}

// =========================================
// 1. หมวดจัดการข้อมูล (Data & Configuration)
// =========================================

class PrinterInitial extends PrinterState {
  const PrinterInitial();
}

class PrinterLoading extends PrinterState {
  const PrinterLoading({required super.printers});
}

class PrinterLoaded extends PrinterState {
  const PrinterLoaded({required super.printers});
}

/// ทำงานเกี่ยวกับข้อมูลสำเร็จ (เช่น Add, Edit, Delete สำเร็จ)
class PrinterOperationSuccess extends PrinterState {
  final String message;

  const PrinterOperationSuccess(this.message, {required super.printers});

  @override
  List<Object?> get props => [printers, message];
}

// =========================================
// 2. หมวดการสั่งพิมพ์ (Printing Job)
// =========================================

class PrinterPrinting extends PrinterState {
  const PrinterPrinting({required super.printers});
}

class PrinterPrintSuccess extends PrinterState {
  final String message;
  const PrinterPrintSuccess(this.message, {required super.printers});
}

class PrinterPrintFailure extends PrinterState {
  final String error;
  const PrinterPrintFailure(this.error, {required super.printers});
}

// =========================================
// 3. หมวด Error ทั่วไป
// =========================================

class PrinterFailure extends PrinterState {
  final String error;

  const PrinterFailure(this.error, {required super.printers});

  @override
  List<Object?> get props => [printers, error];
}
