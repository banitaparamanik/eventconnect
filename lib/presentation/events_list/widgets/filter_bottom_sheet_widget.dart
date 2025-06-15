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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: AppTheme.lightTheme.colorScheme,
          ),
          child: child!,
        );
      },
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
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.sp)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateRangeSection(),
                  SizedBox(height: 24.sp),
                  _buildEventTypeSection(),
                  SizedBox(height: 24.sp),
                  _buildAttendeeSection(),
                  SizedBox(height: 32.sp),
                ],
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Filter Events',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          const Spacer(),
          TextButton(
            onPressed: _clearAllFilters,
            child: Text(
              'Clear All',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeSection() {
    return ExpansionTile(
      title: Text(
        'Date Range',
        style: AppTheme.lightTheme.textTheme.titleMedium,
      ),
      leading: CustomIconWidget(
        iconName: 'date_range',
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 24.sp,
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.sp),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(8.sp),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Range:',
                      style: AppTheme.lightTheme.textTheme.labelMedium,
                    ),
                    SizedBox(height: 4.sp),
                    Text(
                      _selectedDateRange != null
                          ? '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}'
                          : 'No date range selected',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: _selectedDateRange != null
                            ? AppTheme.lightTheme.colorScheme.onSurface
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.sp),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _selectDateRange,
                      child: Text('Select Date Range'),
                    ),
                  ),
                  if (_selectedDateRange != null) ...[
                    SizedBox(width: 8.sp),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedDateRange = null;
                        });
                      },
                      icon: CustomIconWidget(
                        iconName: 'clear',
                        color: AppTheme.lightTheme.colorScheme.error,
                        size: 20.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventTypeSection() {
    return ExpansionTile(
      title: Text(
        'Event Type',
        style: AppTheme.lightTheme.textTheme.titleMedium,
      ),
      leading: CustomIconWidget(
        iconName: 'category',
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 24.sp,
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
          child: Wrap(
            spacing: 8.sp,
            runSpacing: 8.sp,
            children: _eventTypes.map((type) {
              final isSelected = _selectedEventTypes.contains(type);
              return FilterChip(
                label: Text(type),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedEventTypes.add(type);
                    } else {
                      _selectedEventTypes.remove(type);
                    }
                  });
                },
                backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                selectedColor: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.2),
                checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
                labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                ),
                side: BorderSide(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendeeSection() {
    return ExpansionTile(
      title: Text(
        'Attendee Count',
        style: AppTheme.lightTheme.textTheme.titleMedium,
      ),
      leading: CustomIconWidget(
        iconName: 'people',
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 24.sp,
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
          child: Column(
            children: _attendeeFilterOptions.map((option) {
              final isSelected = _selectedAttendeeFilters.contains(option);
              return CheckboxListTile(
                title: Text(option),
                value: isSelected,
                onChanged: (selected) {
                  setState(() {
                    if (selected == true) {
                      _selectedAttendeeFilters.add(option);
                    } else {
                      _selectedAttendeeFilters.remove(option);
                    }
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
          SizedBox(width: 12.sp),
          Expanded(
            child: ElevatedButton(
              onPressed: _applyFilters,
              child: Text('Apply Filters (${_calculateFilterCount()})'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
