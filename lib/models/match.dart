class Match {
  final String id;
  final String userId;
  final String matchedUserId;
  final DateTime matchedAt;
  final double compatibilityScore;
  final bool isSuperLike;

  Match({
    required this.id,
    required this.userId,
    required this.matchedUserId,
    required this.matchedAt,
    required this.compatibilityScore,
    required this.isSuperLike,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      userId: json['userId'],
      matchedUserId: json['matchedUserId'],
      matchedAt: DateTime.parse(json['matchedAt']),
      compatibilityScore: json['compatibilityScore'].toDouble(),
      isSuperLike: json['isSuperLike'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'matchedUserId': matchedUserId,
      'matchedAt': matchedAt.toIso8601String(),
      'compatibilityScore': compatibilityScore,
      'isSuperLike': isSuperLike,
    };
  }
}