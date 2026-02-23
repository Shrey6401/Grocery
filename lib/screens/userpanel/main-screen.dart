import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery/screens/auth-ui/welcome.dart';
import 'package:grocery/utils/app-constant.dart';
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
          GestureDetector(
            onTap:(){
              GoogleSignIn googleSignIn = GoogleSignIn();
              FirebaseAuth auth = FirebaseAuth.instance;
              auth.signOut();
              googleSignIn.signOut();
              Get.offAll(() =>  welcome_screen());

            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.logout,color: Colors.white,),
            ),
          )
        ],

      ),



    );
  }
}
