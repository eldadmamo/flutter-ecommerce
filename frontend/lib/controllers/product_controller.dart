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

    } else if(response.statusCode == 404) {
      return [];
    } 
    else {
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

    } else if(response.statusCode == 404){
      return [];
    } else {
      throw Exception('Failed to load popular products');
    }
    }catch(e){
      throw Exception('Error loading products $e');
    }
   }

   //display realted product by subcategory
   Future<List<Product>> loadRelatedProductsBySubcategory(String productId) async{
    try{
      http.Response response =  await http.get(Uri.parse('$uri/api/related-products-by-subcategory/$productId'),
      headers: <String, String> {
        "Content-Type":"application/json; charset=UTF-8"
      });

      print(response.body);

      if(response.statusCode==200){
     final List<dynamic> data = json.decode(response.body) as List<dynamic>;

    List<Product> realtedProducts =  data
    .map((product) => Product.fromMap(product as Map<String,dynamic>))
    .toList();
    return realtedProducts;

    } else if(response.statusCode == 404){
      return [];
    } else {
      throw Exception('Failed to load realted products');
    }
    }catch(e){
      throw Exception('Error related  products $e');
    }
   }

   Future<List<Product>> loadTopRatedProduct() async{
    try{
      http.Response response =  await http.get(
        Uri.parse('$uri/api/top-rated-products'),
        headers: <String, String> {
        "Content-Type":"application/json; charset=UTF-8"
      });

      print(response.body);

      if(response.statusCode==200){
     final List<dynamic> data = json.decode(response.body) as List<dynamic>;

    List<Product> topRatedProducts =  data
    .map((product) => Product.fromMap(product as Map<String,dynamic>))
    .toList();
    return topRatedProducts;

    } else if(response.statusCode == 404){
      return [];
    } else {
      throw Exception('Failed to load top Rated products');
    }
    }catch(e){
      throw Exception('Error related  products $e');
    }
   }


   Future<List<Product>> loadProductsBySubcategory(String subCategory) async{
    try{
      http.Response response =  await http.get(Uri.parse('$uri/api/products-by-subcategories/$subCategory'),
      headers: <String, String> {
        "Content-Type":"application/json; charset=UTF-8"
      });

      print(response.body);

      if(response.statusCode==200){
     final List<dynamic> data = json.decode(response.body) as List<dynamic>;

    List<Product> realtedProducts =  data
    .map((product) => Product.fromMap(product as Map<String,dynamic>))
    .toList();
    return realtedProducts;

    } else if(response.statusCode == 404){
      return [];
    } else {
      throw Exception('Failed to load subcategory products');
    }
    }catch(e){
      throw Exception('Error subcategories products $e');
    }
   }

   //Method to search for products by name of description

   Future<List<Product>> searchProducts(String query) async{
    try{
      http.Response response =  await http.get(Uri.parse('$uri/api/search-products?query=$query'),
      headers: <String, String> {
        "Content-Type":"application/json; charset=UTF-8"
      });

      print(response.body);

      if(response.statusCode==200){
     final List<dynamic> data = json.decode(response.body) as List<dynamic>;

    List<Product> searchedProducts =  data
    .map((product) => Product.fromMap(product as Map<String,dynamic>))
    .toList();
    return searchedProducts;

    } else if(response.statusCode == 404){
      return [];
    } else {
      throw Exception('Failed to load searchedProducts products');
    }
    }catch(e){
      throw Exception('Error loading searched Products $e');
    }
   }

    Future<List<Product>> loadVendorProducts(String vendorId) async{
    try{
      http.Response response =  await http.get(
      Uri.parse('$uri/api/products/vendor/$vendorId'),
      headers: <String, String> {
        "Content-Type":"application/json; charset=UTF-8"
      });

      print(response.body);

      if(response.statusCode==200){
     final List<dynamic> data = json.decode(response.body) as List<dynamic>;

    List<Product> vendorProducts =  data
    .map((product) => Product.fromMap(product as Map<String,dynamic>))
    .toList();
    return vendorProducts;

    } else if(response.statusCode == 404){
      return [];
    } else {
      throw Exception('Failed to load vendors products');
    }
    }catch(e){
      throw Exception('Error vendors products $e');
    }
   }
}