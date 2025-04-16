import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor/models/vendor.dart';
import 'package:http/http.dart' as http;
import 'package:vendor/provider/vendor_provider.dart';
import 'package:vendor/services/manage_http_response.dart';
import 'package:vendor/views/global_variables.dart';
import 'package:vendor/views/screens/main_vendor_screen.dart';


final providerContainer =  ProviderContainer();
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
        password: password, 
        token: ''
        
        );

        http.Response response =  await http.post(Uri.parse('$uri/api/v2/vendor/signup'),
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
    required context , 
  })async{
    try{

      http.Response response = await http.post(Uri.parse('$uri/api/v2/vendor/signin'),
      body: jsonEncode({"email": email, "password":password}),
      headers: <String, String> {
        "Content-Type": "application/json; charset-UTF=8"
        }
      );
      
      manageHttpResponse(response: response, context: context, 
      onSuccess: () async{
       //Access sharedPreferances for token and user data storage
          SharedPreferences preferences = 
            await SharedPreferences.getInstance();
          
           //Extract the authentication token from the response body
           String token = jsonDecode(response.body)['token'];

           //Store the authentication token securely in SharedPreferances
          preferences.setString('auth_token', token);

           //Encode user data recieved from backend as json
           final userJson = jsonEncode(jsonDecode(response.body));

           //update the application state with the user data using riverpod
           ref.read(vendorProvider.notifier).setVendor(response.body);
           
           // store the data in sharedPreferences
           await preferences.setString('user', userJson);

          if(ref.read(vendorProvider)!.token.isNotEmpty){
          Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (context) {
           return const MainVendorScreen();
          }), 
          (route) => false);
           showSnackBar(context, 'Logged In');
          }
      });
    }catch(e){
      showSnackBar(context, '$e');
    }
  }

  getUserData(context , WidgetRef ref) async{
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');

      if(token==null){
        preferences.setString('auth_token', '');
      }

      var tokenResponse =  await http.post(
      Uri.parse('$uri/vendor-tokenIsValid'), 
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
        "x-auth-token": token!
        }, 
      );

      var response = jsonDecode(tokenResponse.body);
      print(response);
      if(response==true){
        http.Response userResponse = await http.get(
          Uri.parse('$uri/get-vendor'), 
         headers: <String, String>{
           "Content-Type": "application/json; charset=UTF-8",
           "x-auth-token": token
        }, 
      );
      
 
      ref.read(vendorProvider.notifier).setVendor(userResponse.body);
      }

      
    }catch(e){
      showSnackBar(context, e.toString());
    }
   }
}

