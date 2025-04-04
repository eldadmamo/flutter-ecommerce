import 'package:ecommerceflutter/controllers/auth_controller.dart';
import 'package:ecommerceflutter/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ShippingAddressScreen extends ConsumerStatefulWidget {
  const ShippingAddressScreen({super.key});
  @override
  _ShippingAddressScreenState createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends ConsumerState<ShippingAddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); 
  final AuthController _authController = AuthController();
  late String state;
  late String city;
  late String locality;

  //show Loading Dialog
  _showLoadingDialog(){
    showDialog(
      context: context, 
      builder: (context){
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        child: Padding(padding: EdgeInsets.all(15), 
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20,), 
            Text('Updating...', style: GoogleFonts.montserrat(
              fontSize: 18, 
              fontWeight: FontWeight.bold
            ),) 
          ],
          ),
        ),
        
      );
    });
  }

   @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final updateUser = ref.read(userProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.96), 
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.96),
        elevation: 0, 
        title: Text(
          'Delivery',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            letterSpacing: 1.7
          ),
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                Text(
                  'where will your order\n be shipped', 
                  style:GoogleFonts.montserrat(
                    fontSize: 18,
                    letterSpacing: 1.7,
                    fontWeight: FontWeight.w600 
                  ), 
                ), 
                TextFormField(
                  onChanged: (value){
                    state = value;
                  },
                  validator: (value){
                    if(value!.isEmpty){
                      return "please enter state";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'State', 
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  onChanged: (value){
                    city = value;
                  },
                  validator: (value){
                    if(value!.isEmpty){
                      return "please enter city";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'City', 
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  onChanged: (value){
                    locality = value;
                  },
                  validator: (value){
                    if(value!.isEmpty){
                      return "please enter locality";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Locality', 
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: ()async{
            if(_formKey.currentState!.validate()){
              _showLoadingDialog();
              
              await _authController.updateUserLocation(
                context: context, 
                id: user!.id, 
                state: state, 
                city: city, 
                locality: locality
               ).whenComplete((){
                updateUser.recreateUserState(state: state, city: city, locality: locality);
                Navigator.pop(context);
                Navigator.pop(context);
               });
            } else {
              print('not valid');
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50, 
            decoration: BoxDecoration(
              color: const Color(0xFF3854EE),
              borderRadius: BorderRadius.circular(10) 
            ),
          
            child: Center(
              child: Text('Save', style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 18, 
                fontWeight: FontWeight.bold
              ),),
            ),
          ),
        ),
      ),
    );
  }
}