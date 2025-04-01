import 'dart:convert';

import 'package:admin/global_variable.dart';
import 'package:admin/services/manage_http_response.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:admin/models/category.dart';
import 'package:http/http.dart' as http;

class CategoryController {
  uploadCategory({
    required dynamic pickedImage, 
    required dynamic pickedBanner,
    required String name, 
    required context 
    }) async{
    try{
      final cloudinary = CloudinaryPublic(
        cloud,
        upload
        );

    CloudinaryResponse ImageResponse =  await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedImage, 
        identifier: 'pickedImage', folder: 'categoryImages'), 
      );

     String image = ImageResponse.secureUrl;

    CloudinaryResponse bannerResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedBanner, 
        identifier: 'pickedBanner', folder: 'categoryImages'));

    String banner = bannerResponse.secureUrl;

    Categorys category = Categorys(
      id: "", 
      name: name, 
      image: image, 
      banner: banner
      );
     http.Response response = await http.post(
      Uri.parse("$uri/api/categories"),
      body: category.toJson(),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
        }
      );

      manageHttpResponse(response: response, context: context, onSuccess: (){
        showSnackBar(context, 'Uploaded Category');
      } );
    }catch(e) {
      print('Error uploading to cloudinary: $e');
    }
  }
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