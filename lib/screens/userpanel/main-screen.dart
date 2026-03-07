import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery/screens/auth-ui/welcome.dart';
import 'package:grocery/screens/userpanel/all-categories-screen.dart';
import 'package:grocery/screens/userpanel/all-flash-sale-products.dart';
import 'package:grocery/screens/userpanel/all-product-screen.dart';
import 'package:grocery/screens/userpanel/cart%20screen.dart';
import 'package:grocery/utils/app-constant.dart';
import 'package:grocery/widgits/banner-widget.dart';
import 'package:grocery/widgits/category-widget.dart';
import 'package:grocery/widgits/custom-drawer-widget.dart';
import 'package:grocery/widgits/flash-sale-widget.dart';
import 'package:grocery/widgits/heading-widget.dart';
import 'package:grocery/widgits/product-widget.dart';
import 'package:lottie/lottie.dart';

class mainscreen extends StatefulWidget {
  const mainscreen({super.key});

  @override
  State<mainscreen> createState() => _mainscreenState();
}

class _mainscreenState extends State<mainscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appconstant.appmaincolor,
        title: Text(Appconstant.appmainname,style: TextStyle(color: Colors.white),),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton.filled(onPressed: (){
              Get.to(()=>CartScreen());
            }, icon: Icon(CupertinoIcons.cart,color: Colors.white,)),
          )
        ],
      ),
      drawer: DrawerWidget(),
      body: Column(
        children: [
          SizedBox(height: 10,),
          BannerWidget(),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Headingwidget(
                    headingTitle: "Categories",
                    headingSubTitle:"According to your budget",
                    buttonText: "See More >",
                    onTap: (){
                      Get.to(()=>AllCategoriesScreen());
                    },
                  ),
                  CategoriesWidget(),
                  Headingwidget(
                    headingTitle: "Flash",
                    headingSubTitle:"According to your budget",
                    buttonText: "See More >",
                    onTap: ()=>Get.to(()=>AllFlashSaleProductScreen()),
                  ),
                  FlashSaleWidget(),
                  Headingwidget(
                    headingTitle: "All Products",
                    headingSubTitle:"According to your budget",
                    buttonText: "See More >",
                    onTap: ()=>Get.to(()=>AllProductScreen()),
                  ),
                  AllProductSaleScreen(),
                  SizedBox(height: Get.height/0.90),


                ],
              ),
            ),
          ),
        ],
      ),



    );
  }
}
