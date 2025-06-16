import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

// lib/presentation/chat_list/widgets/empty_chat_state_widget.dart

class EmptyChatStateWidget extends StatelessWidget {
  const EmptyChatStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'chat_bubble_outline',
                size: 15.w,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Start Your First Conversation',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Connect with event organizers and attendees to stay updated and engaged.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton(
              onPressed: () {
                // Implementation for creating new chat
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('New chat feature to be implemented'),
                  ),
                );
              },
              child: const Text('Start New Chat'),
            ),
          ],
        ),
      ),
    );
  }
}
