
//State Notifier for delivered order count
import 'package:ecommerceflutter/controllers/order_controller.dart';
import 'package:ecommerceflutter/services/manage_http_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeliveredOrderCountProvider extends StateNotifier<int> {
  DeliveredOrderCountProvider(): super(0);

  //method to fetch Delivered Orders Count

  Future<void> fetchDeliveredOrderCount(String buyerId, context)async{
    try{
      OrderController orderController = OrderController();
      int count = await orderController.getDeliveredOrderCount(buyerId: buyerId);

      state = count;
    }catch(e){
      showSnackBar(context, "Error Fetching Delivered Order: $e");
    }
  }

  //Method to reset the count
  void resetCount(){
    state = 0;
  }
}

final deliveredOrderCountProvider = StateNotifierProvider<DeliveredOrderCountProvider, int>(
  (ref){
    return DeliveredOrderCountProvider();
  }
);