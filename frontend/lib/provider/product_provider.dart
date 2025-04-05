
import 'package:ecommerceflutter/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductProvider extends StateNotifier<List<Product>> {
  ProductProvider(): super([]);

  //set list of products
  void setProducts(List<Product>products){
    state = products;
  }

}

final productProvider = StateNotifierProvider<ProductProvider, List<Product>>(
  (ref){
    return ProductProvider();
  }
);