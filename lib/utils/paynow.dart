import 'dart:convert';

import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

String tempEmail = "shatoriag01@gmail.com";
String tempPassword = "TORi5576";
var client = BrowserClient();

class PayNowService {
  //this is the constructor
  //https://dart.dev/language/constructors
  PayNowService();

  Future<http.Response> testPayNowEndpoint() async {
    String endpoint = "https://api.nowpayments.io/v1/status";
    var response = await client.get(Uri.parse(endpoint));
    return response;
  }

  dynamic getAuthToken() async {
    String endpoint = "https://api.nowpayments.io/v1/auth";
    var response = await client.post(
      Uri.parse(endpoint),
      body: {"email": tempEmail, "password": tempPassword},
    );

    return jsonDecode(response.body.toString());
  }
}
