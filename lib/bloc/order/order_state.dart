part of 'order_bloc.dart';

@immutable
abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final String? orderType;
  final List<OrderItem> orders;

  OrderLoaded({this.orderType, this.orders = const []});

  /// ราคารวมทั้งหมด
  double get totalPrice =>
      orders.fold<double>(0, (sum, item) => sum + item.totalPrice);

  /// จำนวน item ทั้งหมด
  int get totalItems => orders.fold<int>(0, (sum, item) => sum + item.quantity);

  /// copy state
  OrderLoaded copyWith({String? orderType, List<OrderItem>? orders}) {
    return OrderLoaded(
      orderType: orderType ?? this.orderType,
      orders: orders ?? this.orders,
    );
  }
}

class OrderSuccess extends OrderState {
  final List<OrderItem> orders;
  OrderSuccess(this.orders);
}

class OrderFailure extends OrderState {
  final String message;
  OrderFailure(this.message);
}
