import 'package:ecommerceflutter/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopRatedProductProvider extends StateNotifier<List<Product>> {
  TopRatedProductProvider(): super([]);

  //set list of products
  void setProducts(List<Product>products){
    state = products;
  }

}

final topRatedProductProvider = StateNotifierProvider<TopRatedProductProvider, List<Product>>(
  (ref){
    return TopRatedProductProvider();
  }
);