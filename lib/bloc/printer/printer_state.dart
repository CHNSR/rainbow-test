part of 'printer_bloc.dart';

class PrinterState {
  final PrinterConfig? config;

  const PrinterState({this.config});

  PrinterState copyWith({PrinterConfig? config}) {
    log("Bloc config save: ${config?.ip}, ${config?.port}, ${config?.paperSize}");
    return PrinterState(
      config: config ?? this.config,
    );
  }
}
