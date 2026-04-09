/// Enum สำหรับจัดการ Gateway ของเครื่องปริ้นเตอร์
enum PrinterGateway {
  posx('posx'),
  epson('epson'),
  star('star'),
  escCommand('esc_command'),
  vpos('vpos'),
  bixolon('bixolon'),
  custom('custom'),
  element('element');

  final String value;
  const PrinterGateway(this.value);

  static PrinterGateway fromValue(String v) {
    return PrinterGateway.values.firstWhere(
      (e) => e.value == v,
      orElse: () => PrinterGateway.posx,
    );
  }
}

/// Enum สำหรับจัดการ รุ่น (Model) ของเครื่องปริ้นเตอร์
enum PrinterModel {
  generic('generic'),
  tmM30('TM-M30'),
  tmU220('TM-U220'),
  tmT20('TM-T20'),
  tmT82('TM-T82'),
  tsp100III('TSP-100III'),
  tsp100IV('TSP-100IV'),
  sp742('SP-742');

  final String value;
  const PrinterModel(this.value);

  static PrinterModel fromValue(String v) {
    return PrinterModel.values.firstWhere(
      (e) => e.value == v,
      orElse: () => PrinterModel.generic,
    );
  }
}
