class ChatUserModel {
  final String id;
  final String name;
  final String? status;
  final String? profileImageUrl;

  ChatUserModel({
    required this.id,
    required this.name,
    this.status,
    this.profileImageUrl,
  });

  factory ChatUserModel.fromJson(Map<String, dynamic> json) {
    return ChatUserModel(
      id: json['id'].toString(), // Convert to String in case it comes as int
      name: json['name'] ?? '',
      status: json['status']?.toString(),
      profileImageUrl: json['profileImageUrl'], // Make sure this is included
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'profileImageUrl': profileImageUrl,
    };
  }
}