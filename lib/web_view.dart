import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:file_picker/file_picker.dart';

class WebViewFileUploadPage extends StatefulWidget {
  @override
  _WebViewFileUploadPageState createState() => _WebViewFileUploadPageState();
}

class _WebViewFileUploadPageState extends State<WebViewFileUploadPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onNavigationRequest: (NavigationRequest request) async {
            // Handle custom URL schemes for file uploads
            if (request.url.startsWith('fileupload://')) {
              await _handleFileUploadRequest(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://joyuful.com'));
  }

  Future<void> _handleFileUploadRequest(String url) async {
    // Open file picker to select a file
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);

      // Upload file via WebView
      final String fileBase64 = base64Encode(file.readAsBytesSync());
      final String jsScript =
          "document.querySelector('input[type=file]').files[0] = new File([new Uint8Array(atob('$fileBase64').split('').map(c => c.charCodeAt(0)))], '${file.path.split('/').last}');";
      await _controller.runJavaScript(jsScript);
    } else {
      // User canceled the file picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WebView File Upload"),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
