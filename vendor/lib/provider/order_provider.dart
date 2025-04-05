
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor/models/orders.dart';

class OrderProvider extends StateNotifier<List<Order>> {
  OrderProvider() : super([]);

  void setOrders(List<Order> orders){
    state = orders;
  }
}

final orderProvider = StateNotifierProvider<OrderProvider, List<Order>>(
  (ref) {
    return OrderProvider(); 
  }
);