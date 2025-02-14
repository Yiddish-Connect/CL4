import 'package:firebase_remote_config/firebase_remote_config.dart';

final _remoteConfig = FirebaseRemoteConfig.instance;
bool remoteConfigIsLoading = false;

initRemoteConfig() async {
  remoteConfigIsLoading = false;
  await _remoteConfig.setDefaults({
    "apiKey_FirebaseInitializeApp_sw": "",
    "apiKey_FirebaseOptions_android": "",
    "apiKey_FirebaseOptions_indexhtml": "",
    "apiKey_FirebaseOptions_ios": "",
    "apiKey_FirebaseOptions_mac": "",
    "apiKey_FirebaseOptions_web": "",
    "dev_home_Key": "",
    "donationUrl_key": "",
    "geo_dartKey": "",
    "geo_x_rapidapi_key": "",
  }); //incase data hasn't been fetched yet

  //configurations
  await _remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration(seconds: 10),
    ),
  );

  await _remoteConfig.fetchAndActivate();

  remoteConfigIsLoading = true;
}
