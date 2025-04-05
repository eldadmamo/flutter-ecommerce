import 'package:ecommerceflutter/models/category.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryProvider extends StateNotifier<List<Categorys>> {
  CategoryProvider() : super([]);

  void setCategories(List<Categorys> categories){
    state = categories;
  }
}

final categoryProvider = StateNotifierProvider<CategoryProvider, List<Categorys>>(
  (ref){
    return CategoryProvider();
  }
);