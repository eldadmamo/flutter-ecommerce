// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Vendor {
  //Define the Fields that we need
  final String id;
  final String fullName;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String role;
  final String password;

  Vendor({required this.id, required this.fullName, required this.email, required this.state, required this.city, required this.locality, required this.role, required this.password});


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      'role': role,
      'password': password,
    };
  }
   //Converting to Json because the data will be sent to Json
   String toJson() => json.encode(toMap());

  //converting back to the vendor user Object so that we can make use f it within our application
  factory Vendor.fromMap(Map<String, dynamic> map) {
    return Vendor(
      id: map['_id'] as String? ?? "",
      fullName: map['fullName'] as String? ?? "",
      email: map['email'] as String? ?? "",
      state: map['state'] as String? ?? "",
      city: map['city'] as String? ?? "",
      locality: map['locality'] as String? ?? "",
      role: map['role'] as String? ?? "",
      password: map['password'] as String? ?? "",
    );
  }

}
