//shatoria
import 'package:flutter/material.dart';
//import 'package:webview_flutter/webview_flutter.dart';

var html = '''
  <html>
    <body style="margin: 0; padding: 0; overflow: hidden;">
      <iframe 
        src="https://nowpayments.io/embeds/donation-widget?api_key=YWW7YS9-A114J08-N1A0YG2-AWGQX2P"
        width="100%"
        height="100%"
        frameborder="0"
        scrolling="no"
        style="overflow-y: hidden;"
      >
      Can't load widget
      </iframe>
    </body>
  </html>
''';

class DontationScreen extends StatefulWidget {
  const DontationScreen({super.key});

  @override
  State<DontationScreen> createState() => _DontationScreenState();
}

class _DontationScreenState extends State<DontationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const DonationWidget(),
    );
  }
}

class DonationWidget extends StatelessWidget {
  const DonationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
