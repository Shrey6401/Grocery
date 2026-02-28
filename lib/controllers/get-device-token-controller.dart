import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:grocery/utils/app-constant.dart';

class Getdevicetokencontroller extends GetxController{
  String? deviceToken;

  @override
  void onInit(){
    super.onInit();
    getDeviceToken();
  }
  Future<void> getDeviceToken() async {

    try{
      String? token=await FirebaseMessaging.instance.getToken();
      if(token != null){
        deviceToken=token;
        update();
      }
    }catch(e){
      Get.snackbar("Error", "$e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Appconstant.appSecondaryColor,
          colorText: Appconstant.appTextColor);
    }

  }


}