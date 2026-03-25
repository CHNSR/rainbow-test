class PrintResult {
  final bool success;
  final String message;

  PrintResult({required this.success, required this.message});
}

class PrinterConfig {
  final String ip;
  final int port;
  final String paperSize;

  PrinterConfig({
    required this.ip,
    required this.port,
    required this.paperSize,
  });
}
