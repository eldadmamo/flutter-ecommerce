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
import 'package:vendor/views/screens/authentication/login_screen.dart';

final providerContainer =  ProviderContainer();
class VendorAuthController {
  
  Future<void> signUpVendor({
    required fullName,
    required String email,
    required String password, 
    required WidgetRef ref,
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
      manageHttpResponse(
      response: response, 
      context: context, 
      onSuccess: (){
        final vendorJson = jsonEncode(jsonDecode(response.body));

        ref.watch(vendorProvider.notifier).setVendor(vendorJson);

        Navigator.pushAndRemoveUntil(context, 
        MaterialPageRoute(builder: (context){
          return const LoginScreen();
        }), (route) => false);
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
    required WidgetRef ref
  })async{
    try{

      http.Response response = await http.post(Uri.parse('$uri/api/v2/vendor/signin'),
      body: jsonEncode({"email": email, "password":password}),
      headers: <String, String> {
        "Content-Type": "application/json; charset-UTF=8"
        }
      );
      print(response.body);
      
      manageHttpResponse(
  response: response, 
  context: context, 
  onSuccess: () async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final responseBody = jsonDecode(response.body);
    
    // Extract token and vendor data separately
    String token = responseBody['token'];
    var vendorData = responseBody['vendorWithoutPassword'];
    
    // Combine vendor data with token
    vendorData['token'] = token;
    final vendorJson = jsonEncode(vendorData);

    ref.read(vendorProvider.notifier).setVendor(vendorJson);
    await preferences.setString('vendor', vendorJson);
    await preferences.setString('auth_token', token);

    if(token.isNotEmpty) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainVendorScreen()),
        (route) => false
      );
      showSnackBar(context, 'Logged In Successfully');
    }
  }
);
    }catch(e){
      showSnackBar(context, '$e');
    }
  }

  getUserData(BuildContext context, WidgetRef ref) async{
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

