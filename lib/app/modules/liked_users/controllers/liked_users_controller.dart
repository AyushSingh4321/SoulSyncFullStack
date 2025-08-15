import 'dart:convert';
import 'package:get/get.dart';
import 'package:soulsync_frontend/app/core/constants/api_constants.dart';
import 'package:soulsync_frontend/app/data/services/api_service.dart';
import 'package:soulsync_frontend/app/data/models/user_model.dart';

class LikedUsersController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final likedUsers = <UserModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadLikedUsers();
  }

  Future<void> loadLikedUsers() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get(ApiConstants.liked);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        likedUsers.assignAll(data.map((json) => UserModel.fromJson(json)).toList());
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load liked users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> unlikeUser(int userId) async {
    try {
      final response = await _apiService.post('${ApiConstants.like}/$userId');
      
      if (response.statusCode == 200) {
        likedUsers.removeWhere((user) => user.id == userId);
        Get.snackbar('Success', 'User unliked');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to unlike user: $e');
    }
  }
}