import 'package:ecommerceflutter/controllers/auth_controller.dart';
import 'package:ecommerceflutter/provider/user_provider.dart';
import 'package:ecommerceflutter/views/screens/authentication_screens/login_screen.dart';
import 'package:ecommerceflutter/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  
  await dotenv.load(); // Load the .env file

  Stripe.publishableKey = dotenv.env['PUBLISHABLE_KEY']!;

  String uri = dotenv.env['API_URI'] ?? "http://default-value.com";
  
  await Stripe.instance.applySettings();
  runApp(
    const ProviderScope(
      child:  MyApp())
    );
  
}


/// The root widget, now a ConsumerStatefulWidget so we can safely use `ref` in initState.
class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    // Fetch and set user data
    await AuthController().getUserData(context, ref);
    if (!mounted) return; // guard against calling setState after dispose
    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Transparent status bar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    // While we’re loading user data, show a splash/loading screen
    if (!_initialized) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    // Once initialized, read the user from our provider
    final user = ref.watch(userProvider)!;
    final Widget homeScreen =
        user.token.isNotEmpty ?  MainScreen() : const LoginScreen();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E‑Commerce Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: homeScreen,
    );
  }
}



