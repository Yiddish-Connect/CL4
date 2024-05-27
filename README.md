# ydtind
A new Flutter project.
- android
- ios
- web
- macos
- windows

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



# Firebase Service
## Flutterfire - Quick Start
- ***Important (done but pls read):*** To set up Firebase in a new Flutter project, follow the tutorial here: \
    https://firebase.google.com/docs/flutter/setup?authuser=0&platform=ios

- ***Important:*** To manage Firebase service in your local computer, follow the tutorial here to install Firebase CLI: \
    https://firebase.google.com/docs/cli?hl=en&authuser=0\
    - If you have Node.js installed, the easiest way is to run `npm install -g firebase-tools`.
    - Make sure that you can run `flutterfire` command in the terminal

- ***Important:***  you need to re-run the following command any time that you:
    1. Start supporting a new platform in your Flutter app.
    2. Start using a new Firebase service or product in your Flutter app, especially if you start using sign-in with Google, Crashlytics, Performance Monitoring, or Realtime Database.
    3. Re-running the command ensures that your Flutter app's Firebase configuration is up-to-date and (for Android) automatically adds any required Gradle plugins to your app.
    
```bash
    firebase login
    flutterfire configure --project=ydapp-830fe
```

## Supported Platforms
- android
- ios
- web
- macos
- windows

**To add/delete platforms**: 
- Modify `./lib/firebase_options.dart` 
- Alternatively, use Firebase CLI commands