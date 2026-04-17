// Import PrinterGateway จาก printer_enums.dart
import 'package:flutter_application_1/model/printer_enums.dart';

// ==========================================
// 📋 EPSON Gateway Models
// ==========================================
enum EpsonPrinterModel {
  // TM-M Series (Mobile/Desktop Compact)
  tm_m10,
  tm_m30,
  tm_m30II,
  tm_m30III,
  tm_m50,
  tm_m50II,
  tm_m55,

  // TM-P Series (Portable)
  tm_p20,
  tm_p20II,
  tm_p60II,
  tm_p80,
  tm_p80II,

  // TM-H Series (High Speed)
  tm_h6000,

  // TM-U Series (Serial/USB Slip/Journal)
  tm_u220,
  tm_u220II,
  tm_u330,

  // TM-L Series (Label Printer)
  tm_l90,
  tm_l90LFC,
  tm_l100,

  // TM-T Series (Receipt/POS Printer)
  tm_t20,
  tm_t60,
  tm_t70,
  tm_t81,
  tm_t82,
  tm_t83,
  tm_t83III,
  tm_t88,
  tm_t88VII,
  tm_t90,
  tm_t90KP,
  tm_t100,

  other,
}

// ==========================================
// ⭐ STAR Gateway Models
// ==========================================
enum StarPrinterModel {
  // TSP-Series (Star Receipt Printer)
  tsp_100,
  tsp_100III,
  tsp_100IV,

  // mC-Series (Mobile Compact)
  mc_print2,
  mc_print3,

  other,
}

// ==========================================
// 🔧 CUSTOM Gateway Models
// ==========================================
enum CustomPrinterModel {
  generic,
  other,
}

// ==========================================
// 🟡 ZYWELL Gateway Models
// ==========================================
enum ZywellPrinterModel {
  generic,
  other,
}

// ==========================================
// 🔴 VPOS Gateway Models (Alias of ZYWELL)
// ==========================================
enum VposPrinterModel {
  generic,
  other,
}

// ==========================================
// 📟 ESC_COMMAND Gateway (Generic ESC/POS)
// ==========================================
enum EscCommandPrinterModel {
  generic, // Works with any ESC/POS compatible printer
  other,
}

// ==========================================
// Helper Map: Gateway → Supported Models
// ==========================================
Map<PrinterGateway, List<String>> gatewayModelMap = {
  PrinterGateway.epson: [
    'TM-M10',
    'TM-M30',
    'TM-M30II',
    'TM-M30III',
    'TM-M50',
    'TM-M50II',
    'TM-M55',
    'TM-P20',
    'TM-P20II',
    'TM-P60II',
    'TM-P80',
    'TM-P80II',
    'TM-H6000',
    'TM-U220',
    'TM-U220II',
    'TM-U330',
    'TM-L90',
    'TM-L90LFC',
    'TM-L100',
    'TM-T20',
    'TM-T60',
    'TM-T70',
    'TM-T81',
    'TM-T82',
    'TM-T83',
    'TM-T83III',
    'TM-T88',
    'TM-T88VII',
    'TM-T90',
    'TM-T90KP',
    'TM-T100',
  ],
  PrinterGateway.star: [
    'TSP-100',
    'TSP-100III',
    'TSP-100IV',
    'mC-Print2',
    'mC-Print3',
  ],
  PrinterGateway.custom: ['Generic', 'Other'],
  PrinterGateway.zywell: ['Generic', 'Other'],
  PrinterGateway.vpos: ['Generic', 'Other'],
  PrinterGateway.escCommand: [
    'Generic (All ESC/POS Compatible)',
    'Epson',
    'Star',
    'Zywell',
    'Other'
  ],
  PrinterGateway.posx: ['Generic', 'Other'],
  PrinterGateway.bixolon: ['Generic', 'Other'],
  PrinterGateway.element: ['Generic', 'Other'],
};
