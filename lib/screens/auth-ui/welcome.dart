import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:grocery/controllers/google_signin_controller.dart';
import 'package:grocery/screens/auth-ui/Sign_in.dart';
import 'package:grocery/utils/app-constant.dart';
import 'package:lottie/lottie.dart';

class welcome_screen extends StatefulWidget {
   welcome_screen({super.key});



  @override
  State<welcome_screen> createState() => _welcome_screenState();
}

class _welcome_screenState extends State<welcome_screen> {
  final GoogleSignInController _googleSignInController = Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appconstant.appmaincolor,
        title: const Text("Welcome to Grocery",style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          Container(child: Lottie.asset('assets/images/splash-icon.json')),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              "Welcome to Grocery",
              style: TextStyle(color: Appconstant.appmaincolor, fontSize: 20),
            ),
          ),
          SizedBox(height: Get.height / 12),
          Material(
            child: Container(
              width: Get.width/1.2,
              height: Get.height/12,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(12)
              ),
              child: TextButton.icon(
                icon: Image.asset('assets/images/final-google-logo.png',
                    width: 30, height: 30),
                onPressed: () {
                  _googleSignInController.signInWithGoogle();
                },
                label: Text("Sign with Google",style: TextStyle(color: Colors.white),),
              ),
            ),
          ),
          SizedBox(height: 25),
          Material(
            child: Container(
              width: Get.width/1.2,
              height: Get.height/12,
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(12)
              ),
              child: TextButton.icon(
                icon: Icon(Icons.mail,color: Colors.blue,size: 30,),
                onPressed: () {
                  Get.to(()=>SignIn());
                },
                label: Text("Sign with Email",style: TextStyle(color: Colors.white),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
