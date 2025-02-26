//shatoria
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

var donationUrl =
    'https://nowpayments.io/embeds/donation-widget?api_key=YWW7YS9-A114J08-N1A0YG2-AWGQX2P';

//donation screen dosen't work on web
//see https://pub.dev/packages/webview_flutter form more details
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
      body: !kIsWeb ? const DonationWidget() : Placeholder(),
    );
  }
}
//see https://www.youtube.com/watch?v=jRoyx6KOYMU&t=77s
//you can work on the ios setup with that as webveiw supports ios already

class DonationWidget extends StatelessWidget {
  const DonationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: donationUrl,
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
