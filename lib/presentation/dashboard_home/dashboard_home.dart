import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/quick_stats_widget.dart';
import './widgets/recent_contact_item_widget.dart';
import './widgets/upcoming_event_card_widget.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;
  bool _isRefreshing = false;

  // Mock data for upcoming events
  final List<Map<String, dynamic>> upcomingEvents = [
    {
      "id": 1,
      "title": "Team Building Workshop",
      "date": "2024-01-15",
      "time": "10:00 AM",
      "attendeeCount": 12,
      "thumbnail":
          "https://images.unsplash.com/photo-1552664730-d307ca884978?w=400&h=300&fit=crop",
      "location": "Conference Room A"
    },
    {
      "id": 2,
      "title": "Product Launch Meeting",
      "date": "2024-01-18",
      "time": "2:00 PM",
      "attendeeCount": 8,
      "thumbnail":
          "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400&h=300&fit=crop",
      "location": "Main Hall"
    },
    {
      "id": 3,
      "title": "Client Presentation",
      "date": "2024-01-20",
      "time": "11:30 AM",
      "attendeeCount": 6,
      "thumbnail":
          "https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=400&h=300&fit=crop",
      "location": "Meeting Room B"
    },
  ];

  // Mock data for recent contacts
  final List<Map<String, dynamic>> recentContacts = [
    {
      "id": 1,
      "name": "Sarah Johnson",
      "avatar":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop",
      "lastInteraction": "2 hours ago",
      "role": "Project Manager"
    },
    {
      "id": 2,
      "name": "Michael Chen",
      "avatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop",
      "lastInteraction": "1 day ago",
      "role": "Developer"
    },
    {
      "id": 3,
      "name": "Emily Rodriguez",
      "avatar":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop",
      "lastInteraction": "3 days ago",
      "role": "Designer"
    },
    {
      "id": 4,
      "name": "David Wilson",
      "avatar":
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop",
      "lastInteraction": "1 week ago",
      "role": "Client"
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _showCreateMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Create New',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'event',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'New Event',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              subtitle: Text(
                'Create and manage events',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/events-list');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person_add',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              title: Text(
                'Add Contact',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              subtitle: Text(
                'Add new contact to your network',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to add contact screen
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/events-list');
        break;
      case 2:
        // Navigate to contacts
        break;
      case 3:
        // Navigate to calendar
        break;
      case 4:
        // Navigate to profile
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.lightTheme.colorScheme.shadow,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search events and contacts...',
                        prefixIcon: CustomIconWidget(
                          iconName: 'search',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 2.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Greeting Header
              SliverToBoxAdapter(
                child: GreetingHeaderWidget(),
              ),

              // Quick Stats
              SliverToBoxAdapter(
                child: QuickStatsWidget(
                  totalEvents: upcomingEvents.length,
                  totalContacts: recentContacts.length,
                  pendingRSVPs: 5,
                ),
              ),

              // Upcoming Events Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upcoming Events',
                        style: AppTheme.lightTheme.textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/events-list');
                        },
                        child: Text('View All'),
                      ),
                    ],
                  ),
                ),
              ),

              // Upcoming Events Horizontal List
              SliverToBoxAdapter(
                child: upcomingEvents.isEmpty
                    ? Container(
                        height: 30.h,
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'event_note',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 48,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'No upcoming events',
                              style: AppTheme.lightTheme.textTheme.titleMedium,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Create your first event to get started',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 2.h),
                            ElevatedButton(
                              onPressed: _showCreateMenu,
                              child: Text('Create Event'),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 25.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          itemCount: upcomingEvents.length,
                          itemBuilder: (context, index) {
                            final event = upcomingEvents[index];
                            return UpcomingEventCardWidget(
                              event: event,
                              onTap: () {
                                // Navigate to event details
                              },
                              onLongPress: () {
                                // Show quick actions menu
                              },
                            );
                          },
                        ),
                      ),
              ),

              // Recent Contacts Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Contacts',
                        style: AppTheme.lightTheme.textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to contacts list
                        },
                        child: Text('View All'),
                      ),
                    ],
                  ),
                ),
              ),

              // Recent Contacts List
              recentContacts.isEmpty
                  ? SliverToBoxAdapter(
                      child: Container(
                        height: 20.h,
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'contacts',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 48,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'No contacts yet',
                              style: AppTheme.lightTheme.textTheme.titleMedium,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Add contacts to manage your network',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final contact = recentContacts[index];
                          return RecentContactItemWidget(
                            contact: contact,
                            onTap: () {
                              // Navigate to contact details
                            },
                            onCall: () {
                              // Handle call action
                            },
                            onMessage: () {
                              // Handle message action
                            },
                            onAddToEvent: () {
                              // Handle add to event action
                            },
                          );
                        },
                        childCount: recentContacts.length > 4
                            ? 4
                            : recentContacts.length,
                      ),
                    ),

              // Bottom padding for FAB
              SliverToBoxAdapter(
                child: SizedBox(height: 10.h),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateMenu,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _selectedIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'event',
              color: _selectedIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'contacts',
              color: _selectedIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'calendar_today',
              color: _selectedIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _selectedIndex == 4
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
