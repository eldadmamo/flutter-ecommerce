

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor/models/product.dart';

class VendorProductProvider extends StateNotifier<List<Product>> {
  VendorProductProvider(): super([]);

  //set list of products
  void setProducts(List<Product>products){
    state = products;
  }

}

final vendorProductProvider = StateNotifierProvider<VendorProductProvider, List<Product>>(
  (ref){
    return VendorProductProvider();
  }
);