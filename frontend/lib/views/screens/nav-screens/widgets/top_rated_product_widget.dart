import 'package:ecommerceflutter/controllers/product_controller.dart';
import 'package:ecommerceflutter/models/product.dart';
import 'package:ecommerceflutter/provider/product_provider.dart';
import 'package:ecommerceflutter/provider/top_rated_product_provider.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/widgets/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopRatedProductWidget extends ConsumerStatefulWidget {
  const TopRatedProductWidget({super.key});

  @override
  ConsumerState<TopRatedProductWidget> createState() => _TopRatedProductWidgetState();
}

class _TopRatedProductWidgetState extends ConsumerState<TopRatedProductWidget> {
  // A Future that will hold the list of popular products
  bool isLoading = true;
  @override
  void initState(){
    super.initState(); 
    final products = ref.read(productProvider);
    if(products.isEmpty){
      _fetchProduct(); 
    } else {
      setState(() {
        isLoading =false;
      });
    }
  }

   Future<void> _fetchProduct() async{
      final ProductController productController = ProductController();
      try{
        final products = await productController.loadTopRatedProduct();
        ref.read(topRatedProductProvider.notifier).setProducts(products);
      }catch(e){
        print("$e");
      } finally {
        setState(() {
          isLoading = false; 
        });
      }
    }
  
  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider);
    return SizedBox(
          height: 250,

          child: isLoading
          ? const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
          )
          )
          : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index){
              final product = products[index];
              return ProductItemWidget(product: product);
            }),
        );
  }
}