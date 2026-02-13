import 'package:flutter/material.dart';
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

      ),



    );
  }
}
