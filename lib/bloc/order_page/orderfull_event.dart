part of 'orderfull_bloc.dart';

sealed class OrderfullEvent {}

class AddToCartEvent extends OrderfullEvent {
  final FoodMenu food;
  AddToCartEvent(this.food);
}

class RemoveFromCartEvent extends OrderfullEvent {
  final FoodMenu food;
  RemoveFromCartEvent(this.food);
}

class ClearCartEvent extends OrderfullEvent {}

class SetOrderTypeEvent extends OrderfullEvent {
  final String orderType;

  SetOrderTypeEvent(this.orderType);
}

class ConfirmOrderEvent extends OrderfullEvent {
  ConfirmOrderEvent();
}
