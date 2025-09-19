import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../auth/models/app_user.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({super.key});

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock matches data
  final List<Match> _matches = [
    Match(
      user: AppUser(
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
      matchedAt: DateTime.now().subtract(const Duration(hours: 2)),
      compatibilityScore: 95,
      hasUnreadMessages: true,
      lastMessage: 'Hey! How\'s it going?',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Match(
      user: AppUser(
        id: '2',
        email: 'jordan@example.com',
        displayName: 'Jordan',
        bio: 'Fitness enthusiast 💪 Looking for workout buddy',
        age: 25,
        profileImages: ['https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400'],
        preferences: UserPreferences(),
        isVerified: false,
        createdAt: DateTime.now(),
        lastSeen: DateTime.now().subtract(const Duration(minutes: 15)),
        isOnline: false,
      ),
      matchedAt: DateTime.now().subtract(const Duration(days: 1)),
      compatibilityScore: 87,
      hasUnreadMessages: false,
      lastMessage: 'Thanks for the match! 😊',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 12)),
    ),
  ];

  final List<AppUser> _suggestions = [
    AppUser(
      id: '3',
      email: 'sam@example.com',
      displayName: 'Sam',
      bio: '🎨 Artist | 🌟 Creative soul',
      age: 30,
      profileImages: ['https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400'],
      preferences: UserPreferences(),
      isVerified: true,
      createdAt: DateTime.now(),
      lastSeen: DateTime.now(),
      isOnline: true,
    ),
    AppUser(
      id: '4',
      email: 'mike@example.com',
      displayName: 'Mike',
      bio: 'Adventure seeker 🏔️ Love the outdoors',
      age: 27,
      profileImages: ['https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400'],
      preferences: UserPreferences(),
      isVerified: false,
      createdAt: DateTime.now(),
      lastSeen: DateTime.now().subtract(const Duration(hours: 1)),
      isOnline: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('Matches'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Matches (${_matches.length})',
            ),
            Tab(
              text: 'Suggested (${_suggestions.length})',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _MatchesTab(matches: _matches),
          _SuggestionsTab(suggestions: _suggestions),
        ],
      ),
    );
  }
}

class _MatchesTab extends StatelessWidget {
  final List<Match> matches;

  const _MatchesTab({required this.matches});

  @override
  Widget build(BuildContext context) {
    if (matches.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_outline,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No matches yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Keep exploring to find your perfect match!',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];
        return _MatchCard(match: match);
      },
    );
  }
}

class _SuggestionsTab extends StatelessWidget {
  final List<AppUser> suggestions;

  const _SuggestionsTab({required this.suggestions});

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No suggestions available',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Check back later for AI-powered matches!',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final user = suggestions[index];
        return _SuggestionCard(user: user);
      },
    );
  }
}

class _MatchCard extends StatelessWidget {
  final Match match;

  const _MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openChat(context, match),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Profile Image with Match Badge
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(match.user.profileImages.first),
                  ),
                  if (match.user.isOnline)
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
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(width: 16),
              
              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            match.user.displayName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          _formatMatchTime(match.matchedAt),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Compatibility Score
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${match.compatibilityScore}% match',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Last Message
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            match.lastMessage ?? 'Start the conversation!',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: match.hasUnreadMessages ? Colors.black : Colors.grey,
                              fontWeight: match.hasUnreadMessages ? FontWeight.w500 : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (match.hasUnreadMessages)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openChat(BuildContext context, Match match) {
    // TODO: Navigate to chat screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening chat with ${match.user.displayName}')),
    );
  }

  String _formatMatchTime(DateTime matchTime) {
    final now = DateTime.now();
    final difference = now.difference(matchTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }
}

class _SuggestionCard extends StatelessWidget {
  final AppUser user;

  const _SuggestionCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // User Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user.profileImages.first),
                    ),
                    if (user.isOnline)
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
                  ],
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            user.displayName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${user.age}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          if (user.isVerified) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.verified,
                              size: 16,
                              color: AppTheme.primaryColor,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.bio,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      
                      // AI Match Reason
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.psychology,
                              size: 14,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'AI suggests: Similar interests',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Action Buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.visibility),
                    label: const Text('View'),
                    onPressed: () => _viewProfile(context, user),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.favorite),
                    label: const Text('Like'),
                    onPressed: () => _likeUser(context, user),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _viewProfile(BuildContext context, AppUser user) {
    // TODO: Navigate to profile screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing ${user.displayName}\'s profile')),
    );
  }

  void _likeUser(BuildContext context, AppUser user) {
    // TODO: Handle like action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Liked ${user.displayName}!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }
}

class Match {
  final AppUser user;
  final DateTime matchedAt;
  final int compatibilityScore;
  final bool hasUnreadMessages;
  final String? lastMessage;
  final DateTime? lastMessageTime;

  Match({
    required this.user,
    required this.matchedAt,
    required this.compatibilityScore,
    required this.hasUnreadMessages,
    this.lastMessage,
    this.lastMessageTime,
  });
}