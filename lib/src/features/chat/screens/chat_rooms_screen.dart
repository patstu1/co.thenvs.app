import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../auth/models/app_user.dart';

class ChatRoomsScreen extends ConsumerStatefulWidget {
  const ChatRoomsScreen({super.key});

  @override
  ConsumerState<ChatRoomsScreen> createState() => _ChatRoomsScreenState();
}

class _ChatRoomsScreenState extends ConsumerState<ChatRoomsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock chat data
  final List<ChatRoom> _directChats = [
    ChatRoom(
      id: '1',
      type: ChatRoomType.direct,
      name: 'Alex',
      lastMessage: 'Hey! How was your day?',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
      participants: [
        AppUser(
          id: '1',
          email: 'alex@example.com',
          displayName: 'Alex',
          bio: 'Love hiking and good coffee ☕',
          age: 28,
          profileImages: ['https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400'],
          preferences: UserPreferences(),
          isVerified: true,
          createdAt: DateTime.now(),
          lastSeen: DateTime.now(),
          isOnline: true,
        ),
      ],
    ),
    ChatRoom(
      id: '2',
      type: ChatRoomType.direct,
      name: 'Jordan',
      lastMessage: 'Thanks for the workout tips! 💪',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
      participants: [
        AppUser(
          id: '2',
          email: 'jordan@example.com',
          displayName: 'Jordan',
          bio: 'Fitness enthusiast 💪',
          age: 25,
          profileImages: ['https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400'],
          preferences: UserPreferences(),
          isVerified: false,
          createdAt: DateTime.now(),
          lastSeen: DateTime.now().subtract(const Duration(minutes: 15)),
          isOnline: false,
        ),
      ],
    ),
  ];

  final List<ChatRoom> _groupChats = [
    ChatRoom(
      id: '3',
      type: ChatRoomType.group,
      name: 'SF Gay Hikers',
      description: 'Join us for weekend hikes around San Francisco!',
      lastMessage: 'Anyone free this Saturday?',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 30)),
      unreadCount: 5,
      participantCount: 24,
      isLive: true,
    ),
    ChatRoom(
      id: '4',
      type: ChatRoomType.group,
      name: 'Fitness Buddies',
      description: 'Motivation and workout tips for everyone',
      lastMessage: 'Great session today guys!',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
      unreadCount: 1,
      participantCount: 18,
      isLive: false,
    ),
  ];

  final List<ChatRoom> _liveRooms = [
    ChatRoom(
      id: '5',
      type: ChatRoomType.live,
      name: 'Coffee & Chat',
      description: 'Casual conversations over virtual coffee',
      lastMessage: '',
      lastMessageTime: DateTime.now(),
      unreadCount: 0,
      participantCount: 12,
      isLive: true,
      hasVideo: true,
    ),
    ChatRoom(
      id: '6',
      type: ChatRoomType.live,
      name: 'After Work Hangout',
      description: 'Unwind and meet new people',
      lastMessage: '',
      lastMessageTime: DateTime.now(),
      unreadCount: 0,
      participantCount: 8,
      isLive: true,
      hasVideo: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearch,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'create_group':
                  _createGroup();
                  break;
                case 'join_room':
                  _joinLiveRoom();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'create_group',
                child: Row(
                  children: [
                    Icon(Icons.group_add),
                    SizedBox(width: 12),
                    Text('Create Group'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'join_room',
                child: Row(
                  children: [
                    Icon(Icons.video_call),
                    SizedBox(width: 12),
                    Text('Join Live Room'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Direct',
              icon: Badge(
                label: Text('${_getUnreadCount(_directChats)}'),
                isLabelVisible: _getUnreadCount(_directChats) > 0,
                child: const Icon(Icons.person),
              ),
            ),
            Tab(
              text: 'Groups',
              icon: Badge(
                label: Text('${_getUnreadCount(_groupChats)}'),
                isLabelVisible: _getUnreadCount(_groupChats) > 0,
                child: const Icon(Icons.group),
              ),
            ),
            Tab(
              text: 'Live',
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.videocam),
                  const SizedBox(width: 4),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _DirectChatsTab(chats: _directChats),
          _GroupChatsTab(chats: _groupChats),
          _LiveRoomsTab(rooms: _liveRooms),
        ],
      ),
    );
  }

  int _getUnreadCount(List<ChatRoom> chats) {
    return chats.fold(0, (sum, chat) => sum + chat.unreadCount);
  }

  void _showSearch() {
    showSearch(
      context: context,
      delegate: ChatSearchDelegate(),
    );
  }

  void _createGroup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _CreateGroupSheet(),
    );
  }

  void _joinLiveRoom() {
    // TODO: Show live room selection
  }
}

class _DirectChatsTab extends StatelessWidget {
  final List<ChatRoom> chats;

  const _DirectChatsTab({required this.chats});

  @override
  Widget build(BuildContext context) {
    if (chats.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No conversations yet'),
            SizedBox(height: 8),
            Text(
              'Start matching to begin chatting!',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) => _ChatTile(chat: chats[index]),
    );
  }
}

class _GroupChatsTab extends StatelessWidget {
  final List<ChatRoom> chats;

  const _GroupChatsTab({required this.chats});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Featured Groups Header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'Featured Groups',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // TODO: Show all groups
                },
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) => _ChatTile(chat: chats[index]),
          ),
        ),
      ],
    );
  }
}

class _LiveRoomsTab extends StatelessWidget {
  final List<ChatRoom> rooms;

  const _LiveRoomsTab({required this.rooms});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Create Room Button
        Container(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Create Live Room'),
              onPressed: () {
                // TODO: Create live room
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) => _LiveRoomTile(room: rooms[index]),
          ),
        ),
      ],
    );
  }
}

class _ChatTile extends StatelessWidget {
  final ChatRoom chat;

  const _ChatTile({required this.chat});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: chat.type == ChatRoomType.group
                ? AppTheme.primaryColor
                : null,
            backgroundImage: chat.type == ChatRoomType.direct && chat.participants?.isNotEmpty == true
                ? NetworkImage(chat.participants!.first.profileImages.first)
                : null,
            child: chat.type == ChatRoomType.group
                ? const Icon(Icons.group, color: Colors.white)
                : null,
          ),
          if (chat.type == ChatRoomType.direct &&
              chat.participants?.isNotEmpty == true &&
              chat.participants!.first.isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppTheme.successColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          if (chat.isLive)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.fiber_manual_record,
                  size: 8,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              chat.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            _formatTime(chat.lastMessageTime),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (chat.description?.isNotEmpty == true)
            Text(
              chat.description!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          if (chat.lastMessage.isNotEmpty) ...[
            const SizedBox(height: 2),
            Row(
              children: [
                Expanded(
                  child: Text(
                    chat.lastMessage,
                    style: TextStyle(
                      fontWeight: chat.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
                      color: chat.unreadCount > 0 ? Colors.black : Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (chat.participantCount != null)
                  Row(
                    children: [
                      const Icon(Icons.people, size: 16, color: Colors.grey),
                      const SizedBox(width: 2),
                      Text(
                        '${chat.participantCount}',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ],
      ),
      trailing: chat.unreadCount > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${chat.unreadCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      onTap: () => _openChat(context, chat),
    );
  }

  void _openChat(BuildContext context, ChatRoom chat) {
    // TODO: Navigate to chat screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening chat: ${chat.name}')),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inMinutes}m';
    }
  }
}

class _LiveRoomTile extends StatelessWidget {
  final ChatRoom room;

  const _LiveRoomTile({required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _joinRoom(context, room),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  room.hasVideo ? Icons.videocam : Icons.mic,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            room.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      room.description ?? '',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.people, size: 16, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          '${room.participantCount} listening',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _joinRoom(BuildContext context, ChatRoom room) {
    // TODO: Join live room
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Joining room: ${room.name}')),
    );
  }
}

class _CreateGroupSheet extends StatefulWidget {
  const _CreateGroupSheet();

  @override
  State<_CreateGroupSheet> createState() => _CreateGroupSheetState();
}

class _CreateGroupSheetState extends State<_CreateGroupSheet> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Create Group',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Group Name',
              border: OutlineInputBorder(),
            ),
          ),
          
          const SizedBox(height: 16),
          
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          
          const SizedBox(height: 24),
          
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Create group
            },
            child: const Text('Create Group'),
          ),
        ],
      ),
    );
  }
}

class ChatSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: Implement search results
    return const Center(child: Text('Search results'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: Implement search suggestions
    return const Center(child: Text('Search suggestions'));
  }
}

enum ChatRoomType { direct, group, live }

class ChatRoom {
  final String id;
  final ChatRoomType type;
  final String name;
  final String? description;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final List<AppUser>? participants;
  final int? participantCount;
  final bool isLive;
  final bool hasVideo;

  ChatRoom({
    required this.id,
    required this.type,
    required this.name,
    this.description,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    this.participants,
    this.participantCount,
    this.isLive = false,
    this.hasVideo = false,
  });
}