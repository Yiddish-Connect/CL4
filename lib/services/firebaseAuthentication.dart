import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
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

/// A singleton class containing Firebase Authentication related service
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<User?>? _subscription;
  FirebaseAuth get auth => _auth;

  // named constructor
  AuthService._privateConstructor() {
    // init subscription
     _subscription = _auth
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('\x1B[34m authStateChanges listener: User is currently signed out! \x1B[0m');
      } else {
        print('\x1B[34m authStateChanges listener: User is signed in! \x1B[0m');
      }
    });
  }

  // Singleton instance
  static final AuthService _singleton = AuthService._privateConstructor();

  factory AuthService() {
    return _singleton;
  }

  void dispose() {
    _subscription?.cancel();
  }

  /*
   Below are the auth methods. Beware that most are async functions.
  */
  // Static method to get the current user ID
  static String getCurrentUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }

  User? getUser() {
    return _auth.currentUser;
  }

  bool isSignedIn() {
    return _auth.currentUser != null;
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('Successfully signed in with email and password');
      return result.user;
    } catch (e) {
      print('Error signing in with email and password: $e');
      rethrow;
    }
  }

  // TODO: Sign in with email link (password-less)
  Future<void> signInWithEmailLink(String email) async {
    try {
      await _auth.sendSignInLinkToEmail(email: email, actionCodeSettings: actionCodeSettings);
      print('Successfully sent email verification');
    } catch (e) {
      print('Error sending email verification: $e');
      rethrow;
    }
  }

  // Sign in with phone number
  Future<void> sendCodeToPhoneNumber(
      String phoneNumber,
      void Function (ConfirmationResult confirmationResult) onConfirmationResult, // Web only
      void Function(String verificationId) onCodeSent, // Native only
      void Function(PhoneAuthCredential credential) onAutoResolution // Android only
      ) async {
    // Web
    if (kIsWeb) {
      // Wait for the user to complete the reCAPTCHA & for an SMS code to be sent.
      ConfirmationResult confirmationResult = await _auth.signInWithPhoneNumber(phoneNumber);
      onConfirmationResult(confirmationResult);
    } else if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        // Doc: https://firebase.flutter.dev/docs/auth/phone
        verificationCompleted: (PhoneAuthCredential credential) {
          // ANDROID ONLY!
          // This handler will only be called on Android devices which support automatic SMS code resolution.
          // Sign the user in (or link) with the auto-generated credential
          print("verificationCompleted...");
          onAutoResolution(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          // If Firebase returns an error,
          // for example for an incorrect phone number or if the SMS quota for the project has exceeded, a FirebaseAuthException will be sent to this handler.
          print("verificationFailed...");
          throw (e);
        },
        codeSent: (String verificationId, int? resendToken) async {
          // When Firebase sends an SMS code to the device, this handler is triggered with a verificationId and resendToken
          // (A resendToken is only supported on Android devices, iOS devices will always return a null value).
          print("codeSent...");
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("codeAutoRetrievalTimeout! Now using normal login method instead");
        },
      );
    } else {
      throw PlatformException(code: "invalid-platform", details: "signInWithPhoneNumber() only supports Web, Android, IOS, and MacOS");
    }
  }

  Future<User?> signInWithSMSCode({required String smsCode, ConfirmationResult? confirmationResult, PhoneAuthCredential? phoneAuthCredential, String? verificationId}) async {
    if (kIsWeb) {
      if (confirmationResult == null) {
        throw Exception("signInWithSMSCode: confirmationResult is null in Web");
      }
      try {
        UserCredential userCredential = await confirmationResult.confirm(smsCode);
        return userCredential.user;
      } catch (e) {
        rethrow;
      }
    } else if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      if (verificationId == null && phoneAuthCredential == null) {
        throw Exception("signInWithSMSCode: verificationId & phoneAuthCredential are both null in Native");
      }
      try {
        PhoneAuthCredential credential = phoneAuthCredential ?? PhoneAuthProvider.credential(verificationId: verificationId!, smsCode: smsCode);
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        return userCredential.user;
      } catch (e) {
        rethrow;
      }
    } else {
      throw PlatformException(code: "invalid-platform", details: "signInWithSMSCode() only supports Web, Android, IOS, and MacOS");
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
        rethrow;
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
        rethrow;
      }
    } else {
      throw PlatformException(code: "0613", message: "signInWithGoogle() only supports Android and Web. Where did you call this function?");
    }
    
  }

  Future<User?> signInAnonymously() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account.");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          rethrow;
        default:
          throw Exception("Unknown error.");
      }
    }
  }

  //check if user is signed in anonymously
  bool isAnonymous() {
    return _auth.currentUser!.isAnonymous;
  }

  // TODO: Convert the anonymous user to permanent user
  /// @param userCredential: UserCredential of the anonymous user
  /// @param method: "phone" or "google"
  Future<void> linkAnonymousUser(UserCredential userCredential, String method) async {
    // TODO
    // // Google Sign-in
    // final credential = GoogleAuthProvider.credential(idToken: idToken);
    //
    // // Email and password sign-in
    // final credential = EmailAuthProvider.credential(email: emailAddress, password: password);
    //
    // // Etc.
    //
    // try {
    //   final userCredential = await FirebaseAuth.instance.currentUser
    //       ?.linkWithCredential(credential);
    // } on FirebaseAuthException catch (e) {
    //   switch (e.code) {
    //     case "provider-already-linked":
    //       print("The provider has already been linked to the user.");
    //       break;
    //     case "invalid-credential":
    //       print("The provider's credential is not valid.");
    //       break;
    //     case "credential-already-in-use":
    //       print("The account corresponding to the credential already exists, "
    //           "or is already linked to a Firebase User.");
    //       break;
    //   // See the API reference for the full list of error codes.
    //     default:
    //       print("Unknown error.");
    //   }
  }

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print('Successfully registered');
      return result.user;
    } catch (e) {
      print('Error registering: $e');
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmailTo(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Successfully sent password reset Email to $email");
    } catch (e) {
      print("Error sending password reset Email: $e");
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print("Successfully signed out");
    } catch (e) {
      print("Error signing out: $e");
      rethrow;
    }
  }
}



