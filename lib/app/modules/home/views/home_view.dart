import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:soulsync_frontend/app/modules/auth/controllers/auth_controller.dart';
import 'package:soulsync_frontend/app/modules/home/controllers/home_controller.dart';
import 'package:soulsync_frontend/app/modules/chat/controllers/chat_controller.dart';
import 'package:soulsync_frontend/app/data/models/user_model.dart';
import 'package:soulsync_frontend/app/modules/profile/controllers/profile_controller.dart';
import 'package:soulsync_frontend/app/routes/app_routes.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});
  final authController = Get.find<AuthController>();
  final profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SoulSync'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: controller.navigateToLikedUsers,
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: controller.navigateToDates,
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: controller.navigateToNotifications,
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Obx(() {
        if (controller.currentTabIndex.value == 0) {
          // Home Tab
          if (controller.isLoading.value && controller.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.users.isEmpty) {
            return const Center(child: Text('No more users to show'));
          }

          return _buildUserCard(context);
        } else {
          // Chat Tab
          return _buildChatContent();
        }
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentTabIndex.value,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
          ],
          onTap: (index) {
            controller.changeTab(index);
          },
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFE91E63)),
            child: Text(
              'SoulSync',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: controller.navigateToProfile,
          ),
          ListTile(
            leading: const Icon(Icons.date_range),
            title: const Text('Date Requests'),
            onTap: controller.navigateToDateRequests,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await authController.logout().then((_) {
                Get.back(); // Close the drawer after logout
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete Account'),
            onTap: () {
              Get.defaultDialog(
                title: 'Delete Account',
                middleText: 'Are you sure you want to delete your account?',
                confirm: Obx(
                  () => ElevatedButton(
                    onPressed:
                        authController.isLoading.value
                            ? null
                            : () async {
                              await authController.deleteAccount().then((_) {
                                Get.back(); // Close the dialog
                              });
                            },
                    child:
                        authController.isLoading.value
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Text('Delete'),
                  ),
                ),
                cancel: Obx(
                  () => TextButton(
                    onPressed:
                        authController.isLoading.value
                            ? null
                            : () => Get.back(),
                    child:
                        authController.isLoading.value
                            ? Text(
                              'Cancel',
                              style: TextStyle(color: Colors.grey[400]),
                            )
                            : const Text('Cancel'),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(BuildContext context) {
    return Obx(() {
      if (controller.currentUserIndex.value >= controller.users.length) {
        return const Center(child: CircularProgressIndicator());
      }

      final user = controller.users[controller.currentUserIndex.value];

      return GestureDetector(
        onTap: () {
          if (!profileController.isFormValid) {
            Get.snackbar(
              'Incomplete Profile',
              'Please complete your profile to view user details.',
              snackPosition: SnackPosition.TOP,
            );
            return;
          }
          controller.viewUserDetails(user);
        },
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child:
                              user.profileImageUrl != null
                                  ? CachedNetworkImage(
                                    imageUrl: user.profileImageUrl!,
                                    fit: BoxFit.cover,
                                    placeholder:
                                        (context, url) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                    errorWidget:
                                        (context, url, error) => Container(
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.person,
                                            size: 100,
                                            color: Colors.grey,
                                          ),
                                        ),
                                  )
                                  : Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.person,
                                      size: 100,
                                      color: Colors.grey,
                                    ),
                                  ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: PopupMenuButton<String>(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          onSelected: (value) {
                            if (value == 'report') {
                              if (!profileController.isFormValid) {
                                Get.snackbar(
                                  'Incomplete Profile',
                                  'Please complete your profile to report ${user.name ?? 'this user'}.',
                                  snackPosition: SnackPosition.TOP,
                                );
                                return;
                              }
                              _showReportDialog(context, user);
                            }
                          },
                          itemBuilder:
                              (BuildContext context) => [
                                const PopupMenuItem<String>(
                                  value: 'report',
                                  child: Row(
                                    children: [
                                      Icon(Icons.report, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Report User'),
                                    ],
                                  ),
                                ),
                              ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${user.name ?? 'Unknown'}, ${user.age ?? 'N/A'}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (user.score != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${user.score}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (user.location != null)
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16),
                              const SizedBox(width: 4),
                              Text(user.location!),
                            ],
                          ),
                        const SizedBox(height: 8),
                        if (user.bio != null)
                          Text(
                            user.bio!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        heroTag: 'pass',
                        onPressed: controller.passUser,
                        backgroundColor: Colors.grey[300],
                        child: const Icon(Icons.close, color: Colors.grey),
                      ),
                      FloatingActionButton(
                        heroTag: 'like',
                        onPressed: () {
                          if (!profileController.isFormValid) {
                            Get.snackbar(
                              'Incomplete Profile',
                              'Please complete your profile to like ${user.name ?? 'this user'}.',
                              snackPosition: SnackPosition.TOP,
                            );
                            return;
                          }
                          controller.likeUser(user.id!);
                        },
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: const Icon(Icons.favorite, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildChatContent() {
    final ChatController chatController = Get.find<ChatController>();

    return Obx(() {
      if (chatController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (chatController.chatUsers.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No chats yet',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'Start liking users to begin chatting!',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: chatController.chatUsers.length,
        itemBuilder: (context, index) {
          final user = chatController.chatUsers[index];
          return ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  backgroundImage:
                      user.profileImageUrl != null
                          ? CachedNetworkImageProvider(user.profileImageUrl!)
                          : null,
                  child:
                      user.profileImageUrl == null
                          ? const Icon(Icons.person)
                          : null,
                ),
                // Online/Offline indicator
                if (user.status == 'ONLINE')
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            title: Text(user.name ?? 'Unknown'),
            subtitle: const Text('Tap to start chatting'),
            onTap: () {
              Get.toNamed(
                AppRoutes.chatRoom,
                arguments: {
                  'userId': user.id,
                  'userName': user.name,
                  'userStatus': user.status,
                },
              );
            },
          );
        },
      );
    });
  }

  void _showReportDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Report User'),
          content: Text(
            'Are you sure you want to report ${user.name ?? 'this user'}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.reportUser(user.id!, user.name ?? 'User');
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Report'),
            ),
          ],
        );
      },
    );
  }
}
