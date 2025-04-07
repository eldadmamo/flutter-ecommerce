import 'dart:convert';

import 'package:admin/global_variable.dart';
import 'package:admin/models/order.dart';
import 'package:admin/services/manage_http_response.dart';
import 'package:http/http.dart' as http;

class OrderController {

  Future<List<Order>> loadOrders()async{
    try{
     http.Response response =  await http.get(Uri.parse('$uri/api/orders'), 
    
     headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8"
     });

    if(response.statusCode==200){
      //decode the json response body into list of dynamic object
      List<dynamic> data = jsonDecode(response.body); 

      // covert the dynamic list into list of order objects
     List<Order> orders 
        = data.map((order) => Order.fromJson(order)).toList();
     return orders;
    } else {
      throw Exception('Failed to load orders');
    }
    }catch(e){
      throw Exception('Failed to load orders');
    }
  }
}