import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:wordpress/colors.dart';
import 'package:wordpress/controllers/web_controller.dart';

class AutoLoginPage extends StatelessWidget {
  final String email; // User email for login
  final String password; // User password for login

  AutoLoginPage({
    super.key,
    required this.email,
    required this.password,
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
              url: WebUri("https://joyuful.com/login/"),
            ),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true, // Enable JavaScript
              domStorageEnabled:
                  true, // Enable DOM storage for form interactions
            ),
            onWebViewCreated: (controller) {
              // Handle WebView controller creation if needed
            },
            onLoadStop: (controller, url) async {
              print("Page loaded: $url");

              if (url.toString().contains("wp-login.php")|| url.toString().contains("https://joyuful.com/login/")){

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
              }
            },
          ),
          Obx(() {
            // Observe loading state
            if (webViewController.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(color: ColorPalette.primaryColor,), // Show loader when loading
              );
            } else {
              return const SizedBox.shrink(); // Hide loader when not loading
            }
          }),
        ],
      ),
    );
  }
}
