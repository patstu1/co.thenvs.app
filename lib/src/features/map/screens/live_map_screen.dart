import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/theme/app_theme.dart';
import '../../auth/models/app_user.dart';

class LiveMapScreen extends ConsumerStatefulWidget {
  const LiveMapScreen({super.key});

  @override
  ConsumerState<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends ConsumerState<LiveMapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  bool _isLoading = true;

  // Mock nearby users
  final List<AppUser> _nearbyUsers = [
    AppUser(
      id: '1',
      email: 'user1@example.com',
      displayName: 'Alex',
      bio: 'Love hiking and good coffee ☕',
      age: 28,
      profileImages: ['https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400'],
      preferences: UserPreferences(),
      isVerified: true,
      createdAt: DateTime.now(),
      lastSeen: DateTime.now(),
      isOnline: true,
      location: UserLocation(
        latitude: 37.7849,
        longitude: -122.4194,
        timestamp: DateTime.now(),
      ),
    ),
    AppUser(
      id: '2',
      email: 'user2@example.com',
      displayName: 'Jordan',
      bio: 'Fitness enthusiast 💪',
      age: 25,
      profileImages: ['https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400'],
      preferences: UserPreferences(),
      isVerified: false,
      createdAt: DateTime.now(),
      lastSeen: DateTime.now(),
      isOnline: true,
      location: UserLocation(
        latitude: 37.7749,
        longitude: -122.4094,
        timestamp: DateTime.now(),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationError();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationError();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });

      _createMarkers();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showLocationError();
    }
  }

  void _createMarkers() {
    final markers = <Marker>{};

    // Add current user marker
    if (_currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_user'),
          position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          infoWindow: const InfoWindow(title: 'You are here'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    // Add nearby users markers
    for (final user in _nearbyUsers) {
      if (user.location != null) {
        markers.add(
          Marker(
            markerId: MarkerId(user.id),
            position: LatLng(user.location!.latitude, user.location!.longitude),
            infoWindow: InfoWindow(
              title: user.displayName,
              snippet: '${user.age} years old',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            onTap: () => _showUserDetails(user),
          ),
        );
      }
    }

    setState(() {
      _markers.clear();
      _markers.addAll(markers);
    });
  }

  void _showLocationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location permission is required to see nearby users'),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }

  void _showUserDetails(AppUser user) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(user.profileImages.first),
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
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${user.age}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (user.isVerified) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.verified,
                              size: 20,
                              color: AppTheme.primaryColor,
                            ),
                          ],
                        ],
                      ),
                      if (user.bio.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            user.bio,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.visibility),
                    label: const Text('View Profile'),
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Navigate to full profile
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.chat),
                    label: const Text('Say Hi'),
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Start conversation
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _currentPosition != null ? _centerOnCurrentLocation : null,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Getting your location...'),
                ],
              ),
            )
          : _currentPosition == null
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Location not available'),
                      SizedBox(height: 8),
                      Text(
                        'Please enable location services to see nearby users',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          _currentPosition!.latitude,
                          _currentPosition!.longitude,
                        ),
                        zoom: 14.0,
                      ),
                      markers: _markers,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      mapType: MapType.normal,
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                      },
                    ),
                    
                    // Legend
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Online Now',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_nearbyUsers.length} nearby',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _refreshNearbyUsers,
        icon: const Icon(Icons.refresh),
        label: const Text('Refresh'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _centerOnCurrentLocation() {
    if (_mapController != null && _currentPosition != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 16.0,
          ),
        ),
      );
    }
  }

  void _refreshNearbyUsers() {
    // TODO: Refresh nearby users from server
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refreshed nearby users')),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Map Filters',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            SwitchListTile(
              title: const Text('Show only online users'),
              subtitle: const Text('Hide users who are offline'),
              value: true,
              onChanged: (value) {
                // TODO: Toggle filter
              },
            ),
            
            SwitchListTile(
              title: const Text('Show verified users only'),
              subtitle: const Text('Only show verified profiles'),
              value: false,
              onChanged: (value) {
                // TODO: Toggle filter
              },
            ),
            
            const SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}