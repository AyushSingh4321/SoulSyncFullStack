import 'dart:convert';

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
        url: 'ws://10.0.2.2:8080/ws',
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
    _stompClient!.subscribe(
      // destination: '/user/$userId/queue/messages',
      destination: '/user/queue/messages',
      callback: (frame) {
        print('Received message: ${frame.body}');

        // Parse and call the callback
        if (onMessageReceived != null && frame.body != null) {
          try{
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
    final currentUserId = _storageService.userId;
    final message = {
      'senderId': currentUserId,
      'recipientId': recipientId,
      'content': content,
    };

    _stompClient!.send(destination: '/app/chat', body: jsonEncode(message));
  }

  void disconnect() {
    _stompClient?.deactivate();
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }

  // Method to set callback
  void setMessageCallback(Function(Map<String, dynamic>) callback) {
    onMessageReceived = callback;
  }
}
