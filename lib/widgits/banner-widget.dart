import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/controllers/banner-controller.dart';
//import 'banner_controller.dart';

class BannerWidget extends StatelessWidget {
  BannerWidget({super.key});

  final BannerController bannerController =
  Get.put(BannerController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {

      if (bannerController.bannerUrls.isEmpty) {
        return const SizedBox();
      }

      return CarouselSlider(
        items: bannerController.bannerUrls.map((imagePath) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: Get.width,
            ),
          );
        }).toList(),
        options: CarouselOptions(
          height: 200,
          autoPlay: true,
          viewportFraction: 1,
        ),
      );
    });
  }
}