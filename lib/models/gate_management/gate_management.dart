class OtpModel {
  OtpModel({
    required this.id,
    required this.otp,
    required this.residentId,
    required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OtpModel.fromJson(Map<String, dynamic> json) {
    return OtpModel(
      id: json['id'] as int,
      otp: json['otp'] as String,
      residentId: json['resident_id'] as int,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  final int id;
  final String otp;
  final int residentId;
  final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;
}
