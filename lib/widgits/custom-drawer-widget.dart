import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery/screens/auth-ui/welcome.dart';
import 'package:grocery/utils/app-constant.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Get.height / 25),
      child: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        backgroundColor: Appconstant.appSecondaryColor,
        child: Wrap(
          runSpacing: 10,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 20.0,
              ),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  "Shrey",
                  style: TextStyle(color: Appconstant.appTextColor),
                ),
                subtitle: Text(
                  "Version 1.0.1",
                  style: TextStyle(color: Appconstant.appTextColor),
                ),
                leading: CircleAvatar(
                  radius: 22.0,
                  backgroundColor: Appconstant.appmaincolor,
                  child: Text(
                    "S",
                    style: TextStyle(color: Appconstant.appTextColor),
                  ),
                ),
              ),
            ),
            Divider(
              indent: 10.0,
              endIndent: 10.0,
              thickness: 1.5,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  "Home",
                  style: TextStyle(color: Appconstant.appTextColor),
                ),
                leading: Icon(Icons.home, color: Appconstant.appTextColor),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: Appconstant.appTextColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  "Products",
                  style: TextStyle(color: Appconstant.appTextColor),
                ),
                leading: Icon(
                  Icons.production_quantity_limits,
                  color: Appconstant.appTextColor,
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: Appconstant.appTextColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  "Orders",
                  style: TextStyle(color: Appconstant.appTextColor),
                ),
                leading: Icon(
                  Icons.shopping_bag,
                  color: Appconstant.appTextColor,
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: Appconstant.appTextColor,
                ),
                onTap: () {
                  /*Get.back();
                  Get.to(() => AllOrdersScreen());*/
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  "Contact",
                  style: TextStyle(color: Appconstant.appTextColor),
                ),
                leading: Icon(Icons.help, color: Appconstant.appTextColor),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: Appconstant.appTextColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  "Logout",
                  style: TextStyle(color: Appconstant.appTextColor),
                ),
                leading: Icon(Icons.logout, color: Appconstant.appTextColor),
                trailing: GestureDetector(
                  onTap: (){
                    GoogleSignIn googleSignIn = GoogleSignIn();
                    FirebaseAuth auth = FirebaseAuth.instance;
                    auth.signOut();
                    googleSignIn.signOut();
                    Get.offAll(() =>  welcome_screen());
                  },
                  child: Icon(
                    Icons.arrow_forward,
                    color: Appconstant.appTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
