import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentContactItemWidget extends StatelessWidget {
  final Map<String, dynamic> contact;
  final VoidCallback onTap;
  final VoidCallback onCall;
  final VoidCallback onMessage;
  final VoidCallback onAddToEvent;

  const RecentContactItemWidget({
    super.key,
    required this.contact,
    required this.onTap,
    required this.onCall,
    required this.onMessage,
    required this.onAddToEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(contact["id"].toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 6.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'phone',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 4.w),
            CustomIconWidget(
              iconName: 'message',
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 20,
            ),
            SizedBox(width: 4.w),
            CustomIconWidget(
              iconName: 'event_available',
              color: AppTheme.getSuccessColor(true),
              size: 20,
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        // Show action selection
        _showQuickActions(context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          leading: Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: ClipOval(
              child: CustomImageWidget(
                imageUrl: contact["avatar"] as String? ?? "",
                width: 12.w,
                height: 12.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            contact["name"] as String? ?? "Unknown Contact",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 0.5.h),
              Text(
                contact["role"] as String? ?? "No role",
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Text(
                "Last contact: ${contact["lastInteraction"] as String? ?? "Never"}",
                style: AppTheme.lightTheme.textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          trailing: PopupMenuButton<String>(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            onSelected: (value) {
              switch (value) {
                case 'call':
                  onCall();
                  break;
                case 'message':
                  onMessage();
                  break;
                case 'add_to_event':
                  onAddToEvent();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'call',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'phone',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 18,
                    ),
                    SizedBox(width: 3.w),
                    Text('Call'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'message',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'message',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 18,
                    ),
                    SizedBox(width: 3.w),
                    Text('Message'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'add_to_event',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'event_available',
                      color: AppTheme.getSuccessColor(true),
                      size: 18,
                    ),
                    SizedBox(width: 3.w),
                    Text('Add to Event'),
                  ],
                ),
              ),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
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
              'Quick Actions',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: 'phone',
                  label: 'Call',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  onTap: () {
                    Navigator.pop(context);
                    onCall();
                  },
                ),
                _buildActionButton(
                  icon: 'message',
                  label: 'Message',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  onTap: () {
                    Navigator.pop(context);
                    onMessage();
                  },
                ),
                _buildActionButton(
                  icon: 'event_available',
                  label: 'Add to Event',
                  color: AppTheme.getSuccessColor(true),
                  onTap: () {
                    Navigator.pop(context);
                    onAddToEvent();
                  },
                ),
              ],
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
