import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/chat_preview_card_widget.dart';
import './widgets/chat_search_header_widget.dart';
import './widgets/empty_chat_state_widget.dart';

// lib/presentation/chat_list/chat_list.dart

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final TextEditingController _searchController = TextEditingController();
  List<ChatConversation> _conversations = [];
  List<ChatConversation> _filteredConversations = [];
  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadConversations();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _isSearching = query.isNotEmpty;
      _filteredConversations = _conversations.where((conversation) {
        return conversation.title.toLowerCase().contains(query) ||
            conversation.lastMessage.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _loadConversations() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _conversations = _getMockConversations();
        _filteredConversations = _conversations;
        _isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    await _loadConversations();
  }

  void _onConversationTap(ChatConversation conversation) {
    Navigator.pushNamed(
      context,
      AppRoutes.chatInterface,
      arguments: {
        'conversationId': conversation.id,
        'conversationTitle': conversation.title,
        'isGroupChat': conversation.isGroupChat,
      },
    );
  }

  void _onNewChatPressed() {
    // Implementation for creating new chat
    // This would typically show a contact picker or group creation flow
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New chat feature to be implemented'),
      ),
    );
  }

  void _onArchiveConversation(ChatConversation conversation) {
    setState(() {
      _conversations.removeWhere((c) => c.id == conversation.id);
      _filteredConversations.removeWhere((c) => c.id == conversation.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${conversation.title} archived'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _conversations.insert(0, conversation);
              _filteredConversations = _isSearching
                  ? _conversations
                      .where((c) =>
                          c.title
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase()) ||
                          c.lastMessage
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase()))
                      .toList()
                  : _conversations;
            });
          },
        ),
      ),
    );
  }

  void _onMuteConversation(ChatConversation conversation) {
    setState(() {
      final index = _conversations.indexWhere((c) => c.id == conversation.id);
      if (index != -1) {
        _conversations[index] =
            conversation.copyWith(isMuted: !conversation.isMuted);
        _filteredConversations = _isSearching
            ? _conversations
                .where((c) =>
                    c.title
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()) ||
                    c.lastMessage
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()))
                .toList()
            : _conversations;
      }
    });
  }

  void _onDeleteConversation(ChatConversation conversation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Conversation'),
        content: Text(
            'Are you sure you want to delete "${conversation.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _conversations.removeWhere((c) => c.id == conversation.id);
                _filteredConversations
                    .removeWhere((c) => c.id == conversation.id);
              });
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Chats'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const CustomIconWidget(
              iconName: 'more_vert',
              size: 24,
            ),
            onPressed: () {
              // Show menu with archive section, settings, etc.
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ChatSearchHeaderWidget(
            controller: _searchController,
            onClear: () {
              _searchController.clear();
            },
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _conversations.isEmpty
                    ? const EmptyChatStateWidget()
                    : RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: ListView.builder(
                          itemCount: _filteredConversations.length,
                          itemBuilder: (context, index) {
                            final conversation = _filteredConversations[index];
                            return ChatPreviewCardWidget(
                              conversation: conversation,
                              onTap: () => _onConversationTap(conversation),
                              onArchive: () =>
                                  _onArchiveConversation(conversation),
                              onMute: () => _onMuteConversation(conversation),
                              onDelete: () =>
                                  _onDeleteConversation(conversation),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onNewChatPressed,
        child: const CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
        ),
      ),
    );
  }

  List<ChatConversation> _getMockConversations() {
    return [
      ChatConversation(
        id: '1',
        title: 'Tech Conference 2024',
        lastMessage: 'Looking forward to the keynote tomorrow!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        unreadCount: 3,
        isGroupChat: true,
        participantAvatars: [
          'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?w=150&h=150&fit=crop',
          'https://images.pixabay.com/photo/2016/11/29/13/14/attractive-1869761_1280.jpg?w=150&h=150&fit=crop',
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop',
        ],
        lastSenderName: 'Sarah',
        isOnline: true,
        isMuted: false,
      ),
      ChatConversation(
        id: '2',
        title: 'John Doe',
        lastMessage: 'Can we reschedule our meeting to 3 PM?',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        unreadCount: 1,
        isGroupChat: false,
        participantAvatars: [
          'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?w=150&h=150&fit=crop',
        ],
        lastSenderName: 'John',
        isOnline: true,
        isMuted: false,
      ),
      ChatConversation(
        id: '3',
        title: 'Event Planning Team',
        lastMessage: 'The venue has been confirmed for Saturday',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        unreadCount: 0,
        isGroupChat: true,
        participantAvatars: [
          'https://images.pixabay.com/photo/2017/11/02/14/27/model-2911363_1280.jpg?w=150&h=150&fit=crop',
          'https://images.unsplash.com/photo-1494790108755-2616b60a2a6a?w=150&h=150&fit=crop',
          'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?w=150&h=150&fit=crop',
          'https://images.pixabay.com/photo/2016/11/21/12/42/beard-1845166_1280.jpg?w=150&h=150&fit=crop',
        ],
        lastSenderName: 'Emily',
        isOnline: false,
        isMuted: false,
      ),
      ChatConversation(
        id: '4',
        title: 'Marketing Discussion',
        lastMessage: 'Great work on the campaign everyone! 🎉',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 0,
        isGroupChat: true,
        participantAvatars: [
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop',
          'https://images.pexels.com/photo/1181686/pexels-photo-1181686.jpeg?w=150&h=150&fit=crop',
        ],
        lastSenderName: 'Mike',
        isOnline: false,
        isMuted: true,
      ),
      ChatConversation(
        id: '5',
        title: 'Alice Smith',
        lastMessage: 'Thanks for the update!',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        unreadCount: 0,
        isGroupChat: false,
        participantAvatars: [
          'https://images.pixabay.com/photo/2018/01/21/14/16/woman-3096664_1280.jpg?w=150&h=150&fit=crop',
        ],
        lastSenderName: 'Alice',
        isOnline: false,
        isMuted: false,
      ),
    ];
  }
}

class ChatConversation {
  final String id;
  final String title;
  final String lastMessage;
  final DateTime timestamp;
  final int unreadCount;
  final bool isGroupChat;
  final List<String> participantAvatars;
  final String lastSenderName;
  final bool isOnline;
  final bool isMuted;

  const ChatConversation({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
    required this.isGroupChat,
    required this.participantAvatars,
    required this.lastSenderName,
    required this.isOnline,
    required this.isMuted,
  });

  ChatConversation copyWith({
    String? id,
    String? title,
    String? lastMessage,
    DateTime? timestamp,
    int? unreadCount,
    bool? isGroupChat,
    List<String>? participantAvatars,
    String? lastSenderName,
    bool? isOnline,
    bool? isMuted,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      title: title ?? this.title,
      lastMessage: lastMessage ?? this.lastMessage,
      timestamp: timestamp ?? this.timestamp,
      unreadCount: unreadCount ?? this.unreadCount,
      isGroupChat: isGroupChat ?? this.isGroupChat,
      participantAvatars: participantAvatars ?? this.participantAvatars,
      lastSenderName: lastSenderName ?? this.lastSenderName,
      isOnline: isOnline ?? this.isOnline,
      isMuted: isMuted ?? this.isMuted,
    );
  }
}
