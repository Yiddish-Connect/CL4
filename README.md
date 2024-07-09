# Yiddish Connect
## Supported Platforms
- android
- ios
- web
- macos

## Getting Started
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

For Firebase + Flutter integration, refer to the [documentation of FlutterFire](https://firebase.flutter.dev/docs/overview):

The link to our [Firebase console](https://console.firebase.google.com/u/0/project/ydapp-830fe/overview):

# Firebase Service
## Flutterfire - Quick Start
1. Turn the developer mode on in your local computer. For Windows user: \
    Search for `Developer mode` in Windows settings.
   
3. (Done but please read) To set up Firebase service in a new Flutter project, follow the tutorial here: \
    https://firebase.google.com/docs/flutter/setup?authuser=0&platform=ios

4. To manage Firebase service in your local computer, follow the tutorial here to install Firebase CLI: \
    https://firebase.google.com/docs/cli?hl=en&authuser=0\
    - If you have Node.js installed, the easiest way is to run `npm install -g firebase-tools`.
    - Make sure that you can run `flutterfire` command in the terminal

5. You need to re-run the following command any time that you:
    1. Start supporting a new platform in your Flutter app.
    2. Start using a new Firebase service or product in your Flutter app, especially if you start using sign-in with Google, Crashlytics, Performance Monitoring, or Realtime Database.
    3. Re-running the command ensures that your Flutter app's Firebase configuration is up-to-date and (for Android) automatically adds any required Gradle plugins to your app.
    ```bash
        # Run this
        firebase login
        flutterfire configure
    ```
6. (Optional) If you need to test some Android features, such as Google login in Android emulator, you need to add your **SHA1** and your **SHA256** fingerprint to our Firebase console.
    - Follow the tutotial [here](https://medium.com/@MatchaLatt3/finding-sha1-and-sha-256-key-for-flutter-app-in-android-studio-on-windows-e24cc4d76328) to find your **SHA1** and **SHA256** fingerprint.
    - Then add your **SHA1** and your **SHA256** under [Project settings - General - my apps](https://console.firebase.google.com/u/0/project/ydapp-830fe/settings/general/android:com.yiddishland.yiddishconnect)

## Firebase Authentication
### lib/services/auth.dart
`AuthService` is a singleton class defining methods related to authentication.

### Login Methods
1. Phone OTP login.
    - For testing purpose, use the **test phone number** `(314) 159-2653` and **test OTP code** `202406`
    - Supported features
        - Web:  **test phone number**, any **real phone number**
        - Android (Emulator):  **test phone number** only
        - Android (Real Device):  **test phone number**, any **real phone number**, ***auto SMS resolution***
        - IOS / MacOS:  **test phone number**, any **real phone number**
2. Google login. (Android/Web only)
    - **SHA1** and **SHA256** required for Android
3. Apple login. (IOS/MacOS only)
    - Testing needed
4. Email register / login. (Android/IOS/Web/MacOS)
5. Anonymous login. (Android/IOS/Web/MacOS)
    - Account linking not implemented yet

### User Management & Middlewares
We are currently using 2 ways to manage user authentication state:
1. `_router.redirection`: By adding redirection rules to go_router.
2. `AuthService()._subscription = _auth.authStateChanges().listen((User? user) {...}`: A publish-subscription model offered by Firebase.

To add/remove login methods, or to manually manage current users, visit our [Firebase console](https://console.firebase.google.com/u/0/project/ydapp-830fe/overview):
# Development
## Packages
### go_router ^14.2.0
Please read the [documentation here](https://pub.dev/documentation/go_router/latest/topics/Get%20started-topic.html).

The `_router` config is defined in `main.dart`

### provider ^6.1.2
Please read the [documentation here](https://pub.dev/packages/provider).

### Firebase related packages
- firebase_core: ^2.31.1
- firebase_auth: ^4.19.6
- google_sign_in: ^6.2.1

## File Structure (As of 6/27/2024)
```dart
CL4/
├── .dart_tool/    
├── .idea/    
├── android/     // Android-specific files
├── assets/     // Directory for storing images, fonts, and other assets used in the app.
├── build/     // Directory for generated build files.
├── ios/     // iOS-specific files.
├── lib/     // Main directory
│ ├── models/     // Contains data models used in the app.
│ ├── providers/     // Contains provider classes for state management. *See provider package
│ ├── screens/     // Contains different screen widgets for the app. *See go_router package
│ ├── services/     // Contains services that interact with APIs or databases.
│ ├── utils/     // Utility classes and functions.
│ ├── widgets/     // Reusable UI components.
│ ├── firebase_options.dart     // Configuration file for Firebase options.
│ └── main.dart     // Entry point for the Flutter application.
├── macos/     // macOS-specific files
├── test/     // Directory for unit and widget tests.
├── web/     // web-specific files
├── .flutter-plugins    
├── .flutter-plugins-dependencies
├── .gitignore     // Specifies which files and directories to ignore in version control.
├── .metadata    
├── analysis_options.yaml     // Configuration for the Dart analyzer.
├── devtools_options.yaml     // Configuration for the Flutter DevTools.
├── firebase.json     // Configuration for Firebase services.
├── pubspec.lock     // Lock file containing the exact versions of the dependencies used. Similar to package-lock.json
├── pubspec.yaml     // Configuration file for the Dart project, specifying dependencies and other project details. Similar to package.json
└── README.md     // You are currently reading
```

# UI
## UI Related Packages

## Custom Widgets
1. `MultiSteps` defined in `yd_multi_steps.dart`
2. `AnimatedProgressBar` defined in `yd_multi_steps.dart`

## Theme
We have a set of TextTheme and ColorScheme to share colors and font styles. See `main.dart`

Usage: 
```dart
color: Theme.of(context).ColorScheme.primary,
style: Theme.of(context).TextTheme.bodyLarge
```

For more information, please read the [documentation here](https://docs.flutter.dev/cookbook/design/themes)
