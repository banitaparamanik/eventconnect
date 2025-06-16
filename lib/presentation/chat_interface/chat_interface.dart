import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/chat_header_widget.dart';
import './widgets/chat_input_widget.dart';
import './widgets/chat_message_list_widget.dart';
import './widgets/typing_indicator_widget.dart';

// lib/presentation/chat_interface/chat_interface.dart

class ChatInterface extends StatefulWidget {
  final String conversationId;
  final String conversationTitle;
  final bool isGroupChat;

  const ChatInterface({
    super.key,
    required this.conversationId,
    required this.conversationTitle,
    required this.isGroupChat,
  });

  @override
  State<ChatInterface> createState() => _ChatInterfaceState();
}

class _ChatInterfaceState extends State<ChatInterface> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();

  List<ChatMessage> _messages = [];
  bool _isLoading = true;
  bool _isTyping = false;
  bool _isRecordingVoice = false;
  bool _showTypingIndicator = false;
  String _typingUsersText = '';

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _messageController.addListener(_onMessageChanged);
    _scrollController.addListener(_onScroll);

    // Simulate typing indicator
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showTypingIndicator = true;
          _typingUsersText = widget.isGroupChat
              ? 'Sarah is typing...'
              : '${widget.conversationTitle} is typing...';
        });

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _showTypingIndicator = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _messageController.removeListener(_onMessageChanged);
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _onMessageChanged() {
    final hasText = _messageController.text.trim().isNotEmpty;
    if (hasText != _isTyping) {
      setState(() {
        _isTyping = hasText;
      });
    }
  }

  void _onScroll() {
    // Load more messages when scrolling to top
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreMessages();
    }
  }

  Future<void> _loadMessages() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      setState(() {
        _messages = _getMockMessages();
        _isLoading = false;
      });

      // Scroll to bottom after loading
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  Future<void> _loadMoreMessages() async {
    // Simulate loading older messages
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      final olderMessages = _getOlderMockMessages();
      setState(() {
        _messages.addAll(olderMessages);
      });
    }
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'current_user',
      senderName: 'You',
      content: messageText,
      timestamp: DateTime.now(),
      type: MessageType.text,
      isFromCurrentUser: true,
      deliveryStatus: MessageDeliveryStatus.sent,
      senderAvatar:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop',
    );

    setState(() {
      _messages.insert(0, newMessage);
      _messageController.clear();
    });

    // Scroll to bottom
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    // Simulate message delivery and read receipts
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          final index = _messages.indexWhere((m) => m.id == newMessage.id);
          if (index != -1) {
            _messages[index] = _messages[index].copyWith(
              deliveryStatus: MessageDeliveryStatus.delivered,
            );
          }
        });
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          final index = _messages.indexWhere((m) => m.id == newMessage.id);
          if (index != -1) {
            _messages[index] = _messages[index].copyWith(
              deliveryStatus: MessageDeliveryStatus.read,
            );
          }
        });
      }
    });
  }

  void _onAttachmentPressed() {
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
            Text(
              'Choose Attachment',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  context,
                  'Camera',
                  'photo_camera',
                  Colors.pink,
                  () => _handleAttachment('camera'),
                ),
                _buildAttachmentOption(
                  context,
                  'Gallery',
                  'photo_library',
                  Colors.purple,
                  () => _handleAttachment('gallery'),
                ),
                _buildAttachmentOption(
                  context,
                  'Location',
                  'location_on',
                  Colors.green,
                  () => _handleAttachment('location'),
                ),
                _buildAttachmentOption(
                  context,
                  'File',
                  'attach_file',
                  Colors.blue,
                  () => _handleAttachment('file'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(
    BuildContext context,
    String label,
    String iconName,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: iconName,
              size: 7.w,
              color: color,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  void _handleAttachment(String type) {
    Navigator.pop(context);

    // Mock attachment handling
    String content = '';
    MessageType messageType = MessageType.text;

    switch (type) {
      case 'camera':
      case 'gallery':
        content =
            'https://images.pexels.com/photos/1051838/pexels-photo-1051838.jpeg?w=400&h=300&fit=crop';
        messageType = MessageType.image;
        break;
      case 'location':
        content = 'Current Location: 123 Main St, City, Country';
        messageType = MessageType.location;
        break;
      case 'file':
        content = 'document.pdf';
        messageType = MessageType.file;
        break;
    }

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'current_user',
      senderName: 'You',
      content: content,
      timestamp: DateTime.now(),
      type: messageType,
      isFromCurrentUser: true,
      deliveryStatus: MessageDeliveryStatus.sent,
      senderAvatar:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop',
    );

    setState(() {
      _messages.insert(0, newMessage);
    });

    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _startVoiceRecording() {
    setState(() {
      _isRecordingVoice = true;
    });

    // Mock voice recording
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isRecordingVoice) {
        _stopVoiceRecording();
      }
    });
  }

  void _stopVoiceRecording() {
    setState(() {
      _isRecordingVoice = false;
    });

    // Mock voice message
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'current_user',
      senderName: 'You',
      content: 'voice_message_3s.aac',
      timestamp: DateTime.now(),
      type: MessageType.voice,
      isFromCurrentUser: true,
      deliveryStatus: MessageDeliveryStatus.sent,
      senderAvatar:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop',
    );

    setState(() {
      _messages.insert(0, newMessage);
    });

    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: ChatHeaderWidget(
          title: widget.conversationTitle,
          isGroupChat: widget.isGroupChat,
          participantCount: widget.isGroupChat ? 5 : null,
          isOnline: !widget.isGroupChat,
          onMenuPressed: () {
            // Show chat options menu
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ChatMessageListWidget(
                    messages: _messages,
                    scrollController: _scrollController,
                    isGroupChat: widget.isGroupChat,
                  ),
          ),
          if (_showTypingIndicator)
            TypingIndicatorWidget(
              text: _typingUsersText,
            ),
          ChatInputWidget(
            controller: _messageController,
            focusNode: _messageFocusNode,
            isTyping: _isTyping,
            isRecordingVoice: _isRecordingVoice,
            onSendPressed: _sendMessage,
            onAttachmentPressed: _onAttachmentPressed,
            onVoiceRecordStart: _startVoiceRecording,
            onVoiceRecordStop: _stopVoiceRecording,
          ),
        ],
      ),
    );
  }

  List<ChatMessage> _getMockMessages() {
    return [
      ChatMessage(
        id: '1',
        senderId: 'sarah_123',
        senderName: 'Sarah',
        content: 'Looking forward to the keynote tomorrow! 🎤',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        type: MessageType.text,
        isFromCurrentUser: false,
        deliveryStatus: MessageDeliveryStatus.read,
        senderAvatar:
            'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?w=150&h=150&fit=crop',
      ),
      ChatMessage(
        id: '2',
        senderId: 'current_user',
        senderName: 'You',
        content: 'Me too! The speaker lineup looks amazing.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        type: MessageType.text,
        isFromCurrentUser: true,
        deliveryStatus: MessageDeliveryStatus.read,
        senderAvatar:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop',
      ),
      ChatMessage(
        id: '3',
        senderId: 'john_456',
        senderName: 'John',
        content:
            'https://images.pexels.com/photos/1181298/pexels-photo-1181298.jpeg?w=400&h=300&fit=crop',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        type: MessageType.image,
        isFromCurrentUser: false,
        deliveryStatus: MessageDeliveryStatus.read,
        senderAvatar:
            'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?w=150&h=150&fit=crop',
      ),
      ChatMessage(
        id: '4',
        senderId: 'emily_789',
        senderName: 'Emily',
        content: 'voice_message_5s.aac',
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        type: MessageType.voice,
        isFromCurrentUser: false,
        deliveryStatus: MessageDeliveryStatus.read,
        senderAvatar:
            'https://images.pixabay.com/photo/2017/11/02/14/27/model-2911363_1280.jpg?w=150&h=150&fit=crop',
      ),
      ChatMessage(
        id: '5',
        senderId: 'current_user',
        senderName: 'You',
        content: 'Great! See you all there 👋',
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        type: MessageType.text,
        isFromCurrentUser: true,
        deliveryStatus: MessageDeliveryStatus.read,
        senderAvatar:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop',
      ),
    ];
  }

  List<ChatMessage> _getOlderMockMessages() {
    return [
      ChatMessage(
        id: '6',
        senderId: 'mike_101',
        senderName: 'Mike',
        content: 'Hey everyone! Excited for the event',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: MessageType.text,
        isFromCurrentUser: false,
        deliveryStatus: MessageDeliveryStatus.read,
        senderAvatar:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop',
      ),
      ChatMessage(
        id: '7',
        senderId: 'current_user',
        senderName: 'You',
        content: 'Conference Location: 123 Tech Ave, Silicon Valley',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        type: MessageType.location,
        isFromCurrentUser: true,
        deliveryStatus: MessageDeliveryStatus.read,
        senderAvatar:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop',
      ),
    ];
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final bool isFromCurrentUser;
  final MessageDeliveryStatus deliveryStatus;
  final String senderAvatar;
  final String? replyToMessageId;
  final List<MessageReaction>? reactions;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    required this.type,
    required this.isFromCurrentUser,
    required this.deliveryStatus,
    required this.senderAvatar,
    this.replyToMessageId,
    this.reactions,
  });

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? content,
    DateTime? timestamp,
    MessageType? type,
    bool? isFromCurrentUser,
    MessageDeliveryStatus? deliveryStatus,
    String? senderAvatar,
    String? replyToMessageId,
    List<MessageReaction>? reactions,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isFromCurrentUser: isFromCurrentUser ?? this.isFromCurrentUser,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      reactions: reactions ?? this.reactions,
    );
  }
}

enum MessageType {
  text,
  image,
  voice,
  location,
  file,
}

enum MessageDeliveryStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

class MessageReaction {
  final String userId;
  final String emoji;
  final DateTime timestamp;

  const MessageReaction({
    required this.userId,
    required this.emoji,
    required this.timestamp,
  });
}
