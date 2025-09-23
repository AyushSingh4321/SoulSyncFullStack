import 'dart:convert';

import 'package:soulsync_frontend/app/core/constants/api_constants.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:get/get.dart';
import 'package:soulsync_frontend/app/data/services/storage_service.dart';

class WebSocketService extends GetxService {
  StompClient? _stompClient;
  final StorageService _storageService = Get.find<StorageService>();

  // Callback property
  Function(Map<String, dynamic>)? onMessageReceived;

  Future<void> connect() async {
    final token = _storageService.token;

    _stompClient = StompClient(
      config: StompConfig(
        // url: 'ws://10.0.2.2:8080/ws',
        url: '${ApiConstants.wsUrl}',
        onConnect: onConnect,
        reconnectDelay: const Duration(seconds: 5),
        beforeConnect: () async {
          print('Connecting to WebSocket...');
        },
        onWebSocketError: (dynamic error) => print('WebSocket Error: $error'),
        stompConnectHeaders: {'Authorization': 'Bearer $token'},
        webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
      ),
    );

    _stompClient!.activate();
  }

  void onConnect(StompFrame frame) {
    print('Connected to WebSocket');
    final userId = _storageService.userId;
   if (userId != null) {
  setUserOnline(userId);
}
    _stompClient!.subscribe(
      // destination: '/user/$userId/queue/messages',
      destination: '/user/queue/messages',
      callback: (frame) {
        print('Received message: ${frame.body}');

        // Parse and call the callback
        if (onMessageReceived != null && frame.body != null) {
          try {
            final messageData = jsonDecode(frame.body!);
            onMessageReceived!(messageData);
          } catch (e) {
            print('Error parsing WebSocket message: $e');
          }
        }
      },
    );
  }

  void sendMessage(String recipientId, String content) {
    try {
      final currentUserId = _storageService.userId;
      final message = {
        'senderId': currentUserId,
        'recipientId': recipientId,
        'content': content,
      };

      _stompClient!.send(destination: '/app/chat', body: jsonEncode(message));
    } catch (e) {
      print('Error sending WebSocket message: $e');
    }
  }

  void disconnect() {
print('🔴 disconnect() called');
    final userId = _storageService.userId;
  if (userId != null) {
      print('🔴 Setting user $userId to OFFLINE');
    setUserOffline(userId);
  }
    _stompClient?.deactivate();
  }

  @override
  void onClose() {
      print('🔴 WebSocketService onClose() called');
    disconnect();
    super.onClose();
  }

  // Method to set callback
  void setMessageCallback(Function(Map<String, dynamic>) callback) {
    onMessageReceived = callback;
  }

  // In WebSocketService
void setUserOnline(String userId) {
  // _stompClient?.send(
  //   destination: '/app/user.connectUser',
  //   body: userId,
  // );
    try {
    if (_stompClient != null && _stompClient!.isActive) {
      _stompClient!.send(
        destination: '/app/user.connectUser',
        body: userId,
      );
      print('✅ Online message sent successfully');
    } else {
      print('⚠️ WebSocket not active, cannot send online message');
    }
  } catch (e) {
    print('❌ Error sending online message: $e');
  }
}

void setUserOffline(String userId) {
  // _stompClient?.send(
  //   destination: '/app/user.disconnectUser', 
  //   body: userId,
  // );
    try {
    if (_stompClient != null && _stompClient!.isActive) {
      _stompClient!.send(
        destination: '/app/user.disconnectUser', 
        body: userId,
      );
      print('✅ Offline message sent successfully');
    } else {
      print('⚠️ WebSocket not active, cannot send offline message');
    }
  } catch (e) {
    print('❌ Error sending offline message: $e');
  }
}
}
