class ChatMessageModel {
  final int? id;
  final String? chatId;
  final String senderId;
  final String recipientId;
  final String content;
  final DateTime? timestamp;

  ChatMessageModel({
    this.id,
    this.chatId,
    required this.senderId,
    required this.recipientId,
    required this.content,
    this.timestamp,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      recipientId: json['recipientId'],
      content: json['content'],
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'recipientId': recipientId,
      'content': content,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}