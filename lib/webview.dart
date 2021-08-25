import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class webview extends StatefulWidget {
  String url;
  webview(this.url);

  @override
  _webviewState createState() => _webviewState();
}

class _webviewState extends State<webview> {
  String? Finalurl;
  final Completer<WebViewController> controller =
      Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    if (widget.url.toString().contains("http://")) {
      Finalurl = widget.url.toString().replaceAll("http://", "https://");
    } else {
      Finalurl = widget.url;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Global News"),
      ),
      body: SafeArea(
          child: Container(
        child: WebView(
          initialUrl: Finalurl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController WebViewController) {
            setState(() {
              controller.complete(WebViewController);
            });
          },
        ),
      )),
    );
  }
}
