part of 'tap_to_order_bloc.dart';

@immutable
sealed class OrderEvent {}

class SetOrderType extends OrderEvent {
  final String orderType;

  SetOrderType(this.orderType);
}

// Event สำหรับยืนยันการสั่งซื้อ
class ConfirmOrderEvent extends OrderEvent {
  final String foodSetId;
  final List<CartItem> cartItems;

  ConfirmOrderEvent({required this.foodSetId, required this.cartItems});
}
