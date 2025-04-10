import 'package:ecommerceflutter/controllers/product_controller.dart';
import 'package:ecommerceflutter/models/product.dart';
import 'package:ecommerceflutter/provider/cart_provider.dart';
import 'package:ecommerceflutter/provider/favorite_provider.dart';
import 'package:ecommerceflutter/provider/related_provider.dart';
import 'package:ecommerceflutter/services/manage_http_response.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/widgets/product_item_widget.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/widgets/reusable_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});
  

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
   @override
  void initState(){
    super.initState(); 
    _fetchProduct(); 
  }

   Future<void> _fetchProduct() async{
      final ProductController productController = ProductController();
      try{
        final products = await productController.loadRelatedProductsBySubcategory(widget.product.id);
        ref.read(relatedProductProvider.notifier).setProducts(products);
      }catch(e){
        print("$e");
      }
    }
  @override
  Widget build(BuildContext context) {
    final relatedProduct = ref.watch(relatedProductProvider);
    final cartProviderData = ref.read(cartProvider.notifier);
    final favoriteProviderData = ref.read(favoriteProvider.notifier);
    ref.watch(favoriteProvider);
    final cartData = ref.watch(cartProvider);
    final isInCart = cartData.containsKey(widget.product.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product.productName,
          style: GoogleFonts.quicksand(
          fontSize: 18,
          fontWeight: FontWeight.w600
        ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              favoriteProviderData.addProductToFavorite(
                productName: widget.product.productName, 
                productPrice: widget.product.productPrice,
                category: widget.product.category, 
                image: widget.product.images, 
                vendorId: widget.product.vendorId, 
                productQuantity: widget.product.quantity, 
                quantity: 1, 
                productId: widget.product.id, 
                description: widget.product.description, 
                fullName: widget.product.fullName
              );
              showSnackBar(context, "added ${widget.product.productName}");
            }, 
            icon: favoriteProviderData.getFavoriteItem.containsKey(widget.product.id)
            ? Icon(Icons.favorite,
            color: Colors.red,
            ) : const Icon(Icons.favorite_border)
          )
        ],
      ),
      body: SingleChildScrollView( 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 260,
                height: 275, 
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(), 
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      child: Container(
                        width: 260,
                        height: 260, 
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFD8DDFF
                            ),
                          borderRadius: BorderRadius.circular(130)
                        ),
                      )
                    ),
                    Positioned(
                      left: 22,
                      top: 0,
                      child: Container(
                        width: 216,
                        height: 274, 
                        clipBehavior: Clip.hardEdge, 
                        decoration:  BoxDecoration(
                          color: Color(0xFF9CABFF),
                          borderRadius: BorderRadius.circular(14)
                        ),
                        child: SizedBox(
                          height: 300,
                          child: PageView.builder(
                            itemCount: widget.product.images.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context,index){
                              return Image.network(
                                widget.product.images[index],
                                width: 198,
                                height: 225, 
                                fit: BoxFit.cover,
                               );
                            }
                          ),
                        )
                      ),
                    )
                  ],
                ), 
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                  Text(widget.product.productName, 
                  style: GoogleFonts.roboto(
                    fontSize: 17, 
                    fontWeight: FontWeight.bold, 
                    letterSpacing: 1,
                    color: Color(0XFF3C55EF) 
                  ),
                  ),
                  Text(
                    "\$${widget.product.productPrice}",
                    style: GoogleFonts.roboto(
                      fontSize: 17, 
                      fontWeight: FontWeight.bold,
                      color:  const Color(0XFF3C55EF)
                    ),
                    )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.product.category,
                style: GoogleFonts.roboto(
                  color: Colors.grey, 
                  fontSize: 16,
                  fontWeight: FontWeight.w700, 
                ),
              ),
            ),
            widget.product.totalRatings==0
            ? const Text('')
            :Padding(
              padding: EdgeInsets.only(left: 0),
              child: Row(
                children: [
                  const Icon(Icons.star , color: Colors.amber), 
                  Text(widget.product.averageRating.toString(), 
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  Text("(${widget.product.totalRatings})", 
                  )
                ],
              ),
              ), 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start ,
                children: [
                  Text("About", style: GoogleFonts.lato(
                    fontSize: 17,
                    letterSpacing: 1.7, 
                    color: const Color(0XFF363330, 
                    
                    ) 
                  ),
                  ),
                  Text(
                    widget.product.description,
                    style: GoogleFonts.lato(
                      letterSpacing: 2,
                      fontSize: 15
                    ),  
                  )
                ],
              ),
            ), 
            ReusableTextWidget(
              title: 'realted Products', 
              subtitle: ''
            ),
            SizedBox(
            height: 250,
        
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: relatedProduct.length,
              itemBuilder: (context, index){
                final product = relatedProduct[index];
                return ProductItemWidget(
                  product: product
                );
              }),
          ), 
          SizedBox(height: 60,),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.all(8), 
        child: InkWell(
          onTap: isInCart
          ? null
          : () {
            cartProviderData.addProductToCart(
              productName: widget.product.productName, 
              productPrice: widget.product.productPrice, 
              category: widget.product.category, 
              image: widget.product.images, 
              vendorId: widget.product.vendorId, 
              productQuantity: widget.product.quantity, 
              quantity: 1, 
              productId: widget.product.id,
              description: widget.product.description, 
              fullName: widget.product.fullName
            );
            showSnackBar(context, widget.product.productName);
          },
          child: Container(
            width: 386, 
            height: 46, 
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color:  isInCart? Colors.grey: const Color(0XFF3B54EE),
              borderRadius: BorderRadius.circular(15)
            ),
            child: Center(
              child: Text("Add To Cart", style: GoogleFonts.mochiyPopOne(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),),
            ),
          ),
        ),
      ),
    );
  }
}