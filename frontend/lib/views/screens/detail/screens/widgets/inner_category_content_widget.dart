import 'package:ecommerceflutter/controllers/product_controller.dart';
import 'package:ecommerceflutter/controllers/subcategory_controller.dart';
import 'package:ecommerceflutter/models/category.dart';
import 'package:ecommerceflutter/models/product.dart';
import 'package:ecommerceflutter/models/subcategory.dart';
import 'package:ecommerceflutter/views/screens/detail/screens/subcategory_product_screen.dart';
import 'package:ecommerceflutter/views/screens/detail/screens/widgets/inner_banner-widget.dart';
import 'package:ecommerceflutter/views/screens/detail/screens/widgets/inner_header_widget.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/account_screen.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/cart_screen.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/favorite_screen.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/store_screen.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/category_screen.dart';
import 'package:ecommerceflutter/views/screens/detail/screens/widgets/subcategory_tile_widget.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/widgets/product_item_widget.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/widgets/reusable_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InnerCategoryContentWidget extends StatefulWidget {
  
  final Categorys category;

  const InnerCategoryContentWidget({super.key, required this.category});
  
  @override
  State<InnerCategoryContentWidget> createState() => _InnerCategoryContentWidgetState();
}

class _InnerCategoryContentWidgetState extends State<InnerCategoryContentWidget> {
  late Future<List<Subcategory>> _subcategories;
  late Future<List<Product>> futureProducts;
  final SubcategoryController _subcategoryController = SubcategoryController();

  @override
  void initState(){
    super.initState();
    _subcategories = _subcategoryController.getSubCategoriesByCategoryName(widget.category.name);
    futureProducts = ProductController().loadProductByCategory(widget.category.name);
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20), 
        child: const InnerHeaderWidget()
      ), 
      body: SingleChildScrollView(
        child: Column(
          children: [
            InnerBannerWidget(image: widget.category.banner),
            Center(
              child: Text("Shop By Subcategories", 
              style: GoogleFonts.quicksand(
                fontSize: 19, 
                fontWeight: FontWeight.bold,
                letterSpacing: 1.7
              ),
              ),
            ),
            FutureBuilder(
        future: _subcategories,
         builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator()
            );
          } else if (snapshot.hasError){
            return Center(
              child :Text('Error ${snapshot.error}')
            );
          } else if(!snapshot.hasData || snapshot.data!.isEmpty){
            return const Center(child: Text('No Categories'));
          } else {
          final subcategories = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: List.generate(
                (subcategories.length / 7).ceil(), 
              (setIndex){
                final start = setIndex * 7;
                final end = (setIndex + 1) * 7;

                return Padding(padding: EdgeInsets.all(8.9),
                child: Row(
                  children: subcategories
                  .sublist(start, 
                  end > subcategories.length 
                  ? subcategories.length: end
                  )
                  .map((subcategories) => 
                  GestureDetector(
                    onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return SubcategoryProductScreen(subcategory: subcategories); 
                            }));
                      },
                    child: SubcategoryTileWidget(
                      image:subcategories.image, 
                      title: subcategories.subCategoryName
                      ),
                  )
                  ).toList(),
                ),
                );
              }),
            ),
           );
          }
         }),

         ReusableTextWidget(
          title: "Popular Product", subtitle: "View All"),

          FutureBuilder(future: futureProducts, 
           builder: (context, snapshot){
      if (snapshot.connectionState == ConnectionState.waiting){
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError){
          return Center(child: Text('Error ${snapshot.error}'),);
        }
       else if(!snapshot.hasData || snapshot.data!.isEmpty){
        return Center(child: Text('No product under this category'),
        );
       } else {
        final products = snapshot.data;
        return SizedBox(
          height: 250,

          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products!.length,
            itemBuilder: (context, index){
              final product = products[index];
              return ProductItemWidget(product: product);
            }),
           );
          }
          }),
          ],
        ),
      ),
      
    );
  }
}