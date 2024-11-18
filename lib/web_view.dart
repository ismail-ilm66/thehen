import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class InAppWebViewFileUploadPage extends StatefulWidget {
  @override
  _InAppWebViewFileUploadPageState createState() =>
      _InAppWebViewFileUploadPageState();
}

class _InAppWebViewFileUploadPageState
    extends State<InAppWebViewFileUploadPage> {
  late InAppWebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      // Enable debugging for Android
      InAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("InAppWebView File Upload"),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri("https://joyuful.com"),
        ),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        onLoadStop: (controller, url) {
          print("Page loaded: $url");
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          // Intercept file upload requests here
          if (navigationAction.request.url?.scheme == "fileupload") {
            await _handleFileUpload();
            return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
        },
      ),
    );
  }

  Future<void> _handleFileUpload() async {
    // Use FilePicker to select files
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      // Process the selected file if necessary
      print("Selected file: ${file.path}");
    }
  }
}
