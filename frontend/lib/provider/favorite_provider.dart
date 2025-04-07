import 'dart:convert';

import 'package:ecommerceflutter/models/favorite.dart';
import 'package:ecommerceflutter/provider/cart_provider.dart';
import 'package:ecommerceflutter/provider/category_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


final favoriteProvider = 
   StateNotifierProvider<FavoriteNotifier, Map<String, Favorite>>(
  (ref){
    return FavoriteNotifier();
  }
);

class FavoriteNotifier extends StateNotifier<Map<String, Favorite>>{
  FavoriteNotifier():super({}){
    _loadFavorites();
  }

  // a private method that loads items from sharedpreferences 
  Future<void> _loadFavorites() async{
    final prefs = await SharedPreferences.getInstance();
    // fetch the json string of the favoirte items from sharedpreferneces under the key favorite 
    final favoriteString = prefs.getString('favorites');
    // check if the string is not null, there is saved data to load
    if(favoriteString!=null){
      //decode the json string to map in dymanic data
     final Map<String,dynamic> favoriteMap = jsonDecode(favoriteString);

     // convert the dynamic into a map of Favorite Object using the "fromjson" factory method
     final favorites = favoriteMap.map((key,value)=> 
     MapEntry(key, Favorite.fromJson(value)));

     //updating the staus with the loaded favorites
     state = favorites;

     
    }
  }
  // A private method that saves the current list of favorite items to shared preferences
  Future<void> _saveFavorite()async{
    final prefs = await SharedPreferences.getInstance();
    //encoding the current state (Map of favorite object) into json String
    final favoriteString = jsonEncode(state);
    //saving the json string to sharedpreferences with the key "favorites"
    await prefs.setString('favorites', favoriteString);

  }

  void addProductToFavorite({
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
    state[productId] = Favorite(
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
    );
    // notify listeners the state has changes
    state = {...state};
    _saveFavorite();
  }

  void removeCartItem(String productId){
    state.remove(productId);
    //notify listeners that the state has changed
    state = {...state};
    _saveFavorite();
  }

  Map<String, Favorite> get getFavoriteItem => state;
}