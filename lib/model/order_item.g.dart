// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderItemAdapter extends TypeAdapter<OrderItem> {
  @override
  final typeId = 12;

  @override
  OrderItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderItem(
      foodSetId: fields[0] as String,
      foodId: fields[1] as String,
      foodName: fields[2] as String,
      foodPrice: (fields[3] as num).toDouble(),
      quantity: (fields[4] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, OrderItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.foodSetId)
      ..writeByte(1)
      ..write(obj.foodId)
      ..writeByte(2)
      ..write(obj.foodName)
      ..writeByte(3)
      ..write(obj.foodPrice)
      ..writeByte(4)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
