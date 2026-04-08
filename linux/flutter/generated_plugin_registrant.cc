//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <driver_printer/driver_printer_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) driver_printer_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "DriverPrinterPlugin");
  driver_printer_plugin_register_with_registrar(driver_printer_registrar);
}
