class User {
  final String id;
  final String name;
  final int age;
  final String location;
  final String bio;
  final List<String> interests;
  final String profileImageUrl;
  final bool isOnline;
  final DateTime lastSeen;

  User({
    required this.id,
    required this.name,
    required this.age,
    required this.location,
    required this.bio,
    required this.interests,
    required this.profileImageUrl,
    required this.isOnline,
    required this.lastSeen,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      location: json['location'],
      bio: json['bio'],
      interests: List<String>.from(json['interests'] ?? []),
      profileImageUrl: json['profileImageUrl'] ?? '',
      isOnline: json['isOnline'] ?? false,
      lastSeen: DateTime.parse(json['lastSeen']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'location': location,
      'bio': bio,
      'interests': interests,
      'profileImageUrl': profileImageUrl,
      'isOnline': isOnline,
      'lastSeen': lastSeen.toIso8601String(),
    };
  }
}