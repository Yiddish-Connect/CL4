import 'package:go_router/go_router.dart';
import 'package:yiddishconnect/services/firebaseAuthentication.dart';
import 'package:yiddishconnect/ui/auth/authentication.dart';
import 'package:yiddishconnect/ui/auth/email/emailSignIn.dart';
import 'package:yiddishconnect/ui/auth/email/emailSignUp.dart';
import 'package:yiddishconnect/ui/auth/phone/phoneAuth.dart';
import 'package:yiddishconnect/ui/home/home.dart';
import 'package:yiddishconnect/ui/home/preference/preference.dart';
import 'package:yiddishconnect/ui/landing.dart';
import 'package:yiddishconnect/ui/user/user.dart';

final ydRouter = GoRouter(
  routes: [
    GoRoute(
      name: "landingScreen",
      path: '/landing',
      builder: (context, state) => const LandingScreen(),
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
      path: '/',
      builder: (context, state) => HomeScreen(),
      routes: [
        GoRoute(
          name: "preferenceScreen",
          path: "preference",
          builder: (context, state) => PreferenceScreen(),
        ),
        GoRoute(
          name: "userScreen",
          path: "user",
          builder: (context, state) => UserScreen(),
        ),
        GoRoute(
          name: "profileScreen",
          path: "profile", // 👈 this is what allows /profile
          builder: (context, state) => UserScreen(),
        ),
      ],
    ),
  ],

  // redirect to the landing page if the user is not logged in
  redirect: (context, state) {
    // if the user is not logged in, they need to login
    final loggedIn = AuthService().getUser() != null;
    final loggingIn = state.matchedLocation.startsWith('/auth')|| state.matchedLocation == "/landing";

    print("\x1B[32m Route: ${state.matchedLocation} \x1B[0m   \x1B[34m User.uid: ${AuthService().getUser()?.uid} \x1B[0m");

    // If the user is not logged in (and not currently doing login process), send them to the landing page.
    if (!loggedIn) return loggingIn ? null : '/landing';

    // if the user is logged in but still on the login page, send them to
    // the home page
    // If the user is logged in but still on the login page, send them to the home page
    if (loggedIn && loggingIn && !AuthService().isAnonymous()) return '/'; //check if user not login as anonymous

    // no need to redirect at all
    return null;
  },
);