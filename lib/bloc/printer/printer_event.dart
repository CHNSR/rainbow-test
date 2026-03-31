part of 'printer_bloc.dart';

sealed class PrinterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddPrinter extends PrinterEvent {
  final PrinterConfig config;

  AddPrinter(this.config);
}

class RemovePrinter extends PrinterEvent {
  final int index;

  RemovePrinter(this.index);
}

class EditPrinter extends PrinterEvent {
  final int index;
  final PrinterConfig config;

  EditPrinter(this.index, this.config);
}

class ClearPrinterConfig extends PrinterEvent {}
