import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/event_card_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/search_header_widget.dart';

class EventsList extends StatefulWidget {
  const EventsList({super.key});

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = false;
  final bool _isSearching = false;
  String _searchQuery = '';
  String _selectedSort = 'chronological';
  Map<String, dynamic> _activeFilters = {};
  int _activeFilterCount = 0;

  // Mock data for events
  final List<Map<String, dynamic>> _allEvents = [
    {
      "id": 1,
      "title": "Annual Tech Conference 2024",
      "date": "2024-03-15",
      "time": "09:00 AM",
      "location": "Convention Center, Downtown",
      "description":
          "Join us for the biggest tech conference of the year featuring industry leaders and innovative technologies.",
      "type": "Conference",
      "attendees": [
        {
          "name": "John Doe",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "name": "Jane Smith",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "name": "Mike Johnson",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "name": "Sarah Wilson",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
      ],
      "isCompleted": false,
      "isSynced": true,
    },
    {
      "id": 2,
      "title": "Team Building Workshop",
      "date": "2024-03-20",
      "time": "02:00 PM",
      "location": "Office Conference Room A",
      "description":
          "Interactive workshop focused on improving team collaboration and communication skills.",
      "type": "Workshop",
      "attendees": [
        {
          "name": "Alex Brown",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "name": "Emma Davis",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
      ],
      "isCompleted": false,
      "isSynced": false,
    },
    {
      "id": 3,
      "title": "Client Presentation Meeting",
      "date": "2024-03-18",
      "time": "10:30 AM",
      "location": "Boardroom, 15th Floor",
      "description":
          "Quarterly presentation to key stakeholders and potential investors.",
      "type": "Meeting",
      "attendees": [
        {
          "name": "Robert Taylor",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "name": "Lisa Anderson",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "name": "David Wilson",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
      ],
      "isCompleted": true,
      "isSynced": true,
    },
    {
      "id": 4,
      "title": "Product Launch Event",
      "date": "2024-04-05",
      "time": "06:00 PM",
      "location": "Grand Ballroom, Hilton Hotel",
      "description":
          "Exclusive launch event for our latest product line with media and industry partners.",
      "type": "Launch",
      "attendees": [
        {
          "name": "Michael Chen",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "name": "Jennifer Lee",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "name": "Thomas Garcia",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "name": "Amanda Rodriguez",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "name": "Kevin Martinez",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
      ],
      "isCompleted": false,
      "isSynced": true,
    },
    {
      "id": 5,
      "title": "Monthly Team Standup",
      "date": "2024-03-25",
      "time": "11:00 AM",
      "location": "Virtual Meeting - Zoom",
      "description":
          "Regular monthly check-in with all team members to discuss progress and upcoming goals.",
      "type": "Meeting",
      "attendees": [
        {
          "name": "Chris Thompson",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "name": "Rachel White",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
      ],
      "isCompleted": false,
      "isSynced": true,
    },
  ];

  List<Map<String, dynamic>> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    _filteredEvents = List.from(_allEvents);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreEvents();
    }
  }

  void _loadMoreEvents() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      // Simulate loading delay
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterEvents();
    });
  }

  void _filterEvents() {
    List<Map<String, dynamic>> filtered = List.from(_allEvents);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((event) {
        return (event['title'] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (event['location'] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (event['type'] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply additional filters
    if (_activeFilters.isNotEmpty) {
      if (_activeFilters['eventType'] != null &&
          (_activeFilters['eventType'] as List).isNotEmpty) {
        filtered = filtered.where((event) {
          return (_activeFilters['eventType'] as List).contains(event['type']);
        }).toList();
      }

      if (_activeFilters['dateRange'] != null) {
        // Apply date range filter logic here
      }
    }

    // Apply sorting
    _sortEvents(filtered);

    setState(() {
      _filteredEvents = filtered;
    });
  }

  void _sortEvents(List<Map<String, dynamic>> events) {
    switch (_selectedSort) {
      case 'chronological':
        events.sort((a, b) =>
            DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
        break;
      case 'alphabetical':
        events.sort(
            (a, b) => (a['title'] as String).compareTo(b['title'] as String));
        break;
      case 'attendeeCount':
        events.sort((a, b) => (b['attendees'] as List)
            .length
            .compareTo((a['attendees'] as List).length));
        break;
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _filteredEvents = List.from(_allEvents);
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        activeFilters: _activeFilters,
        onFiltersChanged: (filters, filterCount) {
          setState(() {
            _activeFilters = filters;
            _activeFilterCount = filterCount;
          });
          _filterEvents();
        },
      ),
    );
  }

  void _showSortMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.sp)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort Events',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 16.sp),
            _buildSortOption('chronological', 'Date (Chronological)'),
            _buildSortOption('alphabetical', 'Title (A-Z)'),
            _buildSortOption('attendeeCount', 'Attendee Count'),
            SizedBox(height: 16.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String value, String label) {
    return ListTile(
      title: Text(label),
      leading: Radio<String>(
        value: value,
        groupValue: _selectedSort,
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedSort = newValue;
            });
            _filterEvents();
            Navigator.pop(context);
          }
        },
      ),
      onTap: () {
        setState(() {
          _selectedSort = value;
        });
        _filterEvents();
        Navigator.pop(context);
      },
    );
  }

  void _onEventAction(String action, Map<String, dynamic> event) {
    switch (action) {
      case 'edit':
        // Navigate to edit event screen
        break;
      case 'duplicate':
        // Duplicate event logic
        break;
      case 'share':
        // Share event logic
        break;
      case 'delete':
        _showDeleteConfirmation(event);
        break;
      case 'markComplete':
        setState(() {
          event['isCompleted'] = !event['isCompleted'];
        });
        break;
      case 'exportAttendees':
        // Export attendees logic
        break;
      case 'setReminder':
        // Set reminder logic
        break;
    }
  }

  void _showDeleteConfirmation(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _allEvents.removeWhere((e) => e['id'] == event['id']);
                _filteredEvents.removeWhere((e) => e['id'] == event['id']);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _createNewEvent() {
    // Navigate to create event screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create new event functionality')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SearchHeaderWidget(
              searchController: _searchController,
              onSearchChanged: _onSearchChanged,
              onFilterTap: _showFilterBottomSheet,
              onSortTap: _showSortMenu,
              activeFilterCount: _activeFilterCount,
            ),
            Expanded(
              child: _filteredEvents.isEmpty
                  ? _buildEmptyState()
                  : _buildEventsList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewEvent,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24.sp,
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildEventsList() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
        itemCount: _filteredEvents.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _filteredEvents.length) {
            return _buildLoadingIndicator();
          }

          final event = _filteredEvents[index];
          return EventCardWidget(
            event: event,
            onAction: _onEventAction,
            searchQuery: _searchQuery,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'event_note',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64.sp,
          ),
          SizedBox(height: 16.sp),
          Text(
            'No Events Found',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 8.sp),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try adjusting your search or filters'
                : 'Create your first event to get started',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.sp),
          ElevatedButton(
            onPressed: _searchQuery.isNotEmpty
                ? () {
                    _searchController.clear();
                    _onSearchChanged('');
                  }
                : _createNewEvent,
            child: Text(_searchQuery.isNotEmpty
                ? 'Clear Search'
                : 'Create First Event'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(16.sp),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 1, // Events tab active
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'dashboard',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24.sp,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'dashboard',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24.sp,
          ),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'event',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24.sp,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'event',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24.sp,
          ),
          label: 'Events',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'contacts',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24.sp,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'contacts',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24.sp,
          ),
          label: 'Contacts',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'settings',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24.sp,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'settings',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24.sp,
          ),
          label: 'Settings',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/dashboard-home');
            break;
          case 1:
            // Already on events list
            break;
          case 2:
            // Navigate to contacts
            break;
          case 3:
            // Navigate to settings
            break;
        }
      },
    );
  }
}