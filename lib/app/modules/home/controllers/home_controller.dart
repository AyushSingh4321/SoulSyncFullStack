import 'dart:convert';
import 'package:get/get.dart';
import 'package:soulsync_frontend/app/core/constants/api_constants.dart';
import 'package:soulsync_frontend/app/data/services/api_service.dart';
import 'package:soulsync_frontend/app/data/models/user_model.dart';
import 'package:soulsync_frontend/app/routes/app_routes.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final users = <UserModel>[].obs;
  final currentUserIndex = 0.obs;
  final isLoading = false.obs;
  final currentPage = 0.obs;
  final pageSize = 5;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  Future<void> loadUsers({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 0;
      users.clear();
    }

    try {
      isLoading.value = true;
      final response = await _apiService.get(
        '${ApiConstants.discover}?page=${currentPage.value}&size=$pageSize',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final newUsers = data.map((json) => UserModel.fromJson(json)).toList();
        
        if (refresh) {
          users.assignAll(newUsers);
        } else {
          users.addAll(newUsers);
        }
        
        currentPage.value++;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> likeUser(int userId) async {
    try {
      final response = await _apiService.post('${ApiConstants.like}/$userId');
      
      if (response.statusCode == 200) {
        Get.snackbar('Success', response.body);
        _moveToNextUser();
      } else {
        Get.snackbar('Error', 'Failed to like user');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    }
  }

  void passUser() {
    _moveToNextUser();
  }

  void _moveToNextUser() {
    if (currentUserIndex.value < users.length - 1) {
      currentUserIndex.value++;
    } else {
      // Load more users when reaching the end
      loadUsers();
    }
  }

  void viewUserDetails(UserModel user) {
    Get.toNamed(AppRoutes.userDetails, arguments: user);
  }

  void navigateToLikedUsers() {
    Get.toNamed(AppRoutes.likedUsers);
  }

  void navigateToDates() {
    Get.toNamed(AppRoutes.dates);
  }

  void navigateToNotifications() {
    Get.toNamed(AppRoutes.notifications);
  }

  void navigateToProfile() {
    Get.toNamed(AppRoutes.profile);
  }

  void navigateToDateRequests() {
    Get.toNamed(AppRoutes.dateRequests);
  }

  void navigateToChat() {
    Get.toNamed(AppRoutes.chat);
  }
}