import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor/controllers/product_controller.dart';
import 'package:vendor/provider/vendor_product_provider.dart';
import 'package:vendor/provider/vendor_provider.dart';
import 'package:vendor/views/screens/detail/screens/edit_product_detail_screen.dart';

class EditScreen extends ConsumerStatefulWidget {
  const EditScreen({super.key});

  @override
  ConsumerState<EditScreen> createState() => _EditScreenState();
}



class _EditScreenState extends ConsumerState<EditScreen> {
  // A Future that will hold the list of popular products
  bool isLoading = true;
  @override
  void initState(){
    super.initState(); 
    final products = ref.read(vendorProductProvider);
    if(products.isEmpty){
      _fetchProduct(); 
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

   Future<void> _fetchProduct() async{
      final vendor = ref.read(vendorProvider); 
      final ProductController productController = ProductController();
      try{
        final products = await productController.loadVendorsProducts(vendor!.id);
        ref.read(vendorProductProvider.notifier).setProducts(products);
      }catch(e){
        print("$e");
      } finally{
        setState(() {
          isLoading = false;
        });
      }
    }
  @override
  Widget build(BuildContext context) {
    final products = ref.watch(vendorProductProvider);
    return SizedBox(
          height: 250,

          child: isLoading ? 
          Center(
            child: CircularProgressIndicator(
              color: Colors.blue,)
            ):
          ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index){
              final product = products[index];
              return InkWell( 
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return EditProductDetailScreen(product: product);
                  }));
                },
                child: Center(
                  child: Text(product.productName),
                ),
              );
            }),
    );
  }
}