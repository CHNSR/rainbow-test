part of 'tap_to_order_bloc.dart';

@immutable
class OrderState {
  final String? orderType;
  final List<OrderItem> orders;

  const OrderState({this.orderType, this.orders = const []});

  /// ราคารวมทั้งหมด
  double get totalPrice =>
      orders.fold<double>(0, (sum, item) => sum + item.totalPrice);

  /// จำนวน item ทั้งหมด
  int get totalItems => orders.fold<int>(0, (sum, item) => sum + item.quantity);

  /// copy state
  OrderState copyWith({String? orderType, List<OrderItem>? orders}) {
    return OrderState(
      orderType: orderType ?? this.orderType,
      orders: orders ?? this.orders,
    );
  }
}
