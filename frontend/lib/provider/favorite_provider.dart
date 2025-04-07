import 'package:ecommerceflutter/models/favorite.dart';
import 'package:ecommerceflutter/provider/cart_provider.dart';
import 'package:ecommerceflutter/provider/category_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final favoriteProvider = 
   StateNotifierProvider<FavoriteNotifier, Map<String, Favorite>>(
  (ref){
    return FavoriteNotifier();
  }
);

class FavoriteNotifier extends StateNotifier<Map<String, Favorite>>{
  FavoriteNotifier():super({});

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
  }

  void removeCartItem(String productId){
    state.remove(productId);
    //notify listeners that the state has changed
    state = {...state};
  }

  Map<String, Favorite> get getFavoriteItem => state;
}