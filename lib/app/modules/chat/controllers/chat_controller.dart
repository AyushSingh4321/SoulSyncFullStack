import 'dart:convert';
import 'package:get/get.dart';
import 'package:soulsync_frontend/app/core/constants/api_constants.dart';
import 'package:soulsync_frontend/app/data/models/chat_user_model.dart';
import 'package:soulsync_frontend/app/data/services/api_service.dart';
import 'package:soulsync_frontend/app/data/services/storage_service.dart';
import 'package:soulsync_frontend/app/data/models/chat_message_model.dart';
import 'package:soulsync_frontend/app/data/models/user_model.dart';
import 'package:soulsync_frontend/app/data/services/websocket_service.dart';

class ChatController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  // final chatUsers = <UserModel>[].obs;
  final chatUsers = <ChatUserModel>[].obs;
  final messages = <ChatMessageModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadChatUsers();

    // ADD THIS: Set up WebSocket message callback
    final webSocketService = Get.find<WebSocketService>();
    webSocketService.setMessageCallback((messageData) {
      final message = ChatMessageModel(
        senderId: messageData['senderId'],
        recipientId: messageData['recipientId'],
        content: messageData['content'],
        timestamp: DateTime.now(),
      );
      messages.add(message);
    });
  }

  Future<void> loadChatUsers() async {
    try {
      isLoading.value = true;
      // This would typically load users you've chatted with
      // For now, we'll load chatted users as potential chat partners
      final response = await _apiService.get(ApiConstants.chattedWith);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        chatUsers.assignAll(
          data.map((json) => ChatUserModel.fromJson(json)).toList(),
        );
      }
    } catch (e) {
      print('Error Failed to load chat users: $e');
      Get.snackbar('Error', 'Failed to load chat users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMessages(String senderId, String recipientId) async {
    try {
      isLoading.value = true;
      print('🔍 Loading messages for senderId: $senderId, recipientId: $recipientId');
      final url = '${ApiConstants.messages}/$senderId/$recipientId';
      print('🌐 API URL: $url');
      
      final response = await _apiService.get(url);
      
      print('📊 Response status: ${response.statusCode}');
      print('📝 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('📦 Parsed data length: ${data.length}');
        print('📦 Raw data: $data');
        
        messages.assignAll(
          data.map((json) => ChatMessageModel.fromJson(json)).toList(),
        );
        print('✅ Messages loaded successfully: ${messages.length} messages');
      } else {
        print('❌ Failed to load messages. Status: ${response.statusCode}');
        print('❌ Response body: ${response.body}');
      }
    } catch (e) {
      print('💥 Exception in loadMessages: $e');
      Get.snackbar('Error', 'Failed to load messages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshChatUsers() async {
    await loadChatUsers();
  }


  // Future<void> sendMessage(String content, String recipientId) async {
  //   try {
  //     final currentUserId = _storageService.userId;
  //     if (currentUserId == null) {
  //       Get.snackbar('Error', 'User not logged in');
  //       return;
  //     }

  //     // Create message object for API
  //     final messageData = {
  //       'senderId': currentUserId,
  //       'recipientId': recipientId,
  //       'content': content,
  //       'timestamp': DateTime.now().toIso8601String(),
  //     };

  //     // Send message to backend
  //     final response = await _apiService.post(
  //       ApiConstants.messages,
  //       body: messageData,
  //     );

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       // Add message to local list for immediate UI update
  //       final message = ChatMessageModel(
  //         senderId: currentUserId,
  //         recipientId: recipientId,
  //         content: content,
  //         timestamp: DateTime.now(),
  //       );
  //       messages.add(message);

  //       // Reload messages to get the latest from server
  //       await loadMessages(currentUserId, recipientId);
  //     } else {
  //       Get.snackbar('Error', 'Failed to send message');
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to send message: $e');
  //   }
  // }
  Future<void> sendMessage(String content, String recipientId) async {
    final webSocketService = Get.find<WebSocketService>();
    webSocketService.sendMessage(recipientId, content);

    // Add to local list for immediate UI update
    final currentUserId = _storageService.userId;
    if (currentUserId != null) {
      final message = ChatMessageModel(
        senderId: currentUserId,
        recipientId: recipientId,
        content: content,
        timestamp: DateTime.now(),
      );
      messages.add(message);
    }
  }
}
