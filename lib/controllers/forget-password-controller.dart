import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:grocery/utils/app-constant.dart';

class ForgetPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> forgetPasswordMethod(String userEmail) async {
    try {
      EasyLoading.show(status: "Please wait");

      await _auth.sendPasswordResetEmail(email: userEmail);

      EasyLoading.dismiss();

      Get.snackbar(
        "Request Sent",
        "Password reset link sent to $userEmail",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Appconstant.appSecondaryColor,
        colorText: Appconstant.appTextColor,
      );

    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();

      Get.snackbar(
        "Error",
        e.message ?? "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Appconstant.appSecondaryColor,
        colorText: Appconstant.appTextColor,
      );
    }
  }
}