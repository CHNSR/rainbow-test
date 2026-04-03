// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReceiptAdapter extends TypeAdapter<Receipt> {
  @override
  final typeId = 10;

  @override
  Receipt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Receipt(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      totalAmount: (fields[2] as num).toDouble(),
      orderType: fields[3] as String,
      items: (fields[4] as List).cast<ReceiptItem>(),
      status: fields[5] == null ? 'Success' : fields[5] as String,
      printer: fields[6] == null ? 'Unknown' : fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Receipt obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.totalAmount)
      ..writeByte(3)
      ..write(obj.orderType)
      ..writeByte(4)
      ..write(obj.items)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.printer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceiptAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReceiptItemAdapter extends TypeAdapter<ReceiptItem> {
  @override
  final typeId = 7;

  @override
  ReceiptItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReceiptItem(
      foodName: fields[0] as String,
      foodPrice: (fields[1] as num).toDouble(),
      quantity: (fields[2] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ReceiptItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.foodName)
      ..writeByte(1)
      ..write(obj.foodPrice)
      ..writeByte(2)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceiptItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
