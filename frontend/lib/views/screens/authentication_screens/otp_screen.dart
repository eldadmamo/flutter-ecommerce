import 'package:ecommerceflutter/controllers/auth_controller.dart';
import 'package:ecommerceflutter/services/manage_http_response.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});
  

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  bool isLoading = false;
  List<String> otpDigits = List.filled(6, '');

  void verifyOtp() async{
    // if(otpDigits.contains('')){
    //   showSnackBar(context, 'Please fill in all OTP Fields');
    //   return;
    // } 

    setState(() {
      isLoading = true;
    });

    final otp = otpDigits.join(); //combine all digits into a single OTP string

    await _authController.verifyOtp(
      context: context,
      email: widget.email, 
      otp: otp
    ).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Widget buildOtpField(int index){
    return SizedBox(
      width: 45,
      height: 55,
      child: TextFormField(
        validator: (value){
          if(value!.isEmpty){
            return '';
          } 
          return null;
        },
        onChanged: (value){
          // check if the input is valid (non-empty)
          if(value.isNotEmpty && value.length==1){
            //save the digit to the corresponding index
            
            otpDigits[index] = value;

            //automatically move focus to the next field if not the last one.

            if(index<otpDigits.length - 1){
              FocusScope.of(context).nextFocus();
            } else if (value.isEmpty) {
              //clear the value if the input is remove
              otpDigits[index] = '';
            }


          }
        },

        onFieldSubmitted: (value){
          // Trigger OTP Verification if on the last field and if the form is valid

          if(index == otpDigits.length - 1 && _formKey.currentState!.validate()){
                 verifyOtp();
          }

        },

        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8)
          ), 
          filled: true, 
          fillColor: Colors.grey.shade200,
          
        ),

        style: GoogleFonts.montserrat(
          fontSize: 18, 
          fontWeight: FontWeight.bold, 

        ),
      ), 
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [ 
                  Text('Verify your Account', 
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 23, 
                    color: Color(0XFF0d120E)
                  ),
                ),
              
                const SizedBox(height: 10,), 
                Text("Enter the OTP send to ${widget.email}" ,
                style: GoogleFonts.lato(
                  color:const Color(0xFF0D120E),
                  fontSize: 14
                ),
                ), 
                const SizedBox(height: 30,), 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, buildOtpField),
                ),
                SizedBox(height: 30,), 
                InkWell(
                  onTap: (){
                    verifyOtp();
                  },
                  child: Container(
                    width: 319, 
                    height: 50, 
                    decoration: BoxDecoration(
                      color: const Color(0xFF103DE5),
                      borderRadius: BorderRadius.circular(9)
                    ),
                    child: Center(
                      child: isLoading? CircularProgressIndicator(
                        color: Colors.white,
                      ): 
                      Text(
                      'Verify',
                      style: GoogleFonts.quicksand(
                        fontSize: 18, 
                        color: Colors.white, 
                        fontWeight: FontWeight.bold
                      ),
                      ),
                    ),
                  ),
                )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}