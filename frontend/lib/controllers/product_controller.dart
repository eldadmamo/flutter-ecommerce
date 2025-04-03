import 'dart:convert';

import 'package:ecommerceflutter/global_variables.dart';
import 'package:ecommerceflutter/models/product.dart';
import 'package:http/http.dart' as http;

class ProductController {
   
   Future<List<Product>> loadPopularProducts() async {
    try{
     http.Response response = await http.get(Uri.parse("$uri/api/popular-products"),
      headers: <String, String>{
        "Content-Type": 'application/json; charset=UTF-8'
      });

      print(response.body);

    
    if(response.statusCode==200){
    final Map<String, dynamic> responseData = json.decode(response.body);
      // Extract the 'product' list from the Map
      final List<dynamic> data = responseData['product'];

      List<Product> products = data
          .map((product) => Product.fromMap(product as Map<String, dynamic>))
          .toList();
      return products;

    } else {
      throw Exception('Failed to load popular products');
    }

    }catch(e){
      throw Exception('Error loading Products $e');
    }
   }

   Future<List<Product>> loadProductByCategory(String category) async{
    try{
      http.Response response =  await http.get(Uri.parse('$uri/api/products-by-category/$category'),
      headers: <String, String> {
        "Content-Type":"application/json; charset=UTF-8"
      });

      print(response.body);

      if(response.statusCode==200){
     final List<dynamic> data = json.decode(response.body) as List<dynamic>;

    List<Product> products =  data
    .map((product) => Product.fromMap(product as Map<String,dynamic>))
    .toList();
    return products;

    } else {
      throw Exception('Failed to load popular products');
    }
    }catch(e){
      throw Exception('Error loading products $e');
    }
   }
}