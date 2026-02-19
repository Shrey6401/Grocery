import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery/models/user-model.dart';
import 'package:grocery/screens/userpanel/main-screen.dart';

class GoogleSignInController extends GetxController {

  // 🔹 Google Sign-In instance
  final GoogleSignIn googleSignIn = GoogleSignIn();


  // 🔹 Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Sign-In Method
  Future<void> signInWithGoogle() async {
    try {

      final GoogleSignInAccount? googleUser =
      await googleSignIn.signIn();

      if (googleUser != null) {

        EasyLoading.show(status: "Please wait...");
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
        final AuthCredential credential =
        GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential =
        await _auth.signInWithCredential(credential);

        final User? user = userCredential.user;
        if (user != null) {
          UserModel userModel = UserModel(
            uId: user.uid,
            username: user.displayName ?? '',
            email: user.email ?? '',
            phone: user.phoneNumber ?? '',
            userImg: user.photoURL ?? '',
            userDeviceToken: '',
            country: '',
            userAddress: '',
            street: '',
            isAdmin: false,
            isActive: true,
            createdOn: DateTime.now(),
            city: '',
          );

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(userModel.toMap());
          EasyLoading.dismiss();
          Get.offAll(() => const mainscreen());

          print("Google Sign-In Successful");
        }
      }

    } catch (e) {
      EasyLoading.dismiss();
      print("Google Sign-In Error: $e");
    }
  }
}
