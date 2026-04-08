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
  final String status;
  final String printer;

  ConfirmOrderEvent({this.status = "Success", this.printer = "Unknown"});
}

class SaveReceiptEvent extends OrderfullEvent {
  final String printStatus;
  final List<Map<String, dynamic>> usedPrinters; // รับค่า Printer ที่ผ่านการแพ็คแล้ว

  SaveReceiptEvent({required this.printStatus, required this.usedPrinters});
}
