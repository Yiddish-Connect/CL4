<h1 align="center"> Yiddish Connect </h1> <br>
<p align="center">
  <a href="https://gitpoint.co/">
    <img alt="YiddishConnect" title="YiddishConnect" src="https://imgs.search.brave.com/_lWgwZkhx3q17am2F-y4mKxDs5t1klV5W6XOfLxRCJ8/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzAzLzI1LzQyLzM3/LzM2MF9GXzMyNTQy/MzcxMF9nMmRabHZw/OWtxVU5Oa1pnVFl6/V3pIaGNxOUEwcWlh/Ti5qcGc" width="250">
  </a>
</p>

<p align="center">
  A yiddish social media and learning platform, made with flutter
</p>

<p align="center">
  <a href="https://www.apple.com/us/search/yiddish-connect?src=globalnav">
    <img alt="Download on the App Store" title="App Store" src="http://i.imgur.com/0n2zqHD.png" width="140">
  </a>

  <a href="https://play.google.com/store/search?q=yiddish%20connect&c=apps">
    <img alt="Get it on Google Play" title="Google Play" src="http://i.imgur.com/mtGRPuM.png" width="140">
  </a>
</p>

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

<br/>

## Table of Contents

- [Introduction](#introduction)
- [Supported Platforms](#supported-platforms)
- [Features](#features)
- [Feedback](#feedback)
- [Contributors](#contributors)
- [FileTree](#filetree)
- [Getting Started](#getting-started)
  - [Firebase Service](#firebase-service)
  - [Flutterfire - Quick Start](#flutterfire-quick-start)
  - [Packages](#packages)
  - [Custom Widgets](#custom-widgets)
  - [Theme](#theme)
- [Donate](#donate)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

<br/>

## Introduction

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg?style=flat-square)](http://commitizen.github.io/cz-cli/)

A Yiddish social media and learning platform built with Flutter, designed to connect Yiddish speakers and learners worldwide. The platform fosters community engagement through social features like posts, discussions, and messaging while providing interactive learning tools for improving Yiddish language skills. With a modern, intuitive interface, users can seamlessly switch between social networking and educational resources, making it a hub for preserving and growing Yiddish culture in the digital age.


**Available for both iOS and Android.**

<p align="center">
  <img src = "https://imgur.com/UTX5b3P.jpeg" width=250>
</p>

<br/>

## Features

A few of the things you can do with Yiddish Connect:

* View user activity feed
* Make donations
* Learn the Yiddish Language
* Interact with other Yiddish people

<br/>

## Supported Platforms
- android
- ios
- web
- macos

<br/>

## Feedback

Feel free to send us feedback on [LinkedIn](https://www.linkedin.com/company/yaaana/) or [visit our website](https://www.yiddishlandcalifornia.org/). Feature requests are always welcome. If you wish to contribute, message us or give us a call at 619-719-1776 ! We look forward to hearing from you!

<br/>

## Contributors

This project follows the [all-contributors](https://github.com/Yiddish-Connect/CL4/graphs/contributors) specification and is brought to you by [YAANA](https://yiddishlandcalifornia.org/).

<br/>

## FileTree

┣ 📂android
┣ 📂assets
┃ ┣ 📂fonts
┣ 📂build
┃ ┣ 📂app
┣ 📂functions
┣ 📂ios
┣ 📂lib
┃ ┣ 📂models
┃ ┣ 📂services
┃ ┃ ┣ 📂storage
┃ ┣ 📂ui
┃ ┃ ┣ 📂auth
┃ ┃ ┃ ┣ 📂dev_signin_signup
┃ ┃ ┃ ┣ 📂email
┃ ┃ ┃ ┣ 📂phone
┃ ┃ ┣ 📂home
┃ ┃ ┃ ┣ 📂chat
┃ ┃ ┃ ┣ 📂event
┃ ┃ ┃ ┣ 📂friend
┃ ┃ ┃ ┣ 📂match
┃ ┃ ┃ ┣ 📂preference
┃ ┃ ┣ 📂notification
┃ ┃ ┣ 📂user
┃ ┣ 📂utils
┃ ┣ 📂widgets
┣ 📂macos
┣ 📂test
┣ 📂web
┃ ┣ 📂icons

<br/>

## Getting Started

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the [online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on mobile development, and a full API reference.

For Firebase + Flutter integration, refer to the [documentation of FlutterFire](https://firebase.flutter.dev/docs/overview/):

The link to our [Firebase console](https://console.firebase.google.com/u/0/project/ydapp-830fe/overview):


### Firebase Service
##### Flutterfire Quick Start
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

##### Firebase Authentication
###### lib/services/auth.dart
`AuthService` is a singleton class defining methods related to authentication.

###### Login Methods
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

##### User Management & Middlewares
We are currently using 2 ways to manage user authentication state:
1. `_router.redirection`: By adding redirection rules to go_router.
2. `AuthService()._subscription = _auth.authStateChanges().listen((User? user) {...}`: A publish-subscription model offered by Firebase.

To add/remove login methods, or to manually manage current users, visit our [Firebase console](https://console.firebase.google.com/u/0/project/ydapp-830fe/overview):

<br/>

### Packages
##### go_router ^14.2.0
Please read the [documentation here](https://pub.dev/documentation/go_router/latest/topics/Get%20started-topic.html).

The `_router` config is defined in `main.dart`

##### provider ^6.1.2
Please read the [documentation here](https://pub.dev/packages/provider).

##### Firebase related packages
- firebase_core: ^2.31.1
- firebase_auth: ^4.19.6
- google_sign_in: ^6.2.1

<br/>

### Custom Widgets
1. `MultiSteps` defined in `yd_multi_steps.dart`
2. `AnimatedProgressBar` defined in `yd_multi_steps.dart`

<br/>

### Theme

We have a set of TextTheme and ColorScheme to share colors and font styles. See `main.dart`

Usage:
color: Theme.of(context).ColorScheme.primary,
style: Theme.of(context).TextTheme.bodyLarge


For more information, please read the [documentation here](https://docs.flutter.dev/cookbook/design/themes)


<br/>
<br/>

## Donate

Support this project by becoming a donating. Your logo will show up here with a link to your website. [Donate?](https://yiddishlandcalifornia.org/donate/)



