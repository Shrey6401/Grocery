import 'package:get/get.dart';

class BannerController extends GetxController {
  RxList<String> bannerUrls = <String>[].obs;

  @override
  void onInit() {
    super.onInit();

    bannerUrls.addAll([
      "assets/banner/10149587.jpg",
      "assets/banner/4739023.jpg",
      "assets/banner/6994532.jpg",
      "assets/banner/8486190.jpg",
    ]);
  }
}


