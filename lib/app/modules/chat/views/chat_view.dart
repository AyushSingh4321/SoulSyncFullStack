import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:soulsync_frontend/app/modules/chat/controllers/chat_controller.dart';
import 'package:soulsync_frontend/app/routes/app_routes.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.chatUsers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No chats yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Start liking users to begin chatting!',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.chatUsers.length,
          itemBuilder: (context, index) {
            final user = controller.chatUsers[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: user.profileImageUrl != null
                    ? CachedNetworkImageProvider(user.profileImageUrl!)
                    : null,
                child: user.profileImageUrl == null
                    ? const Icon(Icons.person)
                    : null,
              ),
              title: Text(user.name ?? 'Unknown'),
              subtitle: const Text('Tap to start chatting'),
              onTap: () {
                Get.toNamed(AppRoutes.chatRoom, arguments: {
                  'userId': user.id,
                  'userName': user.name,
                });
              },
            );
          },
        );
      }),
    );
  }
}