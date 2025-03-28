import 'package:ecommerceflutter/models/user.dart';
import 'package:ecommerceflutter/services/manage_http_response.dart';
import 'package:ecommerceflutter/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:ecommerceflutter/views/screens/authentication_screens/login_screen.dart';
import 'package:ecommerceflutter/views/screens/authentication_screens/register_screen.dart';

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
        Navigator.push(context, 
          MaterialPageRoute(builder: (context) => const LoginScreen()));
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
          Navigator.pushAndRemoveUntil(context, 
          MaterialPageRoute(builder: (context) =>  MainScreen()), 
          (route) => false);
        showSnackBar(context, 'Logged In');
      });
    }catch(e){
      print("Error $e");
    }
  }
}