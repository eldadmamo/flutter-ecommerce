import 'package:ecommerceflutter/controllers/product_controller.dart';
import 'package:ecommerceflutter/models/product.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/widgets/product_item_widget.dart';
import 'package:flutter/material.dart';

class PopularProductWidget extends StatefulWidget {
  const PopularProductWidget({super.key});

  @override
  State<PopularProductWidget> createState() => _PopularProductWidgetState();
}

class _PopularProductWidgetState extends State<PopularProductWidget> {
  // A Future that will hold the list of popular products
  late Future<List<Product>> futurePopularProducts;
  
  @override
  void initState(){
    super.initState(); 
    futurePopularProducts = ProductController().loadPopularProducts();
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: futurePopularProducts, 
    builder: (context, snapshot){
      if (snapshot.connectionState == ConnectionState.waiting){
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError){
          return Center(child: Text('Error ${snapshot.error}'),);
        }
       else if(!snapshot.hasData || snapshot.data!.isEmpty){
        return Center(child: Text('No Popular Products'),
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
    });
  }
}