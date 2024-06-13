// Put firebase authentication here
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

var actionCodeSettings = ActionCodeSettings(
  // URL you want to redirect back to. The domain (www.example.com) for this
  // URL must be whitelisted in the Firebase Console.
    url: 'https://www.google.com',
    // This must be true
    handleCodeInApp: true,
    iOSBundleId: 'com.yiddishland.ios',
    androidPackageName: 'com.yiddishland.android',
    // installIfNotAvailable
    androidInstallApp: true,
    // minimumVersion
    androidMinimumVersion: '12'
);

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getUser() {
    return _auth.currentUser;
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('Successfully signed in with email and password');
      return result.user;
    } catch (e) {
      print('Error signing in with email and password: $e');
      return null;
    }
  }

  // Sign in with email link (password-less)
  void signInWithEmailLink(String email) async {
    try {
      await _auth.sendSignInLinkToEmail(email: email, actionCodeSettings: actionCodeSettings);
      print('Successfully sent email verification');
    } catch (e) {
      print('Error sending email verification: $e');
    }
  }

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    // Web
    if (kIsWeb) {
      try {
        // Create a new provider
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        // TODO: Add any permission scopes needed
        // googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
        googleProvider.setCustomParameters({
          'login_hint': 'user@example.com'
        });

        // Once signed in, return the UserCredential
        UserCredential result = await FirebaseAuth.instance.signInWithPopup(googleProvider);

        // Or use signInWithRedirect
        // UserCredential result = await FirebaseAuth.instance.signInWithRedirect(googleProvider);
        
        return result.user;
      } catch (e) {
        print('Error signing in with Google: $e');
        return null;
      }
    } else if (Platform.isAndroid) {
      try {
        // Trigger the authentication flow
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        // Obtain the auth details from the request
        final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        // Once signed in, return the UserCredential.user
        UserCredential result = await FirebaseAuth.instance.signInWithCredential(credential);
        print('Successfully signed in with Google');
        return result.user;
      } catch (e) {
        print('Error signing in with Google: $e');
        return null;
      }
    } else {
      throw PlatformException(code: "123", message: "signInWithGoogle() only supports Android and Web. Where did you call this function?");
    }
    
  }

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print('Successfully registered');
      return result.user;
    } catch (e) {
      print('Error registering: $e');
      return null;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
