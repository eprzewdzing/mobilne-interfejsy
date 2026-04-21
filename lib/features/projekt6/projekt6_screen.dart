import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Projekt6Screen extends StatefulWidget {
  const Projekt6Screen({super.key});

  @override
  State<Projekt6Screen> createState() => _Projekt6Screen();
}

class _Projekt6Screen extends State<Projekt6Screen> {
  late WebViewController controller;
  var loadingPercentage = 0;
  int currentIndex = 0;

  final List<String> pages = [
    'https://wfis.uni.lodz.pl',
    'https://flutter.dev',
    'https://google.com',
    'https://wikipedia.org',
  ];

  void loadPage(int index){
    setState(() {
      currentIndex = index;
    });
    controller.loadRequest(Uri.parse(pages[index]));
  }

  @override
  void initState(){
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..loadRequest(Uri.parse(pages[0]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await controller.canGoBack()) {
                controller.goBack();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () async {
              if (await controller.canGoForward()) {
                controller.goForward();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
          children: [
            WebViewWidget(
              controller: controller,
            ),
            loadingPercentage <100
            ? LinearProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
              value: loadingPercentage/100.0,
            )
                : const SizedBox.shrink()
          ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: loadPage,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'WFIS'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flutter_dash),
            label: 'Flutter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Google',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.public),
              label: 'Wikipedia'
          ),
        ],
      ),
    );
  }
}