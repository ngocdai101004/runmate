class InvitationModel {
  final String invitationId;
  final String challengeId;
  final String email;
  final String status;
  final DateTime sentAt;

  InvitationModel({
    required this.invitationId,
    required this.challengeId,
    required this.email,
    required this.status,
    required this.sentAt,
  });

  factory InvitationModel.fromJson(Map<String, dynamic> json) {
    return InvitationModel(
      invitationId: json['invitationId'] as String,
      challengeId: json['challengeId'] as String,
      email: json['email'] as String,
      status: json['status'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invitationId': invitationId,
      'challengeId': challengeId,
      'email': email,
      'status': status,
      'sentAt': sentAt.toIso8601String(),
    };
  }
}
