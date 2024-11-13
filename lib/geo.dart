import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

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

Future<bool> askLocationPerms() async {
  LocationPermission permission;
  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return false;
    }
  } else {
    return true;
  }
  return false;
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

//https://www.geeksforgeeks.org/http-get-response-in-flutter/
//https://stackoverflow.com/questions/33581947/parsing-json-in-dart
//https://rapidapi.com/natkapral/api/ip-geo-location/playground/apiendpoint_0e95eebe-5290-481c-93d8-c417de659b25
//https://docs.flutter.dev/cookbook/networking/fetch-data
Future<void> geoLocation() async {
  //var response = await getAlbum();
  //var album = await json.decode(response.body);

  //var result = album;

  var result = await _determinePosition();

  //convert data
  print('HI ${result.toJson()["longitude"]}');
}
