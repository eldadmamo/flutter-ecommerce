import 'package:ecommerceflutter/controllers/vendor_controller.dart';
import 'package:ecommerceflutter/provider/vendor_provider.dart';
import 'package:ecommerceflutter/views/screens/detail/screens/vendor_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({super.key});

  @override
  ConsumerState<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen> {
  @override 
  void initState() {
    super.initState();
    _fetchVendors();
  }

  Future<void> _fetchVendors()async{
    final VendorController vendorController = VendorController();
    try{
      final vendors = await vendorController.loadVendors();
      ref.read(vendorProvider.notifier).setVendors(vendors);
    } catch(e){
      print('$e');
    }
  }
  @override
  Widget build(BuildContext context) {
    final vendors = ref.watch(vendorProvider);
     final screenWidth = MediaQuery.of(context).size.width;

    //set the number of colume in grid based on the screen width
    //if the screen with is less than 600 pixels(e.g a phone), use columns 
    // if the screen is 600 pixels ore more (e.g a table) use 4 column
    final crossAxisCount = screenWidth < 600? 2: 4;

    // set the asepct ratio(width to hight ratio) of each grid item based on the screen width

    // for smaller screen(<600 pixels) use a ration of 3.4(taller items)

    //for larger screen(>=600 pixles), use a ration of 4.5(more )

  final childAspectRation = screenWidth < 600 ? 3  / 4: 4/5;

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
                          vendors.length.toString(),
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
              'Stores', 
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w600 ,
                color: Colors.white
              ),)
              )
          ],
        ),
      )
      ),
      body: GridView.builder(
          itemCount: vendors.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRation,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ), 
          itemBuilder: (context, index){
            final vendor = vendors[index];
            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return VendorProductsScreen(vendor: vendor);
                }));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                   vendor.storeImage!.isEmpty ?  CircleAvatar(
                    radius: 50, 
                    child: Text(vendor.fullName[0].toUpperCase(), 
                    style: GoogleFonts.montserrat(
                      fontSize: 30, 
                      fontWeight: FontWeight.bold, 
                
                    ),
                    ),
                  ): CircleAvatar(
                    radius: 50, 
                    backgroundImage: NetworkImage(vendor.storeImage!),
                  ),
                  Text(vendor.fullName, 
                  style: GoogleFonts.lato( 
                    fontWeight: FontWeight.bold, 
                    letterSpacing: 1.7 
                  ),
                  )
                  ],
                ),
              ),
            );
          }
        ),
    );
  }
}