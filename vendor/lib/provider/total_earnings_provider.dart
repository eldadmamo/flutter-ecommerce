

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor/models/orders.dart';

class TotalEarningsProvider extends StateNotifier<Map<String,dynamic>> {
  //constructor that initialize the state with 0.0(staring total earning)

  TotalEarningsProvider(): super({'totalEarnings':0.0, "totalOrders":0});

  //method to calculate the total earnings based on delivered status

  void calculateEarnings(List<Order> orders) {
    //initialize a local variable to accumulate earnings
    double earnings = 0.0;
    int orderCount = 0;

    for(Order order in orders){
      //check if the orders has been delivered
      if(order.delivered){
        orderCount++;
        earnings +=order.productPrice * order.quantity;
      }
    }

    state = {
      'totalEarnings': earnings, 
      'totalOrders': orderCount
    };
  }
}

final totalEarningsProvider = StateNotifierProvider<TotalEarningsProvider, Map<String,dynamic>>(
  (ref){
    return TotalEarningsProvider();
  }
);