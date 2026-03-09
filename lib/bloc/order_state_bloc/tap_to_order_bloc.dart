import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'tap_to_order_event.dart';
part 'tap_to_order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const OrderState()) {
    on<SetOrderType>((event, emit) {
      print("OrderType selected: ${event.orderType}");
      emit(state.copyWith(orderType: event.orderType));
    });
  }
}
