import 'package:flutter/material.dart';
import 'package:yiddishconnect/services/auth.dart';

class DevHome extends StatelessWidget {
  AuthService _auth = AuthService();

  DevHome({super.key});

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
          Text("emailVerified?? ${_auth.getUser()?.emailVerified}")
        ],
      ),
    );
  }
}
