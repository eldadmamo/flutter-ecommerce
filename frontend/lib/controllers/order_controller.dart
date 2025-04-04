import 'dart:convert';

import 'package:ecommerceflutter/global_variables.dart';
import 'package:ecommerceflutter/models/order.dart';
import 'package:ecommerceflutter/services/manage_http_response.dart';
import 'package:http/http.dart' as http;

class OrderController {
  uploadOrders({
    required String id,
  required String fullName,
  required String email,
  required String state,
  required String city,
  required String locality,
  required String productName, 
  required int productPrice,
  required int quantity,
  required String category, 
  required String image,
  required String buyerId, 
  required String vendorId,
  required bool processing,
  required bool delivered,
  required context 
  })async{
    try{
      final Order order = Order(
        id: id, 
        fullName: fullName, 
        email: email, 
        state: state, 
        city: city, 
        locality: locality, 
        productName: productName, 
        productPrice: productPrice,
        quantity: quantity, 
        category: category, 
        image: image, 
        buyerId: buyerId, 
        vendorId: vendorId, 
        processing: processing, 
        delivered: delivered
        );

        http.Response response =  await http.post(Uri.parse('$uri/api/orders'),
        body: order.toJson(),
        headers: <String, String> {
          "Content-Type": "application/json; charset=UTF-8"
        });


        manageHttpResponse(response: response, context: context, onSuccess: (){
          showSnackBar(context, "you have placed an order");
        });
    }catch(e){
      showSnackBar(context, e.toString());
    }
  }

  //Method Get 

  Future<List<Order>> loadOrders({
    required String buyerId 
  }) async{
    try{
      http.Response response = await http.get(Uri.parse('$uri/api/orders/$buyerId'),
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