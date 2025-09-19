import 'package:json_annotation/json_annotation.dart';

part 'app_user.g.dart';

@JsonSerializable()
class AppUser {
  final String id;
  final String email;
  final String displayName;
  final String bio;
  final int age;
  final List<String> profileImages;
  final UserLocation? location;
  final UserPreferences preferences;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime lastSeen;
  final bool isOnline;

  const AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.bio,
    required this.age,
    required this.profileImages,
    this.location,
    required this.preferences,
    required this.isVerified,
    required this.createdAt,
    required this.lastSeen,
    required this.isOnline,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) => _$AppUserFromJson(map);
  Map<String, dynamic> toMap() => _$AppUserToJson(this);

  AppUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? bio,
    int? age,
    List<String>? profileImages,
    UserLocation? location,
    UserPreferences? preferences,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? lastSeen,
    bool? isOnline,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      age: age ?? this.age,
      profileImages: profileImages ?? this.profileImages,
      location: location ?? this.location,
      preferences: preferences ?? this.preferences,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

@JsonSerializable()
class UserLocation {
  final double latitude;
  final double longitude;
  final String? address;
  final DateTime timestamp;

  const UserLocation({
    required this.latitude,
    required this.longitude,
    this.address,
    required this.timestamp,
  });

  factory UserLocation.fromMap(Map<String, dynamic> map) => _$UserLocationFromJson(map);
  Map<String, dynamic> toMap() => _$UserLocationToJson(this);
}

@JsonSerializable()
class UserPreferences {
  final int minAge;
  final int maxAge;
  final double maxDistance;
  final List<String> interests;
  final String lookingFor;
  final bool showLocation;
  final bool showOnlineStatus;
  final bool allowMessagesFromAll;

  const UserPreferences({
    this.minAge = 18,
    this.maxAge = 99,
    this.maxDistance = 50.0,
    this.interests = const [],
    this.lookingFor = 'friends',
    this.showLocation = true,
    this.showOnlineStatus = true,
    this.allowMessagesFromAll = false,
  });

  factory UserPreferences.fromMap(Map<String, dynamic> map) => _$UserPreferencesFromJson(map);
  Map<String, dynamic> toMap() => _$UserPreferencesToJson(this);

  UserPreferences copyWith({
    int? minAge,
    int? maxAge,
    double? maxDistance,
    List<String>? interests,
    String? lookingFor,
    bool? showLocation,
    bool? showOnlineStatus,
    bool? allowMessagesFromAll,
  }) {
    return UserPreferences(
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      maxDistance: maxDistance ?? this.maxDistance,
      interests: interests ?? this.interests,
      lookingFor: lookingFor ?? this.lookingFor,
      showLocation: showLocation ?? this.showLocation,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      allowMessagesFromAll: allowMessagesFromAll ?? this.allowMessagesFromAll,
    );
  }
}