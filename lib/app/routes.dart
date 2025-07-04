import 'package:go_router/go_router.dart';
import 'package:elomae/app/views/screens/onboarding_screen.dart';
import 'package:elomae/app/views/screens/welcome_screen.dart';
import 'package:elomae/app/views/screens/login_screen.dart';
import 'package:elomae/app/views/screens/register_screen.dart';

final GoRouter routes = GoRouter(
  initialLocation: '/onboard',
  routes: [
    GoRoute(path: '/onboard', builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: '/welcome', builder: (context, state) => const WelcomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
  ],
);
