import 'package:ecommerceflutter/controllers/product_controller.dart';
import 'package:ecommerceflutter/models/vendor_model.dart';
import 'package:ecommerceflutter/provider/vendor_products_provider.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/widgets/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorProductsScreen extends ConsumerStatefulWidget {
  final Vendor vendor;

  const VendorProductsScreen({super.key, required this.vendor});
 

  @override
  ConsumerState<VendorProductsScreen> createState() => _VendorProductsScreenState();
}

class _VendorProductsScreenState extends ConsumerState<VendorProductsScreen> {
   bool isLoading = true;
  @override
  void initState(){
    super.initState(); 
    WidgetsBinding.instance.addPostFrameCallback((_){
      _fetchProductsIfNeeded();
    });
    
  }

  void _fetchProductsIfNeeded(){
    final products = ref.read(vendorProductsProvider);
    //check if product are empty or if the vendor has changed

    if(products.isEmpty || products.first.vendorId != widget.vendor.id){
      ref.read(vendorProductsProvider.notifier).setProducts([]);
      _fetchProduct(); 
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

   Future<void> _fetchProduct() async{
      final ProductController productController = ProductController();
      try{
        final products = await productController.loadVendorProducts(widget.vendor.id);
        ref.read(vendorProductsProvider.notifier).setProducts(products);
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
    final screenWidth = MediaQuery.of(context).size.width;

    //set the number of colume in grid based on the screen width
    //if the screen with is less than 600 pixels(e.g a phone), use columns 
    // if the screen is 600 pixels ore more (e.g a table) use 4 column
    final crossAxisCount = screenWidth < 600? 2: 4;

    // set the asepct ratio(width to hight ratio) of each grid item based on the screen width

    // for smaller screen(<600 pixels) use a ration of 3.4(taller items)

    //for larger screen(>=600 pixles), use a ration of 4.5(more )

  final childAspectRation = screenWidth < 600 ? 3  / 4: 4/5;

    final products = ref.watch(vendorProductsProvider);
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(
        MediaQuery.of(context).size.height * 0.20), 
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 118, 
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/icons/cartb.png'
          ), 
          fit: BoxFit.cover
          )
        ),
        child: Stack(
          children: [
            Positioned(
              left: 322, 
              top: 52, 
              child: Stack(
                children: [
                  Image.asset('assets/icons/not.png', 
                  width: 25,
                  height: 25,
                  ),
                  Positioned(
                    top: 0, 
                    right: 0, 
                    child: Container(
                      width: 20, 
                      height: 20, 
                      padding: const EdgeInsets.all(4), 
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade800,
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Center(
                        child: Text(
                          products.length.toString() ,
                          style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11
                        ),),
                      ),
                    )
                  )
                ],
              )
            ),
            Positioned(
              left: 61,
              top: 51,
              child: Text(
              widget.vendor.fullName.toUpperCase(), 
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.w600 ,
                color: Colors.white
              ),)
              )
          ],
        ),
      )
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20), 
               widget.vendor.storeImage!.isEmpty? CircleAvatar(
                radius: 50, 
                child: Text(
                widget.vendor.fullName[0].toUpperCase(), 
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold, 
                  fontSize: 30
                ),
                ),
                
              ): CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.vendor.storeImage!),
              ),
              
              const SizedBox(height: 10,), 
              widget.vendor.storeDescription!.isEmpty? 
              const Text(''): 
              Text(widget.vendor.storeDescription!, 
              style: GoogleFonts.montserrat( 
                letterSpacing: 1.7, 
                color: Colors.grey
              ),
              ),
              SizedBox(height: 10), 
              Divider(
                thickness: 1,
                color:Colors.grey
              ), 
                isLoading
                ? const Center(
                  child: CircularProgressIndicator(),
                ): 
                products.isEmpty ? Text(
                  "no Product Found", 
                  style: GoogleFonts.montserrat(),
                  ):  Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRation,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ), 
          itemBuilder: (context, index){
            final product = products[index];
            return ProductItemWidget(product: product); 
          }
        ),
      )
            ],
          ),
        ),
      ),
    );
  }
}