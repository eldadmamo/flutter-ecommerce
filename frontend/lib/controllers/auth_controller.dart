import 'package:ecommerceflutter/global_variables.dart';
import 'package:ecommerceflutter/models/user.dart';
import 'package:ecommerceflutter/provider/delivered_order_count_provider.dart';
import 'package:ecommerceflutter/provider/user_provider.dart';
import 'package:ecommerceflutter/services/manage_http_response.dart';
import 'package:ecommerceflutter/views/screens/authentication_screens/otp_screen.dart';
import 'package:ecommerceflutter/views/screens/detail/screens/checkout_screen.dart';
import 'package:ecommerceflutter/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:ecommerceflutter/views/screens/authentication_screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
          MaterialPageRoute(builder: (context) {
          return OtpScreen(email:email);
          }
          ),);
      showSnackBar(context, 'Account has been created for you');
      });
    }catch(e){
      print("Error: $e");
    }
  }

  Future<void> signInUsers({
    required BuildContext context, 
    required String email, 
    required String password, 
    required WidgetRef ref 
    }) async {
     
    
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
           ref.read(userProvider.notifier).setUser(response.body);
           
           // store the data in sharedPreferences
           await preferences.setString('user', userJson);

          if(ref.read(userProvider)!.token.isNotEmpty){
            Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (context) {
           return MainScreen();
          }), 
          (route) => false);
           showSnackBar(context, 'Logged In');
          }
       
      });
    }catch(e){
      showSnackBar(context, e.toString());  
    }
  }

   getUserData(context , WidgetRef ref) async{
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');

      if(token==null){
        preferences.setString('auth_token', '');
      }

      var tokenResponse =  await http.post(Uri.parse('$uri/tokenIsValid'), 
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
        "x-auth-token": token!
        }, 
      );

      var response = jsonDecode(tokenResponse.body);
      print(response);
      if(response==true){
        http.Response userResponse = await http.get(
          Uri.parse('$uri/'), 
         headers: <String, String>{
           "Content-Type": "application/json; charset=UTF-8",
           "x-auth-token": token
        }, 
      );
      
 
      ref.read(userProvider.notifier).setUser(userResponse.body);
      }

      
    }catch(e){
      showSnackBar(context, e.toString());
    }
   }

  //Signout
  Future<void> signoutUser({required context, required WidgetRef ref}) async{
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      //clear token and user sharedPreferences
      await preferences.remove('auth_token');
      await preferences.remove('user');
      //clear the user state
      ref.read(userProvider.notifier).signOut();
      ref.read(deliveredOrderCountProvider.notifier).resetCount();

      // navigate the user back to the logined

      Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (context){
        return LoginScreen();
      }), 
      (route) => false);

      showSnackBar(context, 'signout Successfully');
    }catch(e){
      showSnackBar(context, 'error signing out');
    }
  }

  Future<void> updateUserLocation({
    required BuildContext context,
    required String id, 
    required String state,
    required String city,
    required String locality,
    required WidgetRef ref,
  }) async {
    try{
      final http.Response response =  await http.put(Uri.parse('$uri/api/users/$id'), 
      body: jsonEncode({
        'state':state,
        'city': city,
        'locality': locality 
      }),
      headers: <String, String>{
        "Content-Type" : "application/json; charset=UTF-8"
      });

      print(response.body);

      manageHttpResponse(
      response: response, 
      context: context, 
      onSuccess: () async{
        final updateUser = jsonDecode(response.body);
        // Access Shared preferences for local data storage
        // shared preferences allow us to store data persistently on the device
        SharedPreferences preferences = await SharedPreferences.getInstance();  

        final userJson = jsonEncode(updateUser);

        ref.read(userProvider.notifier).setUser(userJson);

        await preferences.setString('user', userJson);

      
        showSnackBar(context, 'Saved Successfully');
      });

    }catch(e){
      showSnackBar(context, 'Error updating location');
    }
  }
  Future<void> verifyOtp({
    required BuildContext context, 
    required String email,
    required String otp 
  })async{
    try{
    http.Response response = await http.post(Uri.parse('$uri/api/verify-otp'), 
      body : jsonEncode({
        "email": email,
        "otp": otp
      }), 
      headers: <String, String> {
        "Content-Type" : "application/json; charset=UTF-8"
      }
      );

      manageHttpResponse(
        response: response, 
        context: context, 
        onSuccess: (){
          Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (context) {
             return const LoginScreen();
             }), 
          (route) => false);

          showSnackBar(context, "Account verified . Please Login in");
        });
    }catch(e){
      showSnackBar(context, "Error veified OTP: $e");
    }
  }

  Future<void> deleteAccount({
    required BuildContext context, 
    required String id, 
    required WidgetRef ref //Access to the RiverPord Provider 
    })async{
      try{
        //Get the authentication token from shared preferences from authorization
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? token = preferences.getString('auth_token');
 
        if(token==null){
          showSnackBar(context, "you need to log in perform this action");
        }
         http.Response response = await http.delete(Uri.parse('$uri/api/user/delete-account/$id'),
         headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
        "x-auth-token": token!
           }
         ); 

         manageHttpResponse(
          response: response, 
          context: context, 
          onSuccess: ()async{
            
            //handle successful deletion, navigate the user back to the login screen

            await preferences.remove('auth_token');

            await preferences.remove('user');

            ref.read(userProvider.notifier).signOut();

           //Redirect to the login screen after successful deletion
           
           showSnackBar(context, "Account deleted Successfully");

         Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(
            builder: (context){
              return const LoginScreen();
            }), 
              (route) => false);
          }
        );
      }catch(e){
        showSnackBar(context, "error Deleting account $e");
      }
    }
}