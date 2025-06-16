import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../chat_interface.dart';
import './chat_message_bubble_widget.dart';

// lib/presentation/chat_interface/widgets/chat_message_list_widget.dart

class ChatMessageListWidget extends StatelessWidget {
  final List<ChatMessage> messages;
  final ScrollController scrollController;
  final bool isGroupChat;

  const ChatMessageListWidget({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.isGroupChat,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'chat',
                size: 10.w,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Start the conversation',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      reverse: true,
      padding: EdgeInsets.symmetric(
        horizontal: 2.w,
        vertical: 1.h,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final previousMessage =
            index < messages.length - 1 ? messages[index + 1] : null;
        final nextMessage = index > 0 ? messages[index - 1] : null;

        final showAvatar = _shouldShowAvatar(message, nextMessage, isGroupChat);
        final showSenderName =
            _shouldShowSenderName(message, previousMessage, isGroupChat);
        final showDateHeader = _shouldShowDateHeader(message, previousMessage);

        return Column(
          children: [
            if (showDateHeader) _buildDateHeader(context, message.timestamp),
            ChatMessageBubbleWidget(
              message: message,
              showAvatar: showAvatar,
              showSenderName: showSenderName,
              isGroupChat: isGroupChat,
            ),
          ],
        );
      },
    );
  }

  bool _shouldShowAvatar(
      ChatMessage message, ChatMessage? nextMessage, bool isGroupChat) {
    if (message.isFromCurrentUser || !isGroupChat) return false;
    return nextMessage == null ||
        nextMessage.senderId != message.senderId ||
        nextMessage.isFromCurrentUser;
  }

  bool _shouldShowSenderName(
      ChatMessage message, ChatMessage? previousMessage, bool isGroupChat) {
    if (message.isFromCurrentUser || !isGroupChat) return false;
    return previousMessage == null ||
        previousMessage.senderId != message.senderId ||
        previousMessage.isFromCurrentUser;
  }

  bool _shouldShowDateHeader(
      ChatMessage message, ChatMessage? previousMessage) {
    if (previousMessage == null) return true;

    final messageDate = DateTime(
      message.timestamp.year,
      message.timestamp.month,
      message.timestamp.day,
    );
    final previousDate = DateTime(
      previousMessage.timestamp.year,
      previousMessage.timestamp.month,
      previousMessage.timestamp.day,
    );

    return !messageDate.isAtSameMomentAs(previousDate);
  }

  Widget _buildDateHeader(BuildContext context, DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate =
        DateTime(timestamp.year, timestamp.month, timestamp.day);

    String dateText;
    if (messageDate.isAtSameMomentAs(today)) {
      dateText = 'Today';
    } else if (messageDate.isAtSameMomentAs(yesterday)) {
      dateText = 'Yesterday';
    } else {
      dateText = '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 3.w,
            vertical: 0.5.h,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            dateText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }
}
