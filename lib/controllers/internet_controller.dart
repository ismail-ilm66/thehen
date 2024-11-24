import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordpress/helpers/no_internet_popup.dart';

class InternetController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    print("InternetController initialized");
    _checkInitialConnection();
    _connectivity.onConnectivityChanged.listen(NetStatus);
  }

  Future<void> _checkInitialConnection() async {
    print("Checking initial connection");

    List<ConnectivityResult> result = await _connectivity.checkConnectivity();
    print("Initial connection status: ${result.first}");
    NetStatus(result);
  }

  void NetStatus(List<ConnectivityResult> result) {
    print("Network status changed: $result");
    if (result.first == ConnectivityResult.none) {
      print("No internet connection - attempting to show snackbar");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print("Post frame callback - showing snackbar");
        Get.rawSnackbar(
          titleText: SizedBox(
              width: double.infinity,
              height: Get.size.height / 1.1,
              child: const Align(
                alignment: Alignment.bottomCenter,
                child: NoInternetConnection(),
              )),
          messageText: Container(),
          backgroundColor: Colors.transparent,
          isDismissible: false,
          duration: const Duration(days: 1),
        );
      });
    } else {
      if (Get.isSnackbarOpen) {
        print("Closing snackbar");
        Get.closeCurrentSnackbar();
      }
    }
  }
}
