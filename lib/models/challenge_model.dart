class ChallengeModel {
  final String challengeId;
  final String ownerId;
  final String name;
  final String description;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final double goalDistance;
  final DateTime createdAt;

  ChallengeModel({
    required this.challengeId,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.goalDistance,
    required this.createdAt,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      challengeId: json['challengeId'] as String,
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      goalDistance: (json['goalDistance'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'challengeId': challengeId,
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'type': type,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'goalDistance': goalDistance,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}