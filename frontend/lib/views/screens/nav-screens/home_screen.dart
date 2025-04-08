

import 'package:ecommerceflutter/views/screens/nav-screens/widgets/banner_widget.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/widgets/category_item_widget.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/widgets/header-widget.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/widgets/popular_product_widget.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/widgets/reusable_text_widget.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/widgets/top_rated_product_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(),
            BannerWidget(),
            CategoryItemWidget(),
            ReusableTextWidget(title: 'Top rated Product', subtitle: 'View All'),
            TopRatedProductWidget(), 
            ReusableTextWidget(title: 'Popular Products', subtitle: 'View All'),
            PopularProductWidget()
          ],
        ),
      ),
    );
  }
}