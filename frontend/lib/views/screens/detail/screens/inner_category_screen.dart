import 'package:ecommerceflutter/controllers/subcategory_controller.dart';
import 'package:ecommerceflutter/models/category.dart';
import 'package:ecommerceflutter/models/subcategory.dart';
import 'package:ecommerceflutter/views/screens/detail/screens/widgets/inner_banner-widget.dart';
import 'package:ecommerceflutter/views/screens/detail/screens/widgets/inner_category_content_widget.dart';
import 'package:ecommerceflutter/views/screens/detail/screens/widgets/inner_header_widget.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/account_screen.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/cart_screen.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/favorite_screen.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/store_screen.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/category_screen.dart';
import 'package:flutter/material.dart';


class InnerCategoryScreen extends StatefulWidget {
  
  final Categorys category;

  const InnerCategoryScreen({super.key, required this.category});
  
  @override
  State<InnerCategoryScreen> createState() => _InnerCategoryScreenState();
}

class _InnerCategoryScreenState extends State<InnerCategoryScreen> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    
   final List<Widget> pages = [
    InnerCategoryContentWidget(category: widget.category),
    const FavoriteScreen(),
    const CategoryScreen(),
    const StoreScreen(),
    const CartScreen(),
     AccountScreen()
  ];
  
    return Scaffold(
      
      bottomNavigationBar: 
       BottomNavigationBar(
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: pageIndex,
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
        BottomNavigationBarItem(icon: Image.asset("assets/icons/home.png", width: 25), label: "Home"),
        BottomNavigationBarItem(icon: Image.asset("assets/icons/love.png", width: 25), label: "Favorite"),
        const BottomNavigationBarItem(icon: Icon(Icons.category) , label: "Categories"),
        BottomNavigationBarItem(icon: Image.asset("assets/icons/mart.png", width: 25), label: "Stories"),
        BottomNavigationBarItem(icon: Image.asset("assets/icons/cart.png", width: 25), label: "Cart"),
        BottomNavigationBarItem(icon: Image.asset("assets/icons/user.png", width: 25), label: "Account"), 
      ]),
      body: pages[pageIndex]
    );
  }
}