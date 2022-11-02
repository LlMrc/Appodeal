import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Browser extends StatefulWidget {
  const Browser({Key? key}) : super(key: key);

  @override
  State<Browser> createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  double progress = 0;

  late WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (await controller.canGoBack()) {
            controller.goBack();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              LinearProgressIndicator(
                value: progress,
                color: Colors.red,
                backgroundColor: Colors.black12,
              ),
              Expanded(
                child: WebView(
                  initialUrl: "https://www.google.com/",
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (controller) {
                    this.controller = controller;
                  },
                  onPageStarted: (url) {
                    print(url);
                  },
                  onProgress: (progress) => setState(() {
                    this.progress = progress / 100;
                  }),
                  // gestureRecognizers: Set()
                  //   ..add(Factory<VerticalDragGestureRecognizer>(
                  //       () => VerticalDragGestureRecognizer())),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            height: 40,
            color: Colors.black38,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: () {
                    controller.clearCache();
                    CookieManager().clearCookies();
                  },
                ),
                IconButton(
                    onPressed: () async {
                      if (await controller.canGoBack()) {
                        controller.reload();
                      }
                    },
                    icon: const Icon(Icons.refresh)),
                GestureDetector(
                    onTap: () async {
                      controller.loadUrl("https://www.amazon.com/");
                    },
                    child: const SizedBox(
                        width: 60,
                        height: 25,
                        child: Icon(FontAwesomeIcons.amazon))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
