import 'dart:convert';

class Categorys {
  final String id; 
  final String name;
  final String image;
  final String banner;

  Categorys({required this.id, required this.name, required this.image, required this.banner});

  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
      'banner': banner,
    };
  }

  factory Categorys.fromMap(Map<String, dynamic> map) {
    return Categorys(
      id: map['id'] as String,
      name: map['name'] as String,
      image: map['image'] as String,
      banner: map['banner'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Categorys.fromJson(String source) => Categorys.fromMap(json.decode(source) as Map<String, dynamic>);
}

