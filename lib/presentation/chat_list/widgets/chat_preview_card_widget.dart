import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';
import '../chat_list.dart';

// lib/presentation/chat_list/widgets/chat_preview_card_widget.dart

class ChatPreviewCardWidget extends StatelessWidget {
  final ChatConversation conversation;
  final VoidCallback onTap;
  final VoidCallback onArchive;
  final VoidCallback onMute;
  final VoidCallback onDelete;

  const ChatPreviewCardWidget({
    super.key,
    required this.conversation,
    required this.onTap,
    required this.onArchive,
    required this.onMute,
    required this.onDelete,
  });

  String _getRelativeTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${(difference.inDays / 7).floor()}w';
    }
  }

  Widget _buildAvatarStack(BuildContext context) {
    if (conversation.isGroupChat &&
        conversation.participantAvatars.length > 1) {
      return SizedBox(
        width: 12.w,
        height: 12.w,
        child: Stack(
          children: [
            if (conversation.participantAvatars.length >= 2)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: CustomImageWidget(
                      imageUrl: conversation.participantAvatars[1],
                      width: 8.w,
                      height: 8.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: conversation.participantAvatars[0],
                    width: 8.w,
                    height: 8.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Stack(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: CustomImageWidget(
                imageUrl: conversation.participantAvatars.isNotEmpty
                    ? conversation.participantAvatars[0]
                    : 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop',
                width: 12.w,
                height: 12.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (!conversation.isGroupChat && conversation.isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 3.w,
                height: 3.w,
                decoration: BoxDecoration(
                  color: AppTheme.getSuccessColor(
                      Theme.of(context).brightness == Brightness.light),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(conversation.id),
      background: Container(
        color: Colors.blue,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 4.w),
        child: const CustomIconWidget(
          iconName: 'archive',
          color: Colors.white,
          size: 24,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        child: const CustomIconWidget(
          iconName: 'delete',
          color: Colors.white,
          size: 24,
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onArchive();
          return false;
        } else {
          onDelete();
          return false;
        }
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
            child: Row(
              children: [
                _buildAvatarStack(context),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              conversation.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: conversation.unreadCount > 0
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (conversation.isMuted)
                                Padding(
                                  padding: EdgeInsets.only(right: 1.w),
                                  child: CustomIconWidget(
                                    iconName: 'notifications_off',
                                    size: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              Text(
                                _getRelativeTime(conversation.timestamp),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: conversation.unreadCount > 0
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                      fontWeight: conversation.unreadCount > 0
                                          ? FontWeight.w500
                                          : FontWeight.w400,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  if (conversation.isGroupChat)
                                    TextSpan(
                                      text: '${conversation.lastSenderName}: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  TextSpan(
                                    text: conversation.lastMessage,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: conversation.unreadCount > 0
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                          fontWeight:
                                              conversation.unreadCount > 0
                                                  ? FontWeight.w500
                                                  : FontWeight.w400,
                                        ),
                                  ),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (conversation.unreadCount > 0)
                            Container(
                              margin: EdgeInsets.only(left: 2.w),
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 5.w,
                              ),
                              child: Text(
                                conversation.unreadCount > 99
                                    ? '99+'
                                    : conversation.unreadCount.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 2.w),
                GestureDetector(
                  onTap: () {
                    _showQuickActions(context);
                  },
                  child: CustomIconWidget(
                    iconName: 'more_vert',
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'archive',
                size: 24,
              ),
              title: const Text('Archive'),
              onTap: () {
                Navigator.pop(context);
                onArchive();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: conversation.isMuted
                    ? 'notifications'
                    : 'notifications_off',
                size: 24,
              ),
              title: Text(conversation.isMuted ? 'Unmute' : 'Mute'),
              onTap: () {
                Navigator.pop(context);
                onMute();
              },
            ),
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'delete',
                size: 24,
                color: Colors.red,
              ),
              title: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }
}