// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrinterConfigAdapter extends TypeAdapter<PrinterConfig> {
  @override
  final typeId = 0;

  @override
  PrinterConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrinterConfig(
      name: fields[0] as String,
      ip: fields[1] as String,
      port: (fields[2] as num).toInt(),
      paperSize: fields[3] as String,
      category: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PrinterConfig obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.ip)
      ..writeByte(2)
      ..write(obj.port)
      ..writeByte(3)
      ..write(obj.paperSize)
      ..writeByte(4)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrinterConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
