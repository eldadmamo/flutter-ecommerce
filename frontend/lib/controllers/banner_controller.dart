import 'dart:convert';

import 'package:ecommerceflutter/global_variables.dart';
import 'package:ecommerceflutter/models/banner_model.dart';
import 'package:http/http.dart' as http;

class BannerController {
   Future<List<BannerModel>> loadBanners() async {
    try{
      http.Response response = await http.get(Uri.parse('$uri/api/banners'), 
      headers: <String, String> {
        "Content-Type": "application/json; charset=UTF-8"
      }
      );

      
      if(response.statusCode==200){
      List<dynamic> data = jsonDecode(response.body);

      List<BannerModel> banners = 
         data.map((banner)=>BannerModel.fromJson(banner)).toList();

      
      return banners;
      } else if(response.statusCode == 404){
      return [];
      } else {
        throw Exception('Failed to load Banners');
      }
    }catch(e){
      throw Exception('Error loading Banners $e');
    }
  }
}
