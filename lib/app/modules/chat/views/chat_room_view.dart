import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soulsync_frontend/app/data/services/storage_service.dart';
import 'package:soulsync_frontend/app/modules/chat/controllers/chat_controller.dart';

class ChatRoomView extends GetView<ChatController> {
  const ChatRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = Get.find<StorageService>();
    final currentUserId = storageService.userId ?? '';
    final arguments = Get.arguments as Map<String, dynamic>;
    final userId = arguments['userId'] as String;
    final userName = arguments['userName'] as String?;
    final messageController = TextEditingController();

    // Load messages when entering chat room
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadMessages(currentUserId, userId);
    });

    if (currentUserId.isEmpty) {
      // Show an error, redirect, or prevent loading messages
      print('Error: currentUserId is not set!');
      // Optionally return a placeholder widget or redirect
    }

    return Scaffold(
      appBar: AppBar(title: Text(userName ?? 'Chat')),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                reverse: true,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages.reversed.toList()[index];
                  final isMe =
                      message.senderId == currentUserId; // Get from storage
                  print('vvvvvvvvvv ${message.senderId} ggggggggggg ${currentUserId}vvvvvvvvvv ${isMe}');

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          isMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isMe
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            message.content,
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  onPressed: () async {
                    if (messageController.text.trim().isNotEmpty) {
                      await controller.sendMessage(
                        messageController.text.trim(),
                        userId,
                      );
                      messageController.clear();
                    }
                  },
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
