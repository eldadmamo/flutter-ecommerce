import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor/models/orders.dart';
import 'package:vendor/services/manage_http_response.dart';
import 'package:vendor/views/global_variables.dart';

class OrderController {
  

  //Method Get 

  Future<List<Order>> loadOrders({
    required String vendorId 
  }) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('auth_token');
    try{
      http.Response response = await http.get(Uri.parse('$uri/api/orders/vendors/$vendorId'),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
        "x-auth-token": token!, 
      });

      
      // print('Sending token: $token');



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

  Future<void> updateDeliveryStatus({
    required String id,
    required context 
    }) async {
      try{
       http.Response response =  await http.patch(
         Uri.parse('$uri/api/orders/$id/delivered'), 
         headers: <String, String> {
          "Content-Type": "application/json; charset=UTF-8",
         }, 
         body: jsonEncode({
          "delivered": true, 
          "processing": false
         }),
         );

        manageHttpResponse(response: response, context: context, onSuccess: (){
          showSnackBar(context, "Order Updated");
        });
      }catch(e){
        showSnackBar(context, e.toString());
      }
    }

    Future<void> cancelOrder({
    required String id,
    required context 
    }) async {
      try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
       String? token = sharedPreferences.getString('auth_token');
       http.Response response =  await http.patch(
         Uri.parse('$uri/api/orders/$id/processing'), 
         headers: <String, String> {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token!, 
         }, 
         body: jsonEncode({
          "processing": false, 
          "delivered": false
         }),
         );

        manageHttpResponse(response: response, context: context, onSuccess: (){
          showSnackBar(context, "Order Cancelled" );
        });
      }catch(e){
        showSnackBar(context, e.toString());
      }
    }
}