import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor/models/product.dart';
import 'package:vendor/services/manage_http_response.dart';
import 'package:vendor/views/global_variables.dart';
import 'package:http/http.dart' as http;

class ProductController {
  Future<void> uploadProduct({
    required String productName,
    required int productPrice,
    required int quantity,
    required String description,
    required String category,
    required String vendorId,
    required String fullName,
    required String subCategory,
    required List<XFile>? pickedImages, 
    required context,
  })async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('auth_token');
   if (pickedImages!=null){
     final cloudinary = CloudinaryPublic(
      cloud,
      upload
      );
      

     List<String> images = [];

     for(var i=0; i < pickedImages.length; i++){
     CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(CloudinaryFile.fromFile(pickedImages[i].path, folder: productName),);

      // add the secure Url to 
      images.add(cloudinaryResponse.secureUrl);
     }
     if(category.isNotEmpty && subCategory.isNotEmpty){
      final Product product = Product(
         id: '', 
         productName: productName, 
         productPrice: productPrice, 
         quantity: quantity, 
         description: description, 
         category: category, 
         vendorId: vendorId, 
         fullName: fullName,
         subCategory: subCategory, 
         images: images
         );
        http.Response response = await http.post(Uri.parse("$uri/api/add-product"), 
          body: product.toJson(),
          headers: <String, String> {
            "Content-Type": 'application/json; charset=UTF-8',
            'x-auth-token': token!
          }
         );
         manageHttpResponse(response: response, context: context, onSuccess: (){
          showSnackBar(context, 'Product Uploaded');
         });
     } else {
      showSnackBar(context, 'Select Category');
     }
   } else {
    showSnackBar(context, 'Select Image');
   }


  }


   //display realted product by subcategory
   Future<List<Product>> loadVendorsProducts(String vendorId) async{
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');

      http.Response response =  await http.get(
        Uri.parse('$uri/api/products/vendor/$vendorId'),
      headers: <String, String> {
        "Content-Type":"application/json; charset=UTF-8",
        'x-auth-token':token!
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
      throw Exception('Failed to load Vendors products');
    }
    }catch(e){
      throw Exception('Error loading products $e');
    }
   }

    Future<List<String>> uploadImageToCloudinary(
      List<File>? pickedImages, 
      Product product
      )async {
      final cloudinary = CloudinaryPublic(cloud, upload);
      List<String> uploadedImages = [];

      for(var image in pickedImages!){
      CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path, folder: product.productName)
        );
        uploadedImages.add(cloudinaryResponse.secureUrl);
      }

      return uploadedImages;
    }

    Future<void> updateProduct({
      required Product product, 
      List<File>? pickedImages, 
      required BuildContext context
    })async{
      try{
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String? token = sharedPreferences.getString('auth_token');

    
        
        if(pickedImages!=null){
          await uploadImageToCloudinary(pickedImages, product);
        }
        final updateDataData = product.toMap();

        

      http.Response response = await http.put(
      Uri.parse('$uri/api/edit-product/${product.id}') ,
      body: jsonEncode(updateDataData), 
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
        "x-auth-token": token!
      }
      );

      print(response.body);

      manageHttpResponse(
        response: response, 
        context: context,
        onSuccess: (){
          showSnackBar(context, 'Product Updated Successfully');
        }
      );

      }catch(e){

      }
    }
  }