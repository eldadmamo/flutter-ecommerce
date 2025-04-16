import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor/models/vendor.dart';

class VendorProvider extends StateNotifier<Vendor?> {
  VendorProvider():super(Vendor(
    id: '', 
    fullName: '', 
    email: '', 
    state: '', 
    city: '',
    locality: '', 
    role: '', 
    password: '', 
    token: '',
  ));

  //Getter methnd to extract value from an object
  Vendor ? get vendor => state;

  // Method to set vendor state from json

  void setVendor(String vendorJson){
    state = Vendor.fromJson(vendorJson);
  }

  void signOut(){
    state = null;
  }
}
//make the data accessible
final vendorProvider = StateNotifierProvider<VendorProvider,Vendor?>((ref){
  return VendorProvider();
});