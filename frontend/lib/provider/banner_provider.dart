import 'package:ecommerceflutter/models/banner_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BannerProvider extends StateNotifier<List<BannerModel>>{
  BannerProvider(): super([]); 

  // 

  void setBanners(List<BannerModel> banners){
    state = banners;
  }
}

final bannerProvider = StateNotifierProvider<BannerProvider, List<BannerModel>>(
  (ref)  {
    return BannerProvider();
  }
);