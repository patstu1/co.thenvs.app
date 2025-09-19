import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../auth/models/app_user.dart';
import '../../core/theme/app_theme.dart';

class ProfileGridScreen extends ConsumerStatefulWidget {
  const ProfileGridScreen({super.key});

  @override
  ConsumerState<ProfileGridScreen> createState() => _ProfileGridScreenState();
}

class _ProfileGridScreenState extends ConsumerState<ProfileGridScreen> {
  final ScrollController _scrollController = ScrollController();
  
  // Mock data for demonstration
  final List<AppUser> _mockUsers = [
    AppUser(
      id: '1',
      email: 'user1@example.com',
      displayName: 'Alex',
      bio: 'Love hiking and good coffee ☕',
      age: 28,
      profileImages: [
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
      ],
      preferences: UserPreferences(interests: ['Hiking', 'Coffee']),
      isVerified: true,
      createdAt: DateTime.now(),
      lastSeen: DateTime.now().subtract(const Duration(minutes: 5)),
      isOnline: true,
      location: UserLocation(
        latitude: 37.7749,
        longitude: -122.4194,
        address: 'San Francisco, CA',
        timestamp: DateTime.now(),
      ),
    ),
    AppUser(
      id: '2',
      email: 'user2@example.com',
      displayName: 'Jordan',
      bio: 'Fitness enthusiast 💪 Looking for workout buddy',
      age: 25,
      profileImages: [
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
        'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400',
      ],
      preferences: UserPreferences(interests: ['Fitness', 'Music']),
      isVerified: false,
      createdAt: DateTime.now(),
      lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
      isOnline: false,
      location: UserLocation(
        latitude: 37.7849,
        longitude: -122.4094,
        address: 'San Francisco, CA',
        timestamp: DateTime.now(),
      ),
    ),
    AppUser(
      id: '3',
      email: 'user3@example.com',
      displayName: 'Sam',
      bio: '🎨 Artist | 🌟 Creative soul | Looking for meaningful connections',
      age: 30,
      profileImages: [
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400',
        'https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=400',
      ],
      preferences: UserPreferences(interests: ['Art', 'Photography']),
      isVerified: true,
      createdAt: DateTime.now(),
      lastSeen: DateTime.now().subtract(const Duration(minutes: 30)),
      isOnline: true,
      location: UserLocation(
        latitude: 37.7649,
        longitude: -122.4294,
        address: 'San Francisco, CA',
        timestamp: DateTime.now(),
      ),
    ),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'N',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text('NVS'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // TODO: Navigate to profile screen
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Refresh users data
          await Future.delayed(const Duration(seconds: 1));
        },
        child: GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: _mockUsers.length * 10, // Repeat for demo
          itemBuilder: (context, index) {
            final user = _mockUsers[index % _mockUsers.length];
            return _ProfileCard(user: user);
          },
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _FilterSheet(),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final AppUser user;
  
  const _ProfileCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Show profile details
        _showProfileDetails(context, user);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Profile Image
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: user.profileImages.first,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.person, size: 50),
                  ),
                ),
              ),
              
              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Online Status
              if (user.isOnline)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppTheme.successColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              
              // Verified Badge
              if (user.isVerified)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              
              // User Info
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              user.displayName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${user.age}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      if (user.bio.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            user.bio,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (user.location != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 12,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  '2.5 km away', // TODO: Calculate actual distance
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProfileDetails(BuildContext context, AppUser user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ProfileDetailSheet(user: user),
    );
  }
}

class _ProfileDetailSheet extends StatelessWidget {
  final AppUser user;
  
  const _ProfileDetailSheet({required this.user});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                // Profile Images
                SizedBox(
                  height: 300,
                  child: PageView.builder(
                    itemCount: user.profileImages.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: user.profileImages[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                
                // User Info
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              user.displayName,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '${user.age}',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      if (user.bio.isNotEmpty) ...[
                        Text(
                          user.bio,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      // Interests
                      if (user.preferences.interests.isNotEmpty) ...[
                        Text(
                          'Interests',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: user.preferences.interests.map((interest) {
                            return Chip(
                              label: Text(interest),
                              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.close),
                              label: const Text('Pass'),
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.favorite),
                              label: const Text('Like'),
                              onPressed: () {
                                Navigator.pop(context);
                                // TODO: Handle like action
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // TODO: Start chat
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentColor,
                              padding: const EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Icon(Icons.chat),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet();

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  RangeValues _ageRange = const RangeValues(18, 35);
  double _distance = 25.0;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Reset filters
                },
                child: const Text('Reset'),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'Age Range: ${_ageRange.start.round()} - ${_ageRange.end.round()}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          RangeSlider(
            values: _ageRange,
            min: 18,
            max: 99,
            divisions: 81,
            onChanged: (values) {
              setState(() {
                _ageRange = values;
              });
            },
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'Distance: ${_distance.round()} km',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Slider(
            value: _distance,
            min: 1,
            max: 100,
            divisions: 99,
            onChanged: (value) {
              setState(() {
                _distance = value;
              });
            },
          ),
          
          const SizedBox(height: 32),
          
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Apply filters
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Apply Filters'),
          ),
          
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}