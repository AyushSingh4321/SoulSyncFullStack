class DateRequestModel {
  final int? id;
  final String date;
  final String time;
  final String venue;
  final String? status;
  final int senderId;
  final String? senderName;
  final int receiverId;
  final String? receiverName;
  final bool? sentByReceiver;

  DateRequestModel({
    this.id,
    required this.date,
    required this.time,
    required this.venue,
    this.status,
    required this.senderId,
    this.senderName,
    required this.receiverId,
    this.receiverName,
    this.sentByReceiver,
  });

  factory DateRequestModel.fromJson(Map<String, dynamic> json) {
    return DateRequestModel(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      venue: json['venue'],
      status: json['status'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      receiverId: json['receiverId'],
      receiverName: json['receiverName'],
      sentByReceiver: json['sentByReceiver'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'time': time,
      'venue': venue,
    };
  }
}