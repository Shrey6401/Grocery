import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:grocery/controllers/get-device-token-controller.dart';
import 'package:grocery/models/user-model.dart';
import 'package:grocery/models/user-model.dart';
import 'package:grocery/utils/app-constant.dart';

class SignupController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isPasswordVisible = false.obs;

  Future<UserCredential?> signUpMethod(
    String userName,
    String userEmail,
    String userPhone,
    String userCity,
    String userPassword,
    String userDeviceToken,
  ) async {
    final Getdevicetokencontroller getdevicetokencontroller = Get.put(Getdevicetokencontroller());

    try {
      EasyLoading.show(status: "Please wait...");
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: userEmail,
            password: userPassword,
          );
      userCredential.user!.sendEmailVerification();

      UserModel userModel = UserModel(
        uId: userCredential.user!.uid,
        username: userName,
        email: userEmail,
        phone: userPhone,
        userImg: '',
        userDeviceToken: getdevicetokencontroller.deviceToken.toString(),
        country: '',
        userAddress: '',
        street: '',
        isAdmin: false,
        isActive: true,
        createdOn: DateTime.now(),
        city: userCity,
      );
      _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());
      EasyLoading.dismiss();
      return userCredential;

    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "error",
        "$e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Appconstant.appSecondaryColor,
        colorText: Appconstant.appTextColor,
      );
    }
  }
}
