part of 'orderfull_bloc.dart';

sealed class OrderfullState {
  final List<OrderItem> orders;
  final String? orderType;
  final List<CartItem> cartItems;
  const OrderfullState(
      {this.orderType, this.orders = const [], required this.cartItems});
}

class OrderfullInitial extends OrderfullState {
  const OrderfullInitial() : super(cartItems: const []);
}

class OrderfullLoading extends OrderfullState {
  const OrderfullLoading({
    required super.cartItems,
    super.orders,
    super.orderType,
  });
}

class OrderfullLoaded extends OrderfullState {
  const OrderfullLoaded(
      {required super.cartItems, super.orders, super.orderType});
  OrderfullLoaded copyWith({
    List<OrderItem>? orders,
    String? orderType,
    List<CartItem>? cartItems,
  }) {
    return OrderfullLoaded(
      orders: orders ?? this.orders,
      orderType: orderType ?? this.orderType,
      cartItems: cartItems ?? this.cartItems,
    );
  }
}

class OrderfullSuccess extends OrderfullState {
  const OrderfullSuccess({
    required super.cartItems,
    super.orders,
    super.orderType,
  });
}

class OrderfullFailure extends OrderfullState {
  final String message;

  const OrderfullFailure(
    this.message, {
    required super.cartItems,
    super.orders,
    super.orderType,
  });
}
