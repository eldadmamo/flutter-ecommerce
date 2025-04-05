import 'package:ecommerceflutter/models/order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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