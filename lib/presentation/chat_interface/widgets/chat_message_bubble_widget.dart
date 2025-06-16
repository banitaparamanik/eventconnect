import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../chat_interface.dart';

// lib/presentation/chat_interface/widgets/chat_message_bubble_widget.dart

class ChatMessageBubbleWidget extends StatelessWidget {
  final ChatMessage message;
  final bool showAvatar;
  final bool showSenderName;
  final bool isGroupChat;

  const ChatMessageBubbleWidget({
    super.key,
    required this.message,
    required this.showAvatar,
    required this.showSenderName,
    required this.isGroupChat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 0.5.h),
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          if (!message.isFromCurrentUser) ...[
            // Avatar for received messages
            showAvatar
                ? Container(
                    width: 8.w,
                    height: 8.w,
                    margin: EdgeInsets.only(right: 2.w),
                    child: ClipOval(
                        child: CustomImageWidget(
                            imageUrl: message.senderAvatar,
                            width: 8.w,
                            height: 8.w,
                            fit: BoxFit.cover)))
                : SizedBox(width: 10.w), // Space for alignment
            Expanded(child: _buildMessageContent(context)),
            SizedBox(
                width: 15.w), // Space to prevent overlap with sent messages
          ] else ...[
            SizedBox(
                width: 15.w), // Space to prevent overlap with received messages
            Expanded(child: _buildMessageContent(context)),
          ],
        ]));
  }

  Widget _buildMessageContent(BuildContext context) {
    return Column(
        crossAxisAlignment: message.isFromCurrentUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (showSenderName && !message.isFromCurrentUser)
            Padding(
                padding: EdgeInsets.only(bottom: 0.5.h, left: 3.w),
                child: Text(message.senderName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500))),
          _buildMessageBubble(context),
          _buildMessageInfo(context),
        ]);
  }

  Widget _buildMessageBubble(BuildContext context) {
    final isCurrentUser = message.isFromCurrentUser;
    final bubbleColor = isCurrentUser
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.surface;
    final textColor = isCurrentUser
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurface;

    return Container(
        constraints: BoxConstraints(maxWidth: 75.w),
        decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isCurrentUser ? 16 : 4),
                bottomRight: Radius.circular(isCurrentUser ? 4 : 16)),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2)),
            ]),
        child: _buildMessageContentByType(context, textColor));
  }

  Widget _buildMessageContentByType(BuildContext context, Color textColor) {
    switch (message.type) {
      case MessageType.text:
        return _buildTextMessage(context, textColor);
      case MessageType.image:
        return _buildImageMessage(context);
      case MessageType.voice:
        return _buildVoiceMessage(context, textColor);
      case MessageType.location:
        return _buildLocationMessage(context, textColor);
      case MessageType.file:
        return _buildFileMessage(context, textColor);
    }
  }

  Widget _buildTextMessage(BuildContext context, Color textColor) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        child: Text(message.content,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: textColor)));
  }

  Widget _buildImageMessage(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isFromCurrentUser ? 16 : 4),
            bottomRight: Radius.circular(message.isFromCurrentUser ? 4 : 16)),
        child: CustomImageWidget(
            imageUrl: message.content,
            width: double.infinity,
            height: 40.h,
            fit: BoxFit.cover));
  }

  Widget _buildVoiceMessage(BuildContext context, Color textColor) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          CustomIconWidget(iconName: 'play_arrow', size: 6.w, color: textColor),
          SizedBox(width: 2.w),
          Container(
              width: 30.w,
              height: 4,
              decoration: BoxDecoration(
                  color: textColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2)),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      width: 15.w,
                      height: 4,
                      decoration: BoxDecoration(
                          color: textColor,
                          borderRadius: BorderRadius.circular(2))))),
          SizedBox(width: 2.w),
          Text('0:03',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: textColor)),
        ]));
  }

  Widget _buildLocationMessage(BuildContext context, Color textColor) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          CustomIconWidget(
              iconName: 'location_on', size: 5.w, color: textColor),
          SizedBox(width: 2.w),
          Flexible(
              child: Text(message.content,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: textColor))),
        ]));
  }

  Widget _buildFileMessage(BuildContext context, Color textColor) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          CustomIconWidget(
              iconName: 'attach_file', size: 5.w, color: textColor),
          SizedBox(width: 2.w),
          Flexible(
              child: Text(message.content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: textColor, decoration: TextDecoration.underline))),
        ]));
  }

  Widget _buildMessageInfo(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            top: 0.5.h,
            left: message.isFromCurrentUser ? 0 : 3.w,
            right: message.isFromCurrentUser ? 3.w : 0),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(_formatTime(message.timestamp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 10.sp)),
          if (message.isFromCurrentUser) ...[
            SizedBox(width: 1.w),
            _buildDeliveryStatus(context),
          ],
        ]));
  }

  Widget _buildDeliveryStatus(BuildContext context) {
    IconData iconData;
    Color iconColor = Theme.of(context).colorScheme.onSurfaceVariant;

    switch (message.deliveryStatus) {
      case MessageDeliveryStatus.sending:
        iconData = Icons.schedule;
        break;
      case MessageDeliveryStatus.sent:
        iconData = Icons.done;
        break;
      case MessageDeliveryStatus.delivered:
        iconData = Icons.done_all;
        break;
      case MessageDeliveryStatus.read:
        iconData = Icons.done_all;
        iconColor = Theme.of(context).colorScheme.primary;
        break;
      case MessageDeliveryStatus.failed:
        iconData = Icons.error;
        iconColor = Theme.of(context).colorScheme.error;
        break;
    }

    return Icon(iconData, size: 3.w, color: iconColor);
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }
}
