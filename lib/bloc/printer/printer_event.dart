part of 'printer_bloc.dart';

sealed class PrinterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SetPrinterConfig extends PrinterEvent {
  final PrinterConfig config;

  SetPrinterConfig({required this.config});
}
