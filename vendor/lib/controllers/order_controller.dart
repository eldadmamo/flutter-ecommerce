import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vendor/models/orders.dart';
import 'package:vendor/services/manage_http_response.dart';
import 'package:vendor/views/global_variables.dart';

class OrderController {
  

  //Method Get 

  Future<List<Order>> loadOrders({
    required String vendorId 
  }) async{
    try{
      http.Response response = await http.get(Uri.parse('$uri/api/orders/vendors/$vendorId'),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      });

      if(response.statusCode==200){
       List<dynamic> data = jsonDecode(response.body);

       List<Order> orders = data.map((order)=> Order.fromJson(order)).toList();
      
      return orders;
      }else {
        throw Exception('Failed to load Orders');
      }
    }catch(e){
      throw Exception('error Loading Orders');
    }
  }

  Future<void> deleteOrder({
    required String id , 
    required context 
  }) async {
    try{
      http.Response response = await http.delete(Uri.parse('$uri/api/orders/$id'), 
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      });

      manageHttpResponse(response: response, context: context, onSuccess: (){
        showSnackBar(context, "Order Deleted Successfully");
      });
    }catch(e){
      showSnackBar(context, e.toString());
    }
  }
}