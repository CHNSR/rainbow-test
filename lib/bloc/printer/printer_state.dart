part of 'printer_bloc.dart';

class PrinterState extends Equatable {
  final List<PrinterConfig>? printers;

  const PrinterState({this.printers = const []});

  PrinterState copyWith({List<PrinterConfig>? printers}) {
    log("Bloc config save: ${printers?.first.ip}, ${printers?.first.port}, ${printers?.first.paperSize}, ${printers?.first.category}");
    return PrinterState(
      printers: printers ?? this.printers,
    );
  }

  @override
  List<Object?> get props => [printers];
}
