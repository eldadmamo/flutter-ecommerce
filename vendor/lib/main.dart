import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> checkTokenAndSetUser(WidgetRef ref)async{
      // Obtain an instance of SharedPreferences
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // retrive the authentication token and user data stored locally
    String? token = preferences.getString('auth_token');
    String? vendorJson = preferences.getString('vendor');

    // if both the token and data are available update the vendor state
    if(token!=null && vendorJson!=null){
      ref.read(vendorProvider.notifier).setVendor(vendorJson);
    } else {
      ref.read(vendorProvider.notifier).signOut();
    }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FutureBuilder(future: checkTokenAndSetUser(ref), 
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        } 
        final vendor = ref.watch(vendorProvider);
        return vendor!=null? const MainVendorScreen(): const LoginScreen();
      })
    );
  }
}



