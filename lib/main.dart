import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yiddishconnect/screens/authentication.dart';
import 'package:yiddishconnect/screens/dev_signin_signup/dev_home.dart';
import 'package:yiddishconnect/screens/email/emailSignIn.dart';
import 'package:yiddishconnect/screens/email/emailSignUp.dart';
import 'package:yiddishconnect/screens/onboarding.dart';
import 'package:yiddishconnect/screens/phone/phoneAuth.dart';
import 'package:yiddishconnect/services/auth.dart';
import 'package:yiddishconnect/utils/helpers.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp.router(
        title: 'Yiddish Connect',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xfff3dbab)), // Same to https://yiddishlandcalifornia.org/
          textTheme: TextTheme(
            displayLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w900, fontSize: 57.0),
            displayMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w800, fontSize: 45.0),
            displaySmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 36.0),
            headlineLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 32.0),
            headlineMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 28.0),
            headlineSmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 24.0),
            titleLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 22.0),
            titleMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 16.0),
            titleSmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w300, fontSize: 14.0),
            bodyLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 16.0),
            bodyMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w300, fontSize: 14.0),
            bodySmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w200, fontSize: 12.0),
            labelLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 14.0),
            labelMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 12.0),
            labelSmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 11.0),
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random(); // a random word
}

final _router = GoRouter(
  routes: [
    GoRoute(
      name: "onboardingScreen",
      path: '/',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      name: "authScreen",
      path: '/auth',
      builder: (context, state) => AuthScreen(),
      routes: [
        GoRoute(
          name: "phoneAuthScreen",
          path: 'phone',
          builder: (context, state) => PhoneAuthScreen(),
        ),
        GoRoute(
          name: "emailSignInScreen",
          path: 'email/sign-in',
          builder: (context, state) => EmailSignInScreen(),
        ),
        GoRoute(
          name: "emailSignUpScreen",
          path: 'email/sign-up',
          builder: (context, state) => EmailSignUpScreen(),
        ),
      ]
    ),
    GoRoute(
      name: "homeScreen",
      path: '/home',
      builder: (context, state) => DevHomeScreen(),
    ),
  ],

  // redirect to the login page if the user is not logged in
  redirect: (context, state) {
    // if the user is not logged in, they need to login
    final loggedIn = AuthService().getUser() != null;
    final loggingIn = state.matchedLocation.startsWith('/auth')|| state.matchedLocation == "/";

    print( "loggedIn: $loggedIn  loggingIn: $loggingIn");
    print(state.matchedLocation);
    if (!loggedIn) return loggingIn ? null : '/';

    // if the user is logged in but still on the login page, send them to
    // the home page
    if (loggedIn && loggingIn) return '/home';

    // no need to redirect at all
    return null;
  },
);

