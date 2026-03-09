part of 'tap_to_order_bloc.dart';

@immutable
sealed class OrderEvent {}

class SetOrderType extends OrderEvent {
  final String orderType;

  SetOrderType(this.orderType);
}
