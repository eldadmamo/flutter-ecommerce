import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vendor/models/vendor.dart';
import 'package:http/http.dart' as http;
import 'package:vendor/services/manage_http_response.dart';
import 'package:vendor/views/global_variables.dart';
import 'package:vendor/views/screens/main_vendor_screen.dart';

class VendorAuthController {
  Future<void> signUpVendor({
    required fullName,
    required String email,
    required String password, 
    required context
  })async {
    try{
      Vendor vendor = Vendor(
        id: '', fullName: fullName, email: email, state: '', city: '', locality: '', role: '', 
        password: password);

        http.Response response =  await http.post(Uri.parse('$uri/api/vendor/signup'),
        body: vendor.toJson(), 
        headers: <String, String> {
          "Content-Type": "application/json; charset=UTF-8"
        });

      // 
      manageHttpResponse(response: response, context: context, 
      onSuccess: (){
        showSnackBar(context, 'Vendor Account Created');
      });
    }catch(e){
      showSnackBar(context, '$e');
    }
  }

  //function to cunsome the backend vendor signin api

  Future<void> signInVendor({
    required String email,
    required String password,
    required context 
  })async{
    try{

      http.Response response = await http.post(Uri.parse('$uri/api/vendor/signin'),
      body: jsonEncode({"email": email, "password":password}),
      headers: <String, String> {
        "Content-Type": "application/json; charset-UTF=8"
      }
      );
      
      manageHttpResponse(response: response, context: context, 
      onSuccess: (){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
          return const MainVendorScreen();
        },), (route) => false); 
        showSnackBar(context, "logged in Successfully");
      });
    }catch(e){
      showSnackBar(context, '$e');
    }
  }
}

