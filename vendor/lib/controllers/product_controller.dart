import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
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
   if (pickedImages!=null){
     final cloudinary = CloudinaryPublic("dggixttgq", "flutter");

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
            "Content-Type": 'application/json; charset=UTF-8'
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
}