import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/dashboard_home/dashboard_home.dart';
import '../presentation/events_list/events_list.dart';
import '../presentation/chat_list/chat_list.dart';
import '../presentation/chat_interface/chat_interface.dart';

// Define route names as constants for easy reference
class AppRoutes {
  static const String initial = '/';
  static const String onboardingFlow = '/onboarding-flow';
  static const String dashboardHome = '/dashboard-home';
  static const String eventsList = '/events-list';
  static const String chatList = '/chat-list';
  static const String chatInterface = '/chat-interface';
  static const String signup = '/signup';
  static const String homescreen = '/homescreen';
  static const String contacts = '/contacts';
  static const String chats = '/chats';
  static const String events = '/events';
  static const String dashboard = '/dashboard';
  static const String settings = '/settings';
  static const String helpSupport = '/help_support';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/': 
      case AppRoutes.onboardingFlow:
        return CupertinoPageRoute(builder: (_) => const OnboardingFlow());
      case AppRoutes.dashboardHome:
        return CupertinoPageRoute(builder: (_) => const DashboardHome());
      case AppRoutes.eventsList:
        return CupertinoPageRoute(builder: (_) => const EventsList());
      case AppRoutes.chatList:
        return CupertinoPageRoute(builder: (_) => const ChatList());
      case AppRoutes.chatInterface:
        final args = settings.arguments as Map<String, dynamic>?;
        return CupertinoPageRoute(
            builder: (_) => ChatInterface(
                  conversationId: args?['conversationId'] ?? '',
                  conversationTitle: args?['conversationTitle'] ?? 'Chat',
                  isGroupChat: args?['isGroupChat'] ?? false,
                ));
      // Add routes for screens mentioned in user's code
      // These screens need to be implemented
      case AppRoutes.signup:
        return CupertinoPageRoute(
            builder: (_) => const Scaffold(
                body:
                    Center(child: Text('SignUp Screen - To be implemented'))));
      case AppRoutes.homescreen:
        return CupertinoPageRoute(
            builder: (_) => Scaffold(
                body: Center(child: Text('Home Screen - To be implemented'))));
      case AppRoutes.contacts:
        return CupertinoPageRoute(
            builder: (_) => const Scaffold(
                body: Center(
                    child: Text('Contacts Screen - To be implemented'))));
      case AppRoutes.chats:
        return CupertinoPageRoute(
            builder: (_) => const Scaffold(
                body: Center(child: Text('Chat Screen - To be implemented'))));
      case AppRoutes.events:
        return CupertinoPageRoute(
            builder: (_) => const Scaffold(
                body:
                    Center(child: Text('Events Screen - To be implemented'))));
      case AppRoutes.dashboard:
        return CupertinoPageRoute(
            builder: (_) => const Scaffold(
                body: Center(
                    child: Text('Dashboard Screen - To be implemented'))));
      case AppRoutes.settings:
        return CupertinoPageRoute(
            builder: (_) => const Scaffold(
                body: Center(
                    child: Text('Settings Screen - To be implemented'))));
      case AppRoutes.helpSupport:
        return CupertinoPageRoute(
            builder: (_) => const Scaffold(
                body: Center(
                    child: Text('Help & Support Screen - To be implemented'))));
      default:
        return CupertinoPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route not found: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
