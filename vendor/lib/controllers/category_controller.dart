

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vendor/models/category.dart';
import 'package:vendor/views/global_variables.dart';

class CategoryController {
  
  // load the uploaded category

  Future<List<Categorys>> loadCategories() async{
    try{

     http.Response response = await http.get(
      Uri.parse('$uri/api/categories'),
     headers: <String, String>{
      "Content-Type": 'application/json; charset=UTF-8'
     });

     print(response.body);

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