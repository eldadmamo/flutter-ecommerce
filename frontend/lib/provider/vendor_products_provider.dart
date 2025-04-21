
import 'package:ecommerceflutter/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VendorProductsProvider extends StateNotifier<List<Product>> {
  VendorProductsProvider(): super([]);

  //set list of products
  void setProducts(List<Product>products){
    state = products;
  }

}

final vendorProductsProvider = StateNotifierProvider<VendorProductsProvider, List<Product>>(
  (ref){
    return VendorProductsProvider();
  }
);