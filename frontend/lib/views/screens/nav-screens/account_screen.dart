import 'package:ecommerceflutter/controllers/auth_controller.dart';
import 'package:ecommerceflutter/views/screens/detail/screens/order_screen.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/home_screen.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});
  final AuthController _authController = AuthController();
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: ()async{
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return OrderScreen();
            }));
        }, 
        child: Text('My Orders'))
      ),
    );
  }
}