import 'package:elomae/app/views/screens/profile/profile_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:elomae/app/views/screens/auth/onboarding_screen.dart';
import 'package:elomae/app/views/screens/auth/welcome_screen.dart';
import 'package:elomae/app/views/screens/auth/login_screen.dart';
import 'package:elomae/app/views/screens/auth/register_screen.dart';
import 'package:elomae/app/views/screens/auth/forgot_password_screen.dart';
import 'package:elomae/app/views/screens/home/home_screen.dart';
import 'package:elomae/app/views/screens/database_screen.dart';
import 'package:elomae/app/views/screens/location/map_screen.dart';
import 'package:elomae/app/views/widgets/MainAppWrapper.dart';

final GoRouter routes = GoRouter(
  initialLocation: '/onboard',
  routes: [
    GoRoute(path: '/onboard', builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: '/welcome', builder: (context, state) => const WelcomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/forgot_password', builder: (context, state) => const ForgotPasswordScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomepageScreen()),
    GoRoute(path: '/profile', builder: (context, state) => MainAppWrapper(child:ProfileScreen())),
    GoRoute(path: '/database', builder: (context, state) => const FirestoreExample()),
    GoRoute(
      path: '/mapa',
      builder: (context, state) => MainAppWrapper(child: MapScreen()),
    ),
  ],
);
