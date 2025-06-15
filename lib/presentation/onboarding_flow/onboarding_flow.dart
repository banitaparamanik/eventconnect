import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/onboarding_page_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Create Events with Contacts",
      "description":
          "Seamlessly create events and invite contacts directly from your address book. No more switching between apps.",
      "imageUrl":
          "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "showContactsPermission": false,
    },
    {
      "title": "Manage Attendee Lists",
      "description":
          "Keep track of RSVPs, send invitations, and manage your event attendees all in one place.",
      "imageUrl":
          "https://images.pexels.com/photos/1181406/pexels-photo-1181406.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      "showContactsPermission": true,
    },
    {
      "title": "Smart Reminders",
      "description":
          "Never miss an event with intelligent notifications and reminders tailored to your schedule.",
      "imageUrl":
          "https://images.pixabay.com/photo/2016/12/19/21/36/woman-1919143_1280.jpg",
      "showContactsPermission": false,
    },
  ];

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    HapticFeedback.lightImpact();
    _completeOnboarding();
  }

  void _completeOnboarding() {
    Navigator.pushReplacementNamed(context, '/dashboard-home');
  }

  void _previousPage() {
    if (_currentPage > 0) {
      HapticFeedback.lightImpact();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _requestContactsPermission() {
    // Mock contacts permission request
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Contacts permission granted! You can now invite contacts to your events.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.surface,
              ),
        ),
        backgroundColor: AppTheme.getSuccessColor(true),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _requestNotificationPermission() {
    // Mock notification permission request
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Notification permission granted! You\'ll receive smart reminders for your events.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.surface,
              ),
        ),
        backgroundColor: AppTheme.getSuccessColor(true),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with skip button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button (only show if not on first page)
                  _currentPage > 0
                      ? GestureDetector(
                          onTap: _previousPage,
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            child: CustomIconWidget(
                              iconName: 'arrow_back',
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                              size: 24,
                            ),
                          ),
                        )
                      : SizedBox(width: 8.w),

                  // Progress indicator
                  Text(
                    '${_currentPage + 1} of ${_onboardingData.length}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                  ),

                  // Skip button
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      'Skip',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            // Page view content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                  HapticFeedback.selectionClick();
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(
                    title: _onboardingData[index]["title"] as String,
                    description:
                        _onboardingData[index]["description"] as String,
                    imageUrl: _onboardingData[index]["imageUrl"] as String,
                    showContactsPermission: _onboardingData[index]
                        ["showContactsPermission"] as bool,
                    onContactsPermissionTap: _requestContactsPermission,
                  );
                },
              ),
            ),

            // Bottom section with page indicators and buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 1.w),
                        width: _currentPage == index ? 8.w : 2.w,
                        height: 1.h,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(1.h),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Action buttons
                  Row(
                    children: [
                      // Notification permission button (only on last page)
                      if (_currentPage == _onboardingData.length - 1)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _requestNotificationPermission,
                            icon: CustomIconWidget(
                              iconName: 'notifications',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 20,
                            ),
                            label: Text('Enable Notifications'),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 3.h),
                            ),
                          ),
                        ),

                      if (_currentPage == _onboardingData.length - 1)
                        SizedBox(width: 4.w),

                      // Next/Get Started button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 3.h),
                          ),
                          child: Text(
                            _currentPage == _onboardingData.length - 1
                                ? 'Get Started'
                                : 'Next',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
