
import 'package:ecommerceflutter/global_variables.dart';
import 'package:ecommerceflutter/models/product_review.dart';
import 'package:ecommerceflutter/services/manage_http_response.dart';
import 'package:http/http.dart' as http;

class ProductReviewController {
  uploadReview({
  required String buyerId,
  required String email,
  required String fullName,
  required String productId,
  required double rating,
  required String review,
  required context
  })async{
    try{
      final ProductReview productReview = ProductReview(
        id: '', 
        buyerId: buyerId, 
        email: email,
        fullName: fullName, 
        productId: productId, 
        rating: rating, 
        review: review
      );

      http.Response response =  await http.post(Uri.parse('$uri/api/product-review'),
        body: productReview.toJson(),
        headers: <String, String> {
          "Content-Type": "application/json; charset=UTF-8"
        });


        manageHttpResponse(response: response, context: context, onSuccess: (){
          showSnackBar(context, "you have added a review a order");
        });
    }catch(e){
      showSnackBar(context, "");
    }
  }
}