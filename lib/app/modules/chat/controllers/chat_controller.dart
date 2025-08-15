import 'dart:convert';
import 'package:get/get.dart';
import 'package:soulsync_frontend/app/core/constants/api_constants.dart';
import 'package:soulsync_frontend/app/data/services/api_service.dart';
import 'package:soulsync_frontend/app/data/models/chat_message_model.dart';
import 'package:soulsync_frontend/app/data/models/user_model.dart';

class ChatController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final chatUsers = <UserModel>[].obs;
  final messages = <ChatMessageModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadChatUsers();
  }

  Future<void> loadChatUsers() async {
    try {
      isLoading.value = true;
      // This would typically load users you've chatted with
      // For now, we'll load liked users as potential chat partners
      final response = await _apiService.get(ApiConstants.liked);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        chatUsers.assignAll(data.map((json) => UserModel.fromJson(json)).toList());
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load chat users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMessages(String senderId, String recipientId) async {
    try {
      isLoading.value = true;
      final response = await _apiService.get(
        '${ApiConstants.messages}/$senderId/$recipientId',
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        messages.assignAll(data.map((json) => ChatMessageModel.fromJson(json)).toList());
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load messages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void sendMessage(String content, String recipientId) {
    // TODO: Implement WebSocket message sending
    final message = ChatMessageModel(
      senderId: 'currentUserId', // Get from storage
      recipientId: recipientId,
      content: content,
      timestamp: DateTime.now(),
    );
    
    messages.add(message);
  }
}