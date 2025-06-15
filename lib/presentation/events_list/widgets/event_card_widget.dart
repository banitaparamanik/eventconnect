import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EventCardWidget extends StatefulWidget {
  final Map<String, dynamic> event;
  final Function(String, Map<String, dynamic>) onAction;
  final String searchQuery;

  const EventCardWidget({
    super.key,
    required this.event,
    required this.onAction,
    required this.searchQuery,
  });

  @override
  State<EventCardWidget> createState() => _EventCardWidgetState();
}

class _EventCardWidgetState extends State<EventCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isSwipeMenuVisible = false;
  String _swipeDirection = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.3, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleSwipe(DismissDirection direction) {
    setState(() {
      _swipeDirection =
          direction == DismissDirection.startToEnd ? 'right' : 'left';
      _isSwipeMenuVisible = true;
    });
    _animationController.forward();
  }

  void _resetSwipe() {
    _animationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _isSwipeMenuVisible = false;
          _swipeDirection = '';
        });
      }
    });
  }

  void _showContextMenu() {
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
          children: [
            _buildContextMenuItem('edit', 'Edit Event'),
            _buildContextMenuItem('duplicate', 'Duplicate Event'),
            _buildContextMenuItem('share', 'Share Event'),
            _buildContextMenuItem(
                'markComplete',
                widget.event['isCompleted']
                    ? 'Mark Incomplete'
                    : 'Mark Complete'),
            _buildContextMenuItem('exportAttendees', 'Export Attendees'),
            _buildContextMenuItem('setReminder', 'Set Reminder'),
            const Divider(),
            _buildContextMenuItem('delete', 'Delete Event',
                isDestructive: true),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(String action, String label,
      {bool isDestructive = false}) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: _getActionIcon(action),
        color: isDestructive
            ? AppTheme.lightTheme.colorScheme.error
            : AppTheme.lightTheme.colorScheme.onSurface,
        size: 20.sp,
      ),
      title: Text(
        label,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: isDestructive
              ? AppTheme.lightTheme.colorScheme.error
              : AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        widget.onAction(action, widget.event);
      },
    );
  }

  String _getActionIcon(String action) {
    switch (action) {
      case 'edit':
        return 'edit';
      case 'duplicate':
        return 'content_copy';
      case 'share':
        return 'share';
      case 'markComplete':
        return widget.event['isCompleted']
            ? 'radio_button_unchecked'
            : 'check_circle';
      case 'exportAttendees':
        return 'download';
      case 'setReminder':
        return 'alarm';
      case 'delete':
        return 'delete';
      default:
        return 'more_horiz';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.sp),
      child: Stack(
        children: [
          if (_isSwipeMenuVisible) _buildSwipeActions(),
          SlideTransition(
            position: _slideAnimation,
            child: Dismissible(
              key: Key(widget.event['id'].toString()),
              direction: DismissDirection.horizontal,
              confirmDismiss: (direction) async {
                _handleSwipe(direction);
                return false; // Don't actually dismiss
              },
              child: GestureDetector(
                onLongPress: _showContextMenu,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.sp),
                      color: AppTheme.lightTheme.colorScheme.surface,
                      border: widget.event['isCompleted']
                          ? Border.all(
                              color: AppTheme.lightTheme.colorScheme.tertiary
                                  .withValues(alpha: 0.3),
                              width: 1,
                            )
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildEventHeader(),
                        SizedBox(height: 12.sp),
                        _buildEventDetails(),
                        SizedBox(height: 12.sp),
                        _buildEventFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeActions() {
    return Positioned.fill(
      child: Container(
        margin: EdgeInsets.only(bottom: 12.sp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.sp),
          color: _swipeDirection == 'right'
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
        ),
        child: Row(
          children: _swipeDirection == 'right'
              ? [
                  SizedBox(width: 16.sp),
                  _buildSwipeAction(
                      'edit', 'Edit', AppTheme.lightTheme.colorScheme.primary),
                  SizedBox(width: 8.sp),
                  _buildSwipeAction('duplicate', 'Duplicate',
                      AppTheme.lightTheme.colorScheme.secondary),
                  SizedBox(width: 8.sp),
                  _buildSwipeAction('share', 'Share',
                      AppTheme.lightTheme.colorScheme.tertiary),
                  const Spacer(),
                  IconButton(
                    onPressed: _resetSwipe,
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20.sp,
                    ),
                  ),
                ]
              : [
                  IconButton(
                    onPressed: _resetSwipe,
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20.sp,
                    ),
                  ),
                  const Spacer(),
                  _buildSwipeAction('delete', 'Delete',
                      AppTheme.lightTheme.colorScheme.error),
                  SizedBox(width: 16.sp),
                ],
        ),
      ),
    );
  }

  Widget _buildSwipeAction(String action, String label, Color color) {
    return GestureDetector(
      onTap: () {
        _resetSwipe();
        widget.onAction(action, widget.event);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8.sp),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: _getActionIcon(action),
              color: color,
              size: 20.sp,
            ),
            SizedBox(height: 4.sp),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildHighlightedText(
                      widget.event['title'],
                      AppTheme.lightTheme.textTheme.titleMedium!,
                    ),
                  ),
                  if (widget.event['isCompleted'])
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.sp, vertical: 4.sp),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.tertiary
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                      child: Text(
                        'Completed',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 4.sp),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                decoration: BoxDecoration(
                  color: _getEventTypeColor().withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.sp),
                ),
                child: Text(
                  widget.event['type'],
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: _getEventTypeColor(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            if (widget.event['isSynced'])
              CustomIconWidget(
                iconName: 'sync',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 16.sp,
              )
            else
              CustomIconWidget(
                iconName: 'sync_disabled',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16.sp,
              ),
            SizedBox(width: 8.sp),
            CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20.sp,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEventDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'schedule',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 16.sp,
            ),
            SizedBox(width: 8.sp),
            Text(
              '${widget.event['date']} • ${widget.event['time']}',
              style: AppTheme.dataTextStyle(isLight: true, fontSize: 14.sp),
            ),
          ],
        ),
        SizedBox(height: 8.sp),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'location_on',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 16.sp,
            ),
            SizedBox(width: 8.sp),
            Expanded(
              child: _buildHighlightedText(
                widget.event['location'],
                AppTheme.lightTheme.textTheme.bodyMedium!.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEventFooter() {
    final attendees = widget.event['attendees'] as List;
    return Row(
      children: [
        _buildAttendeeAvatars(attendees),
        const Spacer(),
        Text(
          '${attendees.length} attendee${attendees.length != 1 ? 's' : ''}',
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildAttendeeAvatars(List attendees) {
    const maxVisible = 3;
    final visibleAttendees = attendees.take(maxVisible).toList();
    final remainingCount = attendees.length - maxVisible;

    return Row(
      children: [
        ...visibleAttendees.asMap().entries.map((entry) {
          final index = entry.key;
          final attendee = entry.value as Map<String, dynamic>;
          return Container(
            margin: EdgeInsets.only(
                right: index < visibleAttendees.length - 1 ? 4.sp : 0),
            child: CircleAvatar(
              radius: 16.sp,
              backgroundColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
              child: attendee['avatar'] != null
                  ? CustomImageWidget(
                      imageUrl: attendee['avatar'],
                      width: 32.sp,
                      height: 32.sp,
                      fit: BoxFit.cover,
                    )
                  : Text(
                      (attendee['name'] as String)
                          .substring(0, 1)
                          .toUpperCase(),
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
            ),
          );
        }),
        if (remainingCount > 0) ...[
          SizedBox(width: 4.sp),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.sp),
            ),
            child: Text(
              '+$remainingCount',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHighlightedText(String text, TextStyle style) {
    if (widget.searchQuery.isEmpty) {
      return Text(text, style: style);
    }

    final query = widget.searchQuery.toLowerCase();
    final textLower = text.toLowerCase();
    final spans = <TextSpan>[];

    int start = 0;
    int index = textLower.indexOf(query);

    while (index != -1) {
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index), style: style));
      }

      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: style.copyWith(
          backgroundColor:
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
          fontWeight: FontWeight.w600,
        ),
      ));

      start = index + query.length;
      index = textLower.indexOf(query, start);
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: style));
    }

    return RichText(text: TextSpan(children: spans));
  }

  Color _getEventTypeColor() {
    switch (widget.event['type']) {
      case 'Conference':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'Workshop':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'Meeting':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'Launch':
        return AppTheme.getWarningColor(true);
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }
}
