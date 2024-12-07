import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordpress/colors.dart';
import 'package:wordpress/controllers/settings_controller.dart';
import 'package:wordpress/controllers/web_controller.dart';
import 'package:wordpress/helpers/helper_functions.dart';
import 'package:wordpress/helpers/shared_preferences_helper.dart';
import 'package:wordpress/screens/login.dart';

class AutoLoginPage extends StatelessWidget {
  final String email; // User email for login
  final String password; // User password for login
  final String? otherUrl;
  final bool firstTime;

  AutoLoginPage({
    super.key,
    required this.email,
    required this.password,
    this.otherUrl,
    this.firstTime = false,
  });

  final WebViewController webViewController =
      Get.put(WebViewController()); // Instantiate the controller

  final SettingsController settingsController = Get.find();

  Future<int> getCookiesCountForUrl(String url) async {
    final cookies = await CookieManager.instance().getCookies(url: WebUri(url));
    print("Cookies for $url: ${cookies.length}");
    return cookies.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(settingsController.headerTitle.value),
        backgroundColor:
            Color(int.parse('0xff${settingsController.headerBgColor.value}')),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(otherUrl ?? "https://joyuful.com/login/"),
            ),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              domStorageEnabled: true,
              useShouldOverrideUrlLoading: true,
            ),
            shouldOverrideUrlLoading:
                (controller, shouldOverrideUrlLoadingRequest) async {
              print(
                  'This is the URL: ${shouldOverrideUrlLoadingRequest.request.url}');
              if (shouldOverrideUrlLoadingRequest.request.url
                  .toString()
                  .contains('https://joyuful.com/wp-login.php?action=logout')) {
                await SharedPreferencesHelper.clearAll();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                  (route) => false,
                );

                // Navigator.pop
                Get.snackbar('Logged Out', 'You have been logged out');
              }
              if (firstTime) {
                if (shouldOverrideUrlLoadingRequest.request.url
                    .toString()
                    .contains("https://joyuful.com/entry/")) {
                  Navigator.pop(context);
                }
              }
              return NavigationActionPolicy.ALLOW;
            },
            onWebViewCreated: (controller) {
              // Handle WebView controller creation if needed
            },
            onLoadStop: (controller, url) async {
              print("Page loaded: $url");

              if (url.toString().contains("wp-login.php") ||
                  url.toString().contains("https://joyuful.com/login/")) {
                await controller.evaluateJavascript(source: """
  (function() {
    // Check if the username field exists
    var usernameField = document.getElementById('user_login0');
    if (usernameField) {
      usernameField.value = '$email'; // Set email
    }

    // Check if the password field exists
    var passwordField = document.getElementById('user_pass0');
    if (passwordField) {
      passwordField.value = '$password'; // Set password
    }

    // Check if the submit button exists and click it
    var submitButton = document.getElementById('wp-submit0');
    if (submitButton) {
      submitButton.click(); // Click the login button
    }
  })();
""");
                Future.delayed(Duration(seconds: 5), () {
                  Navigator.pop(context);
                });
              } else {
                // If the next page has loaded, hide the loader
                webViewController.setLoading(false);
              }
            },
            onProgressChanged: (controller, progress) {
              if (webViewController.firstTime.value == false) {
                webViewController.firstTime.value = true;
                if (progress < 100) {
                  webViewController.setLoading(true);
                } else {
                  webViewController.setLoading(false);
                }
              } else {}
            },
          ),
          if (firstTime)
            SizedBox.expand(
              child: Container(
                color: ColorPalette.whiteColor,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: ColorPalette.primaryColor,
                  ),
                ),
              ),
            ),
          // Obx(() {
          //   // Observe loading state
          //   if (webViewController.isLoading.value) {
          //     return const Center(
          //       child: CircularProgressIndicator(), // Show loader when loading
          //     );
          //   } else {
          //     return const SizedBox.shrink(); // Hide loader when not loading
          //   }
          // }),
        ],
      ),
    );
  }

  Future<int?> countCookies(Uri? url) async {
    if (url != null) {
      final cookies = await CookieManager.instance()
          .getCookies(url: WebUri(url.toString()));
      print("Number of cookies for ${url.toString()}: ${cookies.length}");
      for (var cookie in cookies) {
        print("Cookie: ${cookie.name} = ${cookie.value}");
      }
      return cookies.length;
    }
    return null;
  }
}
