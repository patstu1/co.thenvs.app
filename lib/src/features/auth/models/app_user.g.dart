// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      bio: json['bio'] as String,
      age: json['age'] as int,
      profileImages: (json['profileImages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      location: json['location'] == null
          ? null
          : UserLocation.fromMap(json['location'] as Map<String, dynamic>),
      preferences:
          UserPreferences.fromMap(json['preferences'] as Map<String, dynamic>),
      isVerified: json['isVerified'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastSeen: DateTime.parse(json['lastSeen'] as String),
      isOnline: json['isOnline'] as bool,
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'bio': instance.bio,
      'age': instance.age,
      'profileImages': instance.profileImages,
      'location': instance.location?.toMap(),
      'preferences': instance.preferences.toMap(),
      'isVerified': instance.isVerified,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastSeen': instance.lastSeen.toIso8601String(),
      'isOnline': instance.isOnline,
    };

UserLocation _$UserLocationFromJson(Map<String, dynamic> json) => UserLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$UserLocationToJson(UserLocation instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'timestamp': instance.timestamp.toIso8601String(),
    };

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      minAge: json['minAge'] as int? ?? 18,
      maxAge: json['maxAge'] as int? ?? 99,
      maxDistance: (json['maxDistance'] as num?)?.toDouble() ?? 50.0,
      interests: (json['interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      lookingFor: json['lookingFor'] as String? ?? 'friends',
      showLocation: json['showLocation'] as bool? ?? true,
      showOnlineStatus: json['showOnlineStatus'] as bool? ?? true,
      allowMessagesFromAll: json['allowMessagesFromAll'] as bool? ?? false,
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'minAge': instance.minAge,
      'maxAge': instance.maxAge,
      'maxDistance': instance.maxDistance,
      'interests': instance.interests,
      'lookingFor': instance.lookingFor,
      'showLocation': instance.showLocation,
      'showOnlineStatus': instance.showOnlineStatus,
      'allowMessagesFromAll': instance.allowMessagesFromAll,
    };