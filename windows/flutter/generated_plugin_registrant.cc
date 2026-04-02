//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_printer_01/flutter_printer01_plugin_c_api.h>
#include <flutter_thermal_printer/flutter_thermal_printer_plugin_c_api.h>
#include <universal_ble/universal_ble_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FlutterPrinter01PluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterPrinter01PluginCApi"));
  FlutterThermalPrinterPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterThermalPrinterPluginCApi"));
  UniversalBlePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UniversalBlePluginCApi"));
}
