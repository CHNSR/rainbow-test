part of 'tap_to_order_bloc.dart';

@immutable
class OrderState {
  final String? orderType;
  final List<OrderItem> orders; // เก็บรายการออเดอร์

  const OrderState({this.orderType, this.orders = const []});

  // helper: คำนวณราคารวมทั้งหมด
  double get totalPrice => orders.fold(0, (sum, item) => sum + item.totalPrice);

  // helper: นับจำนวนสินค้า
  int get totalItems => orders.fold(0, (sum, item) => sum + item.quantity);

  OrderState copyWith({String? orderType, List<OrderItem>? orders}) {
    return OrderState(
      orderType: orderType ?? this.orderType,
      orders: orders ?? this.orders,
    );
  }
}
