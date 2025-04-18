import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor/controllers/vendor_auth_controller.dart';
import 'package:vendor/provider/vendor_provider.dart';
import 'package:vendor/services/manage_http_response.dart';
import 'package:vendor/views/screens/nav_screens/orders_screen.dart';

class VendorProfileScreen extends ConsumerStatefulWidget {
 const VendorProfileScreen({Key?key}): super(key: key);

  @override
  ConsumerState<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends ConsumerState<VendorProfileScreen> {
  final VendorAuthController _vendorAuthController = VendorAuthController();
  final ImagePicker picker = ImagePicker();

  //Define a valueNotifier to manage 

  final ValueNotifier<XFile?> imageNotifier = ValueNotifier<XFile?>(null);

  //function to pick an image
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile!=null){
      imageNotifier.value = pickedFile;
    } else {
      showSnackBar(context, 'No image Picked'); 
    }
  }

  void showEditProfileDialog(BuildContext context){
    final user = ref.read(vendorProvider);
    final TextEditingController storeDescriptionController = TextEditingController();

    storeDescriptionController.text = user?.storeDescription ?? "";
    showDialog(
      context: context, 
      builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), 

        ),
        title: Text("Edit Profile", 
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold
        ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //display and update image 
             ValueListenableBuilder(
              valueListenable: imageNotifier,
                builder: (context, xFile, child) {
                  return FutureBuilder<Uint8List?>(
                    future: xFile?.readAsBytes(),
                    builder: (context, snapshot) {
                      return InkWell(
                        onTap: pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: snapshot.hasData
                              ? MemoryImage(snapshot.data!)
                              : const AssetImage('assets/default_profile.png') as ImageProvider,
                          child: xFile == null
                              ? const Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Icon(CupertinoIcons.photo, size: 24),
                              )
                              : null,
                        ),
                      );
                    }
                  );
              }
            ), 
            const SizedBox(height: 10,), 
            TextFormField(
              controller: storeDescriptionController,
              maxLines: 3, 
              decoration: InputDecoration(
                labelText: 'Store Description',
                border: OutlineInputBorder()
              ),
            ), 
            const SizedBox(height: 10,) 
          ],
        ),
        actions: [
          TextButton(
           onPressed: (){
            Navigator.of(context).pop();
           },
           child:  Text('Cancel', 
           style: GoogleFonts.montserrat(
            fontSize: 16, 
            fontWeight: FontWeight.bold
           ),
           ),
           ), 
           ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey, 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              )
            ),
            onPressed: ()async{
              await _vendorAuthController.updateVendorData(
                context: context, 
                id: ref.read(vendorProvider)!.id, 
                ref: ref,  
                storeImage: imageNotifier.value, 
                storeDescription: storeDescriptionController.text
              );
              Navigator.of(context).pop();
            }, 
            child: Text('Save', 
            style: GoogleFonts.montserrat( 
              fontWeight: FontWeight.bold,
              fontSize: 16, 
              color: Colors.white
            ),
            )
          )
        ],
      );
    });
  }
  //show signout dialog
  void showSignOutDialog(BuildContext context){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        title: Text('Are you sure?', 
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold, 
          fontSize: 20
         ),
        ),
        content: Text('Do you really want to log out?', 
        style: GoogleFonts.montserrat(
          fontSize: 16, 
          color: Colors.grey.shade700
        ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, 
          child: Text('Cancel' ,
          style: GoogleFonts.montserrat( 
            fontSize: 16, 
            color: Colors.grey
          ),
          )
          ), 
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent, 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              )
            ),
            onPressed: ()async{
              _vendorAuthController.signoutUser(
                context: context, 
                ref: ref
              );
            }, 
            child: Text("Logout", 
            style: GoogleFonts.montserrat(
              fontSize: 16, 
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
            )
          )
        ],
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    // Read the user first
    final user = ref.read(vendorProvider);
    // // Check if user is null immediately
    // if (user == null) {
    //   return const Scaffold(
    //     body: Center(child: CircularProgressIndicator()),
    //   );
    // }
    // // Now safely access user.id
    // final buyerId = user.id;
    
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 450, 
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.network("https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/FBrbGWQJqIbpA5ZHEpajYAEh1V93%2Fuploads%2Fimages%2F78dbff80_1dfe_1db2_8fe9_13f5839e17c1_bg2.png?alt=media", 
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover, 
                    ),
                  ),
                  Positioned(
                    top: 30, 
                    right: 30, 
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        "assets/icons/not.png", 
                      width: 30, 
                      height: 30, 
                      ),
                    ),
                  ), 
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment(0, -0.53),
                        child: CircleAvatar(
                          radius: 65, 
                          backgroundImage:  
                          user!.storeImage!=''
                          ? NetworkImage(user.storeImage!)
                          :
                          NetworkImage(
                            'https://cdn.pixabay.com/photo/2014/04/03/10/32/businessman-310819_1280.png'),
                        ),
                      ),
                      Align(
                        alignment:const Alignment(0.23, -0.61),
                        child: InkWell(
                          onTap: (){
                            showEditProfileDialog(context);
                          },
                          child: Image.asset(
                            'assets/icons/edit.png' ,
                            width: 19, 
                            height: 19, 
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ), 
                  Align(
                    alignment: const Alignment(0, 0.03),
                    child: user.fullName!=""? Text(
                      user.fullName, 
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 22, 
                      fontWeight: FontWeight.bold
                    ),
                    ): Text(
                      'User', 
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 22, 
                      fontWeight: FontWeight.bold
                    ),
                    )
                  ), 
                  Align(
                    alignment: const Alignment(0.05, 0.17),
                    child: InkWell(
                      onTap: (){
                        // Navigator.push(context, MaterialPageRoute(builder: (context){
                        //   return const ShippingAddressScreen();
                        // }));
                      }, 
                      child: user.state !="" ? Text(
                        user.state, 
                        style: GoogleFonts.montserrat(
                          color: Colors.white, 
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.7 
                        ),
                      ): Text(
                        'States', 
                        style: GoogleFonts.montserrat(
                          color: Colors.white, 
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.7 
                        ),
                      )                   
                    ),
                  ), 
                  
                ],
              ), 
            ),
            
            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return const OrderScreen();
                }));
              },
              leading: Image.asset(
                'assets/icons/orders.png',
              ),
              title: Text(
              'Track your order', 
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
            const SizedBox(height: 10,), 
            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return const OrderScreen();
                }));
              },
              leading: Image.asset(
                'assets/icons/history.png',
              ),
              title: Text(
              'History', 
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
            
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: ()async{
                showSignOutDialog(context);
              },
              leading: Image.asset(
                'assets/icons/logout.png',
              ),
              title: Text(
              'Logout', 
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
               ),
              ),
            ),
            const SizedBox(height: 10,),
            ListTile(
              onTap: ()async{
               
              },
              leading: Image.asset(
                'assets/icons/help.png',
              ),
              title: Text(
              'Delete Account', 
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
               ),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}