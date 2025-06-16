import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

// lib/presentation/chat_interface/widgets/chat_header_widget.dart

class ChatHeaderWidget extends StatelessWidget {
  final String title;
  final bool isGroupChat;
  final int? participantCount;
  final bool isOnline;
  final VoidCallback onMenuPressed;

  const ChatHeaderWidget({
    super.key,
    required this.title,
    required this.isGroupChat,
    this.participantCount,
    required this.isOnline,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 1,
      shadowColor: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
      leading: IconButton(
        icon: const CustomIconWidget(
          iconName: 'arrow_back',
          size: 24,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isGroupChat
                  ? LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isGroupChat
                  ? null
                  : Theme.of(context).colorScheme.primaryContainer,
            ),
            child: isGroupChat
                ? CustomIconWidget(
                    iconName: 'group',
                    size: 5.w,
                    color: Colors.white,
                  )
                : Stack(
                    children: [
                      ClipOval(
                        child: CustomImageWidget(
                          imageUrl:
                              'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?w=150&h=150&fit=crop',
                          width: 10.w,
                          height: 10.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (isOnline)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 2.5.w,
                            height: 2.5.w,
                            decoration: BoxDecoration(
                              color: AppTheme.getSuccessColor(
                                  Theme.of(context).brightness ==
                                      Brightness.light),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  isGroupChat
                      ? '${participantCount ?? 0} participants'
                      : isOnline
                          ? 'Online'
                          : 'Last seen recently',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isOnline
                            ? AppTheme.getSuccessColor(
                                Theme.of(context).brightness ==
                                    Brightness.light)
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const CustomIconWidget(
            iconName: 'video_call',
            size: 24,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Video call feature to be implemented'),
              ),
            );
          },
        ),
        IconButton(
          icon: const CustomIconWidget(
            iconName: 'call',
            size: 24,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Voice call feature to be implemented'),
              ),
            );
          },
        ),
        IconButton(
          icon: const CustomIconWidget(
            iconName: 'more_vert',
            size: 24,
          ),
          onPressed: onMenuPressed,
        ),
      ],
    );
  }
}
