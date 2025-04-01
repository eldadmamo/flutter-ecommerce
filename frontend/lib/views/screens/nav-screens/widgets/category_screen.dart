import 'package:ecommerceflutter/controllers/category_controller.dart';
import 'package:ecommerceflutter/controllers/subcategory_controller.dart';
import 'package:ecommerceflutter/models/category.dart';
import 'package:ecommerceflutter/models/subcategory.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/widgets/header-widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<Categorys>> futureCategories;
  Categorys ? _selectedCategory;
  List<Subcategory> _subcategories = [];
  final SubcategoryController _subcategoryController = SubcategoryController();
  @override
  void initState(){
    super.initState();
    futureCategories = CategoryController().loadCategories();
    //categories are loaded process then 
    futureCategories.then((categories) {
      // iterate through the categories to find the "Fashion" category
      for(var category in categories){
        if (category.name == "Fashion"){
          setState(() {
            _selectedCategory = category;
          });
          _loadSubcategories(category.name);
        }
      }
    });
  }

// load subcategories based on the categoryNames
  Future<void> _loadSubcategories(String categoryName) async{
    final subcategories =  await _subcategoryController.getSubCategoriesByCategoryName(categoryName);
    setState(() {
      _subcategories = subcategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20),
       child: HeaderWidget(), 
       ),

       body: Row(
        children: [
          Expanded(
            flex: 2, 
            child: Container(
              color: Colors.grey.shade200,
              child: FutureBuilder(
                future: futureCategories, 
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if(snapshot.hasError) {
                    return Center(child: Text('Error : ${snapshot.error}'),
                    );
                  } else {
                    final categories = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: categories.length,
                      itemBuilder: (context, index){
                       final category = categories[index];
                       return ListTile(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                          _loadSubcategories(category.name);
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
                      );
                  }
                }
              ),
            ),
            ),
            //Right Side - Display details 
            Expanded(
              flex: 5,
              child: _selectedCategory != null? 
              Column(
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
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: _subcategories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, 
                      mainAxisSpacing: 4, 
                      crossAxisSpacing: 8, 
                     ), 
                    itemBuilder: (context, index){
                      final subcategory = _subcategories[index];

                      return Column(
                        children: [
                          Container(
                            width: 50, 
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200
                            ),
                            child: Center(
                              child: Image.network(
                                subcategory.image,
                                fit: BoxFit.cover,
                              ),
                            ),

                          ),
                          Center(
                            child: Text(subcategory.subCategoryName),
                          )
                        ],
                      );
                    }
                  )
                ],
              )
              : Container(

              )
           ), 
        ],
       )
    );
  }
}