import 'package:ecommerceflutter/models/user.dart';
import 'package:ecommerceflutter/services/manage_http_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class AuthController {
  Future<void> signUpUsers({
    required BuildContext context,
    required String email,
    required String fullName, 
    required String password, 

  })async{
    String uri = dotenv.env['API_URI'] ?? 'http://default-value.com';
    print("API URI: $uri"); 
    try{
    User user =  User(
        id: '', 
        fullName: fullName,
        email: email, 
        state: '', 
        city: '', 
        locality: '',
        password: password,
        token: ''
        );
  http.Response response = await http.post(
    Uri.parse('$uri/api/signup'), 
    body: jsonEncode(user.toMap()),
    headers: <String, String>{
      "Content-Type": 'application/json; charset=UTF-8',
    });
    
    manageHttpResponse(
      response: response, 
      context: context, 
      onSuccess: (){
      showSnackBar(context, 'Account has been created for you');
      });
    }catch(e){
      print("Error: $e");
    }
  }

  Future<void> signInUsers({
    required context, 
    required String email, 
    required String password
    }) async {
     String uri = dotenv.env['API_URI'] ?? 'http://default-value.com';
    
    try{
     
    http.Response response = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({
          'email': email,
          'password': password
           },
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      
      manageHttpResponse(
        response: response, 
        context: context, 
        onSuccess: () {
        showSnackBar(context, 'Logged In');
      });
    }catch(e){
      print("Error $e");
    }
  }
}