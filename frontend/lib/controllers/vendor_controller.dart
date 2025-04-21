import 'dart:convert';
import 'package:ecommerceflutter/global_variables.dart';
import 'package:ecommerceflutter/models/vendor_model.dart';
import 'package:http/http.dart' as http;

class VendorController {
   Future<List<Vendor>> loadVendors() async {
    try{
      http.Response response = await http.get(
        Uri.parse('$uri/api/vendors'), 
      headers: <String, String> {
        "Content-Type": "application/json; charset=UTF-8"
      }
      );

      
      if(response.statusCode==200){
      List<dynamic> data = jsonDecode(response.body);

      List<Vendor> vendors = 
         data.map((vendor)=>Vendor.fromJson(vendor)).toList();

      
      return vendors;
      } else if(response.statusCode == 404){
      return [];
      } else {
        throw Exception('Failed to load vendors');
      }
    }catch(e){
      throw Exception('Error loading vendors $e');
    }
  }
}
