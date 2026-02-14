import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/screens/auth-ui/welcome.dart';
import 'package:grocery/screens/userpanel/main-screen.dart';
import 'package:grocery/utils/app-constant.dart';
import 'package:lottie/lottie.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 6), () {
      Get.offAll(()=>welcome_screen());
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appconstant.appSecondaryColor,
      appBar: AppBar(
        backgroundColor: Appconstant.appSecondaryColor,
        title: Text(Appconstant.appmainname,style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: Get.width,
              alignment: Alignment.center,
              child: Lottie.asset('assets/images/splash-icon.json'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            width: Get.width,
            alignment: Alignment.center,
            child: Text(Appconstant.apppoweredby,style: TextStyle(color: Appconstant.appTextColor,fontSize: 20),),
          ),
        ],
      ),
    );
  }
}
