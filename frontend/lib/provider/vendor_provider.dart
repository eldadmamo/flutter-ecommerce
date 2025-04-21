import 'package:ecommerceflutter/models/banner_model.dart';
import 'package:ecommerceflutter/models/vendor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VendorProvider extends StateNotifier<List<Vendor>>{
  VendorProvider(): super([]); 

  // 

  void setVendors(List<Vendor> vendors){
    state = vendors;
  }
}

final vendorProvider = StateNotifierProvider<VendorProvider, List<Vendor>>(
  (ref)  {
    return VendorProvider();
  }
);