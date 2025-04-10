
import 'package:ecommerceflutter/models/subcategory.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubCategoryProvider extends StateNotifier<List<Subcategory>> {
  SubCategoryProvider(): super([]);

  // set the list of subcategoies
  void setSubcategoties(List<Subcategory> subcategories){
    state = subcategories;
  }
}

final subcategoryProvider = StateNotifierProvider<SubCategoryProvider, List<Subcategory>>(
  (ref) {
    return SubCategoryProvider();
  });