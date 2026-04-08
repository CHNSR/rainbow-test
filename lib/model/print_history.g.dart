// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrintHistoryItemAdapter extends TypeAdapter<PrintHistoryItem> {
  @override
  final typeId = 2;

  @override
  PrintHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrintHistoryItem(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      totalAmount: (fields[2] as num).toDouble(),
      status: fields[3] as PrintStatus,
      orderType: fields[4] as String,
      items: (fields[5] as List)
          .map((e) => (e as Map).cast<String, dynamic>())
          .toList(),
      printer: (fields[6] as List)
          .map((e) => (e as Map).cast<String, dynamic>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, PrintHistoryItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.totalAmount)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.orderType)
      ..writeByte(5)
      ..write(obj.items)
      ..writeByte(6)
      ..write(obj.printer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrintHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PrintStatusAdapter extends TypeAdapter<PrintStatus> {
  @override
  final typeId = 1;

  @override
  PrintStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PrintStatus.success;
      case 1:
        return PrintStatus.fail;
      case 2:
        return PrintStatus.printing;
      case 3:
        return PrintStatus.waiting;
      default:
        return PrintStatus.success;
    }
  }

  @override
  void write(BinaryWriter writer, PrintStatus obj) {
    switch (obj) {
      case PrintStatus.success:
        writer.writeByte(0);
      case PrintStatus.fail:
        writer.writeByte(1);
      case PrintStatus.printing:
        writer.writeByte(2);
      case PrintStatus.waiting:
        writer.writeByte(3);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrintStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
