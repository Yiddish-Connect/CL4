import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yiddishconnect/services/auth.dart';
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
          Text("This is the home page", style: Theme.of(context).textTheme.headlineMedium,),
          Text("user: ${_auth.getUser()}"),
          SizedBox(width: 100, height: 100, ),
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
                    throw Exception("DevHome - Log Out Button: context.mounted is false!!");
                  }
                  toast(context, e.toString());
                }
                if (!context.mounted) {
                  throw Exception("DevHome - Log Out Button: context.mounted is false!!");
                }
                context.go("/");
              },
          )
        ],
      ),
    );
  }
}
