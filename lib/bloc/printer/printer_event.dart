part of 'printer_bloc.dart';

sealed class PrinterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPrinters extends PrinterEvent {}

class AddPrinter extends PrinterEvent {
  final PrinterConfig config;

  AddPrinter(this.config);

  @override
  List<Object> get props => [config];
}

class RemovePrinter extends PrinterEvent {
  final int index;

  RemovePrinter(this.index);

  @override
  List<Object> get props => [index];
}

class EditPrinter extends PrinterEvent {
  final int index;
  final PrinterConfig config;

  EditPrinter(this.index, this.config);

  @override
  List<Object> get props => [index, config];
}

class ClearPrinterConfig extends PrinterEvent {}
