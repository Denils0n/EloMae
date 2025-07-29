import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VLibrasOverlay extends StatefulWidget {
  const VLibrasOverlay({super.key});

  @override
  State<VLibrasOverlay> createState() => _VLibrasOverlayState();
}

class _VLibrasOverlayState extends State<VLibrasOverlay> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadFlutterAsset('assets/vlibras/vlibras_widget.html');
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      top: 0,
      child: IgnorePointer(
        ignoring:
            true, // Deixa a WebView "transparente" para toques, exceto no VLibras
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
