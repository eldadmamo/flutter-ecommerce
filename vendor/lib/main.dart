import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor/controllers/vendor_auth_controller.dart';
import 'package:vendor/provider/vendor_provider.dart';
import 'package:vendor/views/screens/authentication/login_screen.dart';
import 'package:vendor/views/screens/main_vendor_screen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  await dotenv.load(); // Load the .env file

  String uri = dotenv.env['API_URI'] ?? "http://default-value.com";
  String cloud = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? "http://default-value.com";

  String upload = dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? "http://default-value.com";

  runApp(const ProviderScope(child:  MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> checkTokenAndSetUser(WidgetRef ref,context) async {
      await VendorAuthController().getUserData(context,ref);

      ref.watch(vendorProvider);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FutureBuilder(future: checkTokenAndSetUser(ref,context), 
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        } 
        final vendor = ref.watch(vendorProvider);
        return vendor!.token.isNotEmpty
        ? const MainVendorScreen()
        : const LoginScreen();
      })
    );
  }
}



