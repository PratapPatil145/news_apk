import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class webContainer extends StatelessWidget {
  final String urls;
  webContainer({
      required this.urls,
  });
  // const webContainer({super.key});

 
   final Completer<WebViewController> _controller = Completer<WebViewController>();
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView (
        initialUrl: urls,
        javascriptMode: JavascriptMode.unrestricted,
    
        onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
      ),
    );
  }
}