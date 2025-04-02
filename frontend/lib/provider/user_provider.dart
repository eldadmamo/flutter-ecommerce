
import 'package:ecommerceflutter/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProvider extends StateNotifier<User?> {

  //purpose: is to manage of the user object allowing updates
  UserProvider()
  : super(User(
      id: '', 
      fullName: '', 
      email: '', 
      state: '', 
      city: '', 
      locality: '',
      password: '',
      token: ''
       ));
       //Get method to extract value from an object

    User? get user => state;

    //method to set user state from Json
    // purpose: update he user state on json string representation user object

    void setUser(String userJson) {
      state=User.fromJson(userJson);
    }
    // make the data acceisible within the application
    final userProvider = StateNotifierProvider<UserProvider, User?>((ref)=> UserProvider());
}