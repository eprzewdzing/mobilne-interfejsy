import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Projekt6Screen extends StatefulWidget {
  const Projekt6Screen({super.key});

  @override
  State<Projekt6Screen> createState() => _Projekt6Screen();
}

class _Projekt6Screen extends State<Projekt6Screen> {
  late WebViewController controller;
  final TextEditingController urlController = TextEditingController();

  int loadingPercentage = 0;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
              urlController.text = url;
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
              urlController.text = url;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse('https://flutter.dev'));

    urlController.text = 'https://flutter.dev';
  }

  void loadPage() {
    String url = urlController.text.trim();

    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    controller.loadRequest(Uri.parse(url));
  }

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () async {
                    if (await controller.canGoBack()) {
                      controller.goBack();
                    }
                  },
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () async {
                    if (await controller.canGoForward()) {
                      controller.goForward();
                    }
                  },
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    controller.reload();
                  },
                  visualDensity: VisualDensity.compact,
                ),
                Expanded(
                  child: TextField(
                    controller: urlController,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      hintText: 'Wpisz adres URL',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: loadPage,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSubmitted: (_) => loadPage(),
                  ),
                ),
              ],
            ),
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
              color: Theme.of(context).colorScheme.secondary,
            ),
          Expanded(
            child: WebViewWidget(
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}