import 'dart:convert';

import 'package:ecommerceflutter/global_variables.dart';
import 'package:ecommerceflutter/models/category.dart';
import 'package:ecommerceflutter/services/manage_http_response.dart';
import 'package:http/http.dart' as http;

class CategoryController {
  
  // load the uploaded category

  Future<List<Categorys>> loadCategories() async{
    try{

     http.Response response = await http.get(
      Uri.parse('$uri/api/categories'),
     headers: <String, String>{
      "Content-Type": 'application/json; charset=UTF-8'
     });

     

     if(response.statusCode==200){
     final List<dynamic> data = jsonDecode(response.body);
     List<Categorys> categories = 
       data.map((category) => Categorys.fromJson(category)).toList();

     return categories;
     } else {
      throw Exception('failed to load categories');
     }

    }catch(e){
      throw Exception('Error loading Categories: $e'); 
    }
  } 
}