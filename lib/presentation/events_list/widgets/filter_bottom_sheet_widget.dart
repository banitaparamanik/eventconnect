import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> activeFilters;
  final Function(Map<String, dynamic>, int) onFiltersChanged;

  const FilterBottomSheetWidget({
    super.key,
    required this.activeFilters,
    required this.onFiltersChanged,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _tempFilters;
  DateTimeRange? _selectedDateRange;
  List<String> _selectedEventTypes = [];
  List<String> _selectedAttendeeFilters = [];

  final List<String> _eventTypes = [
    'Conference',
    'Workshop',
    'Meeting',
    'Launch',
    'Social'
  ];
  final List<String> _attendeeFilterOptions = [
    '1-5 attendees',
    '6-15 attendees',
    '16+ attendees'
  ];

  @override
  void initState() {
    super.initState();
    _tempFilters = Map.from(widget.activeFilters);
    _initializeFilters();
  }

  void _initializeFilters() {
    if (_tempFilters['eventType'] != null) {
      _selectedEventTypes = List<String>.from(_tempFilters['eventType']);
    }
    if (_tempFilters['attendeeCount'] != null) {
      _selectedAttendeeFilters =
          List<String>.from(_tempFilters['attendeeCount']);
    }
    if (_tempFilters['dateRange'] != null) {
      final dateRange = _tempFilters['dateRange'] as Map<String, String>;
      _selectedDateRange = DateTimeRange(
        start: DateTime.parse(dateRange['start']!),
        end: DateTime.parse(dateRange['end']!),
      );
    }
  }

  void _applyFilters() {
    _tempFilters['eventType'] = _selectedEventTypes;
    _tempFilters['attendeeCount'] = _selectedAttendeeFilters;
    if (_selectedDateRange != null) {
      _tempFilters['dateRange'] = {
        'start': _selectedDateRange!.start.toIso8601String(),
        'end': _selectedDateRange!.end.toIso8601String(),
      };
    } else {
      _tempFilters.remove('dateRange');
    }

    final filterCount = _calculateFilterCount();
    widget.onFiltersChanged(_tempFilters, filterCount);
    Navigator.pop(context);
  }

  void _clearAllFilters() {
    setState(() {
      _tempFilters.clear();
      _selectedEventTypes.clear();
      _selectedAttendeeFilters.clear();
      _selectedDateRange = null;
    });
  }

  int _calculateFilterCount() {
    int count = 0;
    if (_selectedEventTypes.isNotEmpty) count++;
    if (_selectedAttendeeFilters.isNotEmpty) count++;
    if (_selectedDateRange != null) count++;
    return count;
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _selectedDateRange,
    );
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.sp)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          _buildDateRangeSection(),
          _buildEventTypeSection(),
          _buildAttendeeSection(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Filters', style: AppTheme.lightTheme.textTheme.titleMedium),
        TextButton(
          onPressed: _clearAllFilters,
          child: const Text('Clear All'),
        ),
      ],
    );
  }

  Widget _buildDateRangeSection() {
    return ListTile(
      title: Text('Date Range'),
      subtitle: Text(_selectedDateRange == null
          ? 'Any'
          : '${_selectedDateRange!.start.toLocal()} - ${_selectedDateRange!.end.toLocal()}'),
      trailing: IconButton(
        icon: Icon(Icons.date_range),
        onPressed: _selectDateRange,
      ),
    );
  }

  Widget _buildEventTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Event Type', style: AppTheme.lightTheme.textTheme.bodyLarge),
        Wrap(
          spacing: 8.0,
          children: _eventTypes.map((type) {
            final selected = _selectedEventTypes.contains(type);
            return FilterChip(
              label: Text(type),
              selected: selected,
              onSelected: (bool value) {
                setState(() {
                  if (value) {
                    _selectedEventTypes.add(type);
                  } else {
                    _selectedEventTypes.remove(type);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAttendeeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Attendee Count', style: AppTheme.lightTheme.textTheme.bodyLarge),
        Wrap(
          spacing: 8.0,
          children: _attendeeFilterOptions.map((option) {
            final selected = _selectedAttendeeFilters.contains(option);
            return FilterChip(
              label: Text(option),
              selected: selected,
              onSelected: (bool value) {
                setState(() {
                  if (value) {
                    _selectedAttendeeFilters.add(option);
                  } else {
                    _selectedAttendeeFilters.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: _applyFilters,
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
