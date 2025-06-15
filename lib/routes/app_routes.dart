import 'package:flutter/material.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/dashboard_home/dashboard_home.dart';
import '../presentation/events_list/events_list.dart';

class AppRoutes {
  static const String initial = '/';
  static const String onboardingFlow = '/onboarding-flow';
  static const String dashboardHome = '/dashboard-home';
  static const String eventsList = '/events-list';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const OnboardingFlow(),
    onboardingFlow: (context) => const OnboardingFlow(),
    dashboardHome: (context) => const DashboardHome(),
    eventsList: (context) => const EventsList(),
  };
}
