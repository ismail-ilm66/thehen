import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:wordpress/colors.dart';
import 'package:wordpress/controllers/web_controller.dart';

class AutoLoginPage extends StatelessWidget {
  final String email; // User email for login
  final String password; // User password for login
  final String? otherUrl;

  AutoLoginPage({
    super.key,
    required this.email,
    required this.password,
    this.otherUrl,
  });

  final WebViewController webViewController =
      Get.put(WebViewController()); // Instantiate the controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Joyuful"),
        backgroundColor: ColorPalette.primaryColor,
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(otherUrl ?? "https://joyuful.com/login/"),
            ),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true, // Enable JavaScript
              domStorageEnabled:
                  true, // Enable DOM storage for form interactions
              useShouldOverrideUrlLoading: true,
            ),
            shouldOverrideUrlLoading:
                (controller, shouldOverrideUrlLoadingRequest) async {
              print(
                  'This is the URL: ${shouldOverrideUrlLoadingRequest.request.url}');
              if (shouldOverrideUrlLoadingRequest.request.url
                  .toString()
                  .contains('https://joyuful.com/wp-login.php?action=logout')) {
                Navigator.pop(context);
                Get.snackbar('Logged Out', 'You have been logged out');
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
                // Inject JavaScript to fill the form and submit it
                await controller.evaluateJavascript(source: """
                  (function() {
                    // Fill the username and password fields
                    document.getElementById('user_login0').value = '$email'; // Set email
                    document.getElementById('user_pass0').value = '$password'; // Set password

                    // Automatically submit the form
                    document.getElementById('wp-submit0').click(); // Click the login button
                  })();
                """);
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
          Obx(() {
            // Observe loading state
            if (webViewController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(), // Show loader when loading
              );
            } else {
              return const SizedBox.shrink(); // Hide loader when not loading
            }
          }),
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
