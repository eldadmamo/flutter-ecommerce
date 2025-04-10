import 'package:ecommerceflutter/controllers/category_controller.dart';
import 'package:ecommerceflutter/controllers/subcategory_controller.dart';
import 'package:ecommerceflutter/models/category.dart';
import 'package:ecommerceflutter/models/subcategory.dart';
import 'package:ecommerceflutter/provider/cart_provider.dart';
import 'package:ecommerceflutter/provider/category_provider.dart';
import 'package:ecommerceflutter/provider/subcategry_provider.dart';
import 'package:ecommerceflutter/views/screens/detail/screens/subcategory_product_screen.dart';
import 'package:ecommerceflutter/views/screens/detail/screens/widgets/subcategory_tile_widget.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/widgets/header-widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  Categorys? _selectedCategory;

  @override 
  void initState(){
    super.initState();

    //load categories initially 
   _fetchCategories();
  }
  
  Future<void> _fetchCategories()async{
    final categories = await CategoryController().loadCategories();
    ref.read(categoryProvider.notifier).setCategories(categories);

    //set the default selected category (e.g) "Fashion"
    for(var category in categories){
      if(category.name=="Fashion"){
        setState(() {
          _selectedCategory = category;
        });

        //load subcategories fr the defualt category
        _fetchSubcategories(category.name);
      }
    }
  }

  Future<void> _fetchSubcategories(String categoryName)async{
    final subcategories  = await SubcategoryController().getSubCategoriesByCategoryName(categoryName);
    ref.read(subcategoryProvider.notifier).setSubcategoties(subcategories);

  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);
    final subcategories = ref.watch(subcategoryProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20),
       child: HeaderWidget(), 
       ),

       body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2, 
            child: Container(
              color: Colors.grey.shade200,
              child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: categories.length,
                      itemBuilder: (context, index){
                       final category = categories[index];
                       return ListTile(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                          _fetchSubcategories(category.name);
                          print(category.name);
                        },
                        title: Text(
                          category.name,
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _selectedCategory==category?Colors.blue: Colors.black, 
                          ),
                          )
                       );
                      }
                      )
            ),
            ),
            //Right Side - Display details 
            Expanded(
              flex: 5,
              child: _selectedCategory != null? 
              SingleChildScrollView (
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_selectedCategory!.name, 
                      style: GoogleFonts.quicksand(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.7
                        )
                      ),
                    ), 
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(_selectedCategory!.banner), 
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                    ),
                    subcategories.isNotEmpty ?
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: subcategories.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, 
                        mainAxisSpacing: 4, 
                        crossAxisSpacing: 8, 
                        childAspectRatio: 2/3
                       ), 
                      itemBuilder: (context, index){
                        final subcategory = subcategories[index];
                
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return SubcategoryProductScreen(subcategory: subcategory); 
                            }));
                          },
                          child: SubcategoryTileWidget(
                            image: subcategory.image, 
                            title: subcategory.subCategoryName
                          ));
                      }
                    ): 
                    Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Center(
                        child: Text(
                          'No Sub categories',
                          style: GoogleFonts.quicksand(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold, 
                            letterSpacing: 1.7
                          ),
                        ),
                       ),
                    )
                  ],
                ),
              )
              : Container(

              )
           ), 
        ],
       )
    );
  }
}