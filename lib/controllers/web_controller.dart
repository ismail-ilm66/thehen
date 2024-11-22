import 'package:get/get.dart';

class WebViewController extends GetxController {
  var isLoading = true.obs;
  RxBool firstTime = false.obs;

  void setLoading(bool value) {
    isLoading.value = value;
  }
}
