import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yiddishconnect/services/firebaseAuthentication.dart';
import 'package:yiddishconnect/utils/helpers.dart';

class DevHomeScreen extends StatelessWidget {
  final AuthService _auth = AuthService();

  DevHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dev Home"),
      ),
      body: Column(
        children: [
          Text(
            "This is the home page",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text("user: ${_auth.getUser()}"),
          SizedBox(
            width: 100,
            height: 100,
          ),
          Text("displayName: ${_auth.getUser()?.displayName}"),
          Text("email: ${_auth.getUser()?.email}"),
          Text("emailVerified?? ${_auth.getUser()?.emailVerified}"),
          ElevatedButton(
            child: Text("Log out"),
            onPressed: () async {
              try {
                await AuthService().signOut();
              } catch (e) {
                if (!context.mounted) {
                  throw Exception(
                      "DevHome - Log Out Button: context.mounted is false!!");
                }
                toast(context, e.toString());
              }
              if (!context.mounted) {
                throw Exception(
                    "DevHome - Log Out Button: context.mounted is false!!");
              }
              context.go("/");
            },
          ),
          ElevatedButton(
            child: Text("Select Preference"),
            onPressed: () async {
              if (!context.mounted) {
                throw Exception(
                    "DevHome - Preference Button: context.mounted is false!!");
              }
              context.go("/preference");
            },
          ),
          //shatoria
          ElevatedButton(
            child: Text("donate"),
            onPressed: () async {
              if (!kIsWeb) {
                context.go("/dontaion");
              } else {
                var url = Uri.http(
                    "nowpayments.io", '/embeds/donation-widget', {
                  "api_key":
                      RemoteConfigHelper.remoteConfig.getString("dev_home_Key")
                }); //api key in firebase dev_home_Key
                await launchUrl(url);
              }
            },
          )
        ],
      ),
    );
  }
}
