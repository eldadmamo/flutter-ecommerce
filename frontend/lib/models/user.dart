import 'dart:convert';


class User {
  // Define Fields
  final String id;
  final String fullName;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String password;
  final String token;

  User({required this.id, required this.fullName, required this.email, required this.state, required this.city, required this.locality, required this.password , required this.token});

  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      "id": id,
      "fullName": fullName,
      "email": email, 
      "state": state,
      "city": city,
      "locality": locality,
      "password": password,
      "token": token
    };
  }

  //Serialization: Convert Map to a JSON string

  //The json.encode(_)
  String toJson() => json.encode(toMap());

  //deserilization: Convert the Map to User Object
  // and converts it into a User Object. if a field is not presen in the 
  // it defaults to an empty String.

  //fromMap:  This constructor take a Map<String, dynamic> and convert into a User Object
  // its useful when you already have the data in map format;
  factory User.fromMap(Map<String, dynamic>map){
    return User(
      id: map['_id'] as String? ?? "", 
      fullName: map['fullName'] as String? ?? "", 
      email: map['email'] as String? ?? "", 
      state: map['state'] as String? ?? "", 
      city: map['city'] as String? ?? "", 
      locality: map['locality'] as String? ?? "", 
      password: map['password'] as String? ?? "",
      token: map['token'] as String? ?? "",
    );
  }

  // fromJson: This factory constructor takes Json String, and decodes into a Map<String, dynamic> 
  //

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}