part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

class SetOrderType extends OrderEvent {
  final String orderType;

  SetOrderType(this.orderType);
}

// Event สำหรับยืนยันการสั่งซื้อ
class ConfirmOrderEvent extends OrderEvent {
  final List<Map<String, dynamic>> items;

  ConfirmOrderEvent(this.items);
}
