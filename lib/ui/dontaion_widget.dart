//shatoria
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yiddishconnect/utils/firebase_remoteConfig.dart';

var donationUrl = RemoteConfigHelper.remoteConfig
    .getString("donationUrl_key"); //api key in firebase donationUrl_key

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
