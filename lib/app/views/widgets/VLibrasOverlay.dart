import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VLibrasOverlay extends StatefulWidget {
  const VLibrasOverlay({super.key});

  @override
  State<VLibrasOverlay> createState() => _VLibrasOverlayState();
}

class _VLibrasOverlayState extends State<VLibrasOverlay> {
  late final WebViewController _controller;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'VLibrasChannel',
        onMessageReceived: (message) {
          setState(() {
            _expanded = message.message == 'expand';
            if (message.message == 'collapse') {
              _expanded = false;
            }
          });
        },
      )
      ..loadFlutterAsset('assets/vlibras/vlibras_widget.html');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonHeight = _expanded ? 350 : 60;
    final top = (screenHeight - buttonHeight) / 2;
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      top: top,
      right: 5,
      width: _expanded ? 200 : 60,
      height: buttonHeight.toDouble(),
      child: WebViewWidget(controller: _controller),
    );
  }
}
