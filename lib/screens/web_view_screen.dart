import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:wordpress/colors.dart';

class WebViewScreen extends StatefulWidget {
  final String token; // The JWT token passed from the login flow

  const WebViewScreen({super.key, required this.token});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late InAppWebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Joyuful"),
        backgroundColor: ColorPalette.primaryColor,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri("https://joyuful.com/entry/"),
          headers: {
            "Authorization": "Bearer ${widget.token}",
          },
        ),
        initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            useShouldOverrideUrlLoading: true,
            useShouldInterceptAjaxRequest: true,
            useShouldInterceptFetchRequest: true,
            domStorageEnabled: true,
            allowUniversalAccessFromFileURLs: true,
            javaScriptCanOpenWindowsAutomatically: true),
        //       onLoadStop: (controller, url) async {
        //         print("Page loaded: $url");

        //         // JavaScript to intercept the custom submit button and handle form submission
        //         String customFormHandler = """
        //   (function() {
        //     document.addEventListener('click', function(event) {
        //       if (event.target && event.target.matches('button.frm_button_submit.frm_final_submit')) {
        //         event.preventDefault(); // Prevent the default action

        //         // Locate the closest form to the button
        //         var form = event.target.closest('form');
        //         if (!form) {
        //           console.error('No form found for this button.');
        //           return;
        //         }

        //         // Create a new FormData object from the form
        //         var formData = new FormData(form);

        //         // Prepare a fetch request with the FormData
        //         fetch(form.action, {
        //           method: 'POST',
        //           headers: {
        //             'Authorization': 'Bearer ${widget.token}' // Add the Authorization token
        //             // Do NOT set Content-Type; the browser will handle it for multipart forms
        //           },
        //           body: formData
        //         })
        //         .then(function(response) {
        //           return response.text();
        //         })
        //         .then(function(html) {
        //           // Replace the current document with the response HTML
        //           document.documentElement.innerHTML = html;
        //         })
        //         .catch(function(error) {
        //           console.error('Error submitting form:', error);
        //         });
        //       }
        //     });

        //     // MutationObserver to handle dynamically added buttons/forms
        //     const observer = new MutationObserver(function(mutations) {
        //       mutations.forEach(function(mutation) {
        //         if (mutation.addedNodes) {
        //           mutation.addedNodes.forEach(function(node) {
        //             if (node.tagName === 'FORM' || node.tagName === 'BUTTON') {
        //               console.log('New form or button detected:', node);
        //             }
        //           });
        //         }
        //       });
        //     });

        //     // Start observing the document body
        //     observer.observe(document.body, { childList: true, subtree: true });
        //   })();
        // """;

        //         // Inject the JavaScript into the web page
        //         await controller.evaluateJavascript(source: customFormHandler);
        //       },
        // initialOptions: InAppWebViewGroupOptions(
        //   crossPlatform: InAppWebViewOptions(),
        // ),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        shouldOverrideUrlLoading:
            (controller, shouldOverrideUrlLoadingRequest) async {
          var url = shouldOverrideUrlLoadingRequest.request.url;

          print("Intercepted URL: $url");
          print(
              'This is the header of the intercepted url : ${shouldOverrideUrlLoadingRequest.request.headers}');

          var headers = {
            "Authorization": "Bearer ${widget.token}",
          };

          var modifiedRequest = URLRequest(
            url: url,
            headers: headers,
          );
          // print("URL: ${shouldOverrideUrlLoadingRequest.request}");
//This code is working
          // if (Platform.isAndroid ||
          //     shouldOverrideUrlLoadingRequest.iosWKNavigationType ==
          //         IOSWKNavigationType.LINK_ACTIVATED) {
          //   controller.loadUrl(urlRequest: modifiedRequest);
          //   return NavigationActionPolicy.CANCEL;
          // }
          // return NavigationActionPolicy.ALLOW;

          //The below is the test:
          if (Platform.isAndroid ||
              shouldOverrideUrlLoadingRequest.iosWKNavigationType ==
                  IOSWKNavigationType.LINK_ACTIVATED) {
            // Handling GET requests and links
            controller.loadUrl(urlRequest: modifiedRequest);
            return NavigationActionPolicy.CANCEL;
          } else if (shouldOverrideUrlLoadingRequest.request.method == "POST") {
            // Handling form submissions (POST requests)
            // controller.loadRequest(modifiedRequest); // For POST requests
            // controller.postUrl(url: url, postData: postData);
            // return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
        },
        shouldInterceptFetchRequest: (controller, fetchRequest) async {
          print("Intercepted Fetch Request: ${fetchRequest.url}");
          print("Request Method: ${fetchRequest.method}");
          print("Original Headers: ${fetchRequest.headers}");

          // Modify the headers to include the Authorization token
          var modifiedHeaders = {
            ...?fetchRequest.headers, // Preserve existing headers
            "Authorization":
                "Bearer ${widget.token}", // Add or overwrite the Authorization header
          };

          // Return a new FetchRequest object with modified headers
          return FetchRequest(
            url: fetchRequest.url,
            method: fetchRequest.method,
            headers: modifiedHeaders,
            body: fetchRequest.body,
            mode: fetchRequest.mode,
            credentials: fetchRequest.credentials,
            cache: fetchRequest.cache,
            redirect: fetchRequest.redirect,
            referrer: fetchRequest.referrer,
            referrerPolicy: fetchRequest.referrerPolicy,
            integrity: fetchRequest.integrity,
            keepalive: fetchRequest.keepalive,
          );
        },
        shouldInterceptAjaxRequest: (controller, ajaxRequest) async {
          print("Intercepted Ajax Request: ${ajaxRequest.url}");
          print("Request Method: ${ajaxRequest.method}");
          print("Original Headers: ${ajaxRequest.headers}");

          var modifiedHeaders = <String, String>{
            ...ajaxRequest.headers as Map<String, String>,
            "Authorization": "Bearer ${widget.token}",
          };
          // Return a new AjaxRequest object with modified headers
          return AjaxRequest(
            url: ajaxRequest.url,
            method: ajaxRequest.method,
            headers: AjaxRequestHeaders(modifiedHeaders),
            data: ajaxRequest.data,
            user: ajaxRequest.user,
            password: ajaxRequest.password,
            withCredentials: ajaxRequest.withCredentials,
            responseType: ajaxRequest.responseType,
          );
        },
        // shouldOverrideUrlLoading: (controller, navigationAction) async {
        //   var url = navigationAction.request.url;

        //   print("Intercepted URL: $url");
        //   print(
        //       'This is the header of the intercepted url : ${navigationAction.request.headers}');

        //   var headers = {
        //     "Authorization": "Bearer ${widget.token}",
        //   };

        //   var modifiedRequest = URLRequest(
        //     url: url,
        //     headers: headers,
        //   );
        //   navigationAction.request = modifiedRequest;
        //   // _webViewController.
        //   print('This is the navigation request:${navigationAction.request}');

        //   // Allow the WebView to load the modified URL request with the Authorization header
        //   return NavigationActionPolicy.ALLOW;
        // },

        onProgressChanged: (controller, progress) {
          print(
              'This is the url on the progress changed: ${controller.getUrl()}');

          if (progress == 100) {
            // Handle page load completion if needed
          }
        },
      ),
    );
  }
}
