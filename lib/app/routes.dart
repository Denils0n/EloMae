import 'package:go_router/go_router.dart';
import 'package:elomae/app/views/screens/auth/onboarding_screen.dart';
import 'package:elomae/app/views/screens/auth/welcome_screen.dart';
import 'package:elomae/app/views/screens/auth/login_screen.dart';
import 'package:elomae/app/views/screens/auth/register_screen.dart';
import 'package:elomae/app/views/screens/auth/forgot_password_screen.dart';
import 'package:elomae/app/views/screens/home/home_screen.dart';
import 'package:elomae/app/views/screens/database_screen.dart';
import 'package:elomae/app/views/screens/community/community_screen.dart';

final GoRouter routes = GoRouter(
  initialLocation: '/community',
  routes: [
    GoRoute(path: '/onboard', builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: '/welcome', builder: (context, state) => const WelcomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/forgot_password', builder: (context, state) => const ForgotPasswordScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomepageScreen()),
    GoRoute(path: '/database', builder: (context, state) => const FirestoreExample()),
    GoRoute(path: '/community', builder: (context, state) => const CommunityPageScreen()),
  ],
);
