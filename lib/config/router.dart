import 'package:flutter/material.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/premium_screen.dart';
import '../screens/voice_hub_screen.dart';
import '../screens/tracker/free_tier_tracker_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/ai_news_screen.dart';
import '../screens/news_feed_screen.dart';
import '../screens/publisher_profile_screen.dart';
import '../models/tool_model.dart';
import '../screens/tool_detail_screen.dart';
import '../screens/main_navigation.dart';
import '../app/app_entry.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AppEntry(),
        );

      case '/auth':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AuthScreen(),
        );

      case '/home':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MainNavigation(),
        );

      case '/toolDetail':
        final args = settings.arguments;
        if (args is Tool) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => ToolDetailScreen(tool: args),
          );
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AppEntry(),
        );
// ... rest of the file remains same

      case '/premium':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PremiumScreen(),
        );

      case '/voice':
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => const VoiceHubScreen(),
          transitionsBuilder: (_, anim, __, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 400),
        );

      case '/onboarding':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AuthScreen(),
        );

      case '/tracker':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const FreeTierTrackerScreen(),
        );

      case '/profile':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ProfileScreen(),
        );

      case '/news':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AiNewsScreen(),
        );

      case '/news-feed':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const NewsFeedScreen(),
        );

      case '/publisher-profile':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PublisherProfileScreen(),
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AppEntry(),
        );
    }
  }
}
