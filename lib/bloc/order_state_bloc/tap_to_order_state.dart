part of 'tap_to_order_bloc.dart';

@immutable
class OrderState {
  final String? orderType;

  const OrderState({this.orderType});

  OrderState copyWith({String? orderType}) {
    return OrderState(orderType: orderType ?? this.orderType);
  }
}
