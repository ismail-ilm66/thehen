import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:wordpress/colors.dart';
import 'package:wordpress/controllers/settings_controller.dart';
import 'package:wordpress/controllers/web_controller.dart';
import 'package:wordpress/helpers/shared_preferences_helper.dart';
import 'package:wordpress/screens/login.dart';

class AutoLoginPage extends StatelessWidget {
  final String email;
  final String password;
  final String? otherUrl;
  final bool firstTime;
  final bool fromSignUp;

  AutoLoginPage({
    super.key,
    required this.email,
    required this.password,
    this.otherUrl,
    this.firstTime = false,
    this.fromSignUp = false,
  });

  final WebViewController webViewController =
      Get.put(WebViewController()); // Instantiate the controller

  final SettingsController settingsController = Get.find();
  late InAppWebViewController _webViewController;

  Future<void> clearWebViewSessionsAndCookies() async {
    try {
      // Clear all cookies
      final cookieManager = CookieManager.instance();
      await cookieManager.deleteAllCookies();
      print("All cookies have been cleared.");

      // Clear cache and session storage
      if (_webViewController != null) {
        await _webViewController.clearCache();
        print("WebView cache cleared.");

        // Clear session storage via JavaScript
        await _webViewController.evaluateJavascript(source: """
        window.localStorage.clear();
        window.sessionStorage.clear();
      """);
        print("LocalStorage and SessionStorage cleared.");
      } else {
        print("WebViewController is not initialized.");
      }
    } catch (e) {
      print("Error clearing sessions and cookies: $e");
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (settingsController.headerIcon.value.isEmpty)
              Image.asset(
                'assets/icon-menu.png',
                height: 35,
                width: 35,
              ),
            if (settingsController.headerIcon.value.isNotEmpty)
              Image.network(
                settingsController.headerIcon.value,
                height: 35,
                width: 35,
              ),

            const SizedBox(
              width: 10,
            ),

            // Text(settingsController.headerTitle.value),
            Text(settingsController.headerTitle.value),
          ],
        ),

        // title: Text(settingsController.headerTitle.value),
        backgroundColor:
            Color(int.parse('0xff${settingsController.headerBgColor.value}')),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(otherUrl ?? "https://thehen.io/access/"),
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
                      .contains('https://thehen.io/mfa?action=logout') ||
                  shouldOverrideUrlLoadingRequest.request.url
                      .toString()
                      .contains('action=logout')) {
                await SharedPreferencesHelper.clearAll();
                await clearWebViewSessionsAndCookies();
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
                // if (shouldOverrideUrlLoadingRequest.request.url
                //     .toString()
                //     .contains("https://joyuful.com/entry/")) {
                //   Navigator.pop(context);
                // }
              }
              return NavigationActionPolicy.ALLOW;
            },
            onWebViewCreated: (controller) {
              _webViewController = controller;

              // Handle WebView controller creation if needed
            },
            onLoadStop: (controller, url) async {
              print("Page loaded: $url");
              if (fromSignUp) {
                if (url.toString().contains("wp-login.php") ||
                    url.toString().contains("https://thehen.io/access/")) {
                  Get.back();
                  Get.snackbar(
                    'Sign In',
                    'Please Fill The Details To Sign In',
                  );
                }
              }

              if (url.toString().contains("wp-login.php") ||
                  url.toString().contains("https://thehen.io/access/")) {
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
                Future.delayed(const Duration(seconds: 10), () {
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
