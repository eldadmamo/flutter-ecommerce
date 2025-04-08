import 'dart:convert';

import 'package:ecommerceflutter/models/cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


//Define a StateNotifierProvider to expose an instance of the CartNotifier
//Making it accessible within our app

final cartProvider = StateNotifierProvider<CartNotifier, Map<String, Cart>>(
  (ref){
    return CartNotifier();
  }
);

// a notifier class to manage the cart state, extending statenotifier
class CartNotifier extends StateNotifier<Map<String,Cart>>{ 
  CartNotifier(): super({}){
    _loadCartItems();
  }

  Future<void> _loadCartItems() async{
    final prefs = await SharedPreferences.getInstance();
    // fetch the json string of the favoirte items from sharedpreferneces under the key favorite 
    final cartString = prefs.getString('cart_items');
    // check if the string is not null, there is saved data to load
    if(cartString!=null){
      //decode the json string to map in dymanic data
     final Map<String,dynamic> cartMap = jsonDecode(cartString);

     // convert the dynamic into a map of Favorite Object using the "fromjson" factory method
     final cartItems = cartMap
     .map((key,value)=> 
        MapEntry(key, Cart.fromJson(value)));

     //updating the staus with the loaded favorites
     state = cartItems ;

     
    }
  }


  // A private method that saves the current list of favorite items to shared preferences
  Future<void> _saveCartItems() async{
    final prefs = await SharedPreferences.getInstance();
    //encoding the current state (Map of favorite object) into json String
    final cartString = jsonEncode(state);
    //saving the json string to sharedpreferences with the key "favorites"
    await prefs.setString('cart_items', cartString);

  }

  //Method to add product to the cart 
  void addProductToCart({
  required String productName,
  required int productPrice,
  required String category,
  required List<String> image,
  required String vendorId,
  required int productQuantity,
  required int quantity,
  required String productId,
  required String description,
  required String fullName
  }){
    // check if the product is already is in cart

    if(state.containsKey(productId)){
      // if the product is already in the cart, update its quantity and maybe other detail
      state ={
        ...state,
      productId: Cart(
        productName: state[productId]!.productName, 
        productPrice: state[productId]!.productPrice,
        category: state[productId]!.category, 
        image: state[productId]!.image, 
        vendorId: state[productId]!.vendorId, 
        productQuantity: state[productId]!.productQuantity, 
        quantity: state[productId]!.quantity + 1, 
        productId: state[productId]!.productId,
        description: state[productId]!.description, 
        fullName: state[productId]!.fullName
        )
      };
      _saveCartItems();
    } else {
      //if the product is not in the cart, add it with the provided details 
      state = {
        ...state, 
        productId: Cart(
          productName: productName, 
          productPrice: productPrice, 
          category: category, 
          image: image, 
          vendorId: vendorId, 
          productQuantity: productQuantity,
          quantity: quantity, 
          productId: productId,  
          description: description, 
          fullName: fullName
        )
      };
      _saveCartItems();
    }
  }

  void IncrementCartItem(String productId){
    if(state.containsKey(productId)){
      state[productId]!.quantity++;

      // Notify listeners that the state has changed
      state = {...state};
      _saveCartItems();
    }
  }

 //Method to decrement the quantity of the product in the cart
 void decrementCartItem(String productId){
   if(state.containsKey(productId)){
    state[productId]!.quantity--;

    state = {...state};
    _saveCartItems();
   }
 }

 //Methd to remove item from the cart
 void removeCartItem(String productId){
  state.remove(productId);
  //Notify
  state = {...state};
  _saveCartItems();
 }

 //Methd to calculate total amount of items we have in cart
 double calculateTotalAmount(){
    double totalAmount = 0.0;
    state.forEach((productId, cartItem){
      totalAmount += cartItem.quantity * cartItem.productPrice;
    });

    return totalAmount;
 }

 void clearCart(){
  state = {};

  state = {...state};

  _saveCartItems();
 }

 Map<String, Cart> get getCartItems => state;
 

}