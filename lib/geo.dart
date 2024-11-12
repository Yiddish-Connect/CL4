import 'dart:convert';
import 'package:http/http.dart' as http;

var testEnpoint = 'https://jsonplaceholder.typicode.com/albums/1';
var testApiEndpoint =
    'https://ip-geo-location.p.rapidapi.com/ip/check?format=json&language=en';

var testKey = "e8be3a5e5cmsh25d7154846f6ff8p11e51bjsna502b14b952b";
var testHost = "ip-geo-location.p.rapidapi.com";

Future<http.Response> getAlbum() {
  return http.get(
    Uri.parse(testApiEndpoint),
    headers: {
      "Content-Type": "application/json",
      "x-rapidapi-key": "d6c743e501msh706663273b9dfc7p190bb9jsnabc77f7cc357",
      "x-rapidapi-host": "geolocation53.p.rapidapi.com"
    },
  );
}

//https://www.geeksforgeeks.org/http-get-response-in-flutter/
//https://stackoverflow.com/questions/33581947/parsing-json-in-dart
//https://rapidapi.com/natkapral/api/ip-geo-location/playground/apiendpoint_0e95eebe-5290-481c-93d8-c417de659b25
//https://docs.flutter.dev/cookbook/networking/fetch-data
Future<void> geoLocation() async {
  var response = await getAlbum();
  var album = await json.decode(response.body);

  var result = album;
  //convert data
  print('HI ${result}');
}
