import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:grocery/firebase_options.dart';
import 'package:grocery/screens/auth-ui/Sign_in.dart';
import 'package:grocery/screens/auth-ui/Sign_up.dart';
import 'package:grocery/screens/auth-ui/splash-screen.dart';
import 'package:grocery/screens/auth-ui/welcome.dart';
import 'package:grocery/screens/userpanel/main-screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: welcome_screen(),
      builder: EasyLoading.init(),
    );
  }
}


