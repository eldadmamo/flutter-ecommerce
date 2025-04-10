import 'package:ecommerceflutter/provider/user_provider.dart';
import 'package:ecommerceflutter/views/screens/authentication_screens/login_screen.dart';
import 'package:ecommerceflutter/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  
  await dotenv.load(); // Load the .env file

  Stripe.publishableKey = dotenv.env['PUBLISHABLE_KEY']!;

  String uri = dotenv.env['API_URI'] ?? "http://default-value.com";
  
  await Stripe.instance.applySettings();
  runApp(ProviderScope(child: const MyApp()));
  
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  Future<void> checkTokenAndSetUser(WidgetRef ref) async  {
    //obtain an instance of sharedPreference for local data storage
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // Retrive the authentication token 
   String? token = preferences.getString('auth_token');
   String? userJson = preferences.getString('user');

   // if both token and user data are available
   if(token!=null && userJson!=null){
    ref.read(userProvider.notifier).setUser(userJson);
   } else {
    ref.read(userProvider.notifier).signOut();
   }
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true
      ),
      home: FutureBuilder(
        future: checkTokenAndSetUser(ref), 
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          } 
            final user = ref.watch(userProvider);

            return user!=null?MainScreen(): LoginScreen();
        }
      )
    );
  }
}
