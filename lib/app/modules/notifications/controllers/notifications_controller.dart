import 'dart:convert';
import 'package:get/get.dart';
import 'package:soulsync_frontend/app/core/constants/api_constants.dart';
import 'package:soulsync_frontend/app/data/services/api_service.dart';
import 'package:soulsync_frontend/app/data/models/date_request_model.dart';

class NotificationsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final notifications = <DateRequestModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get(ApiConstants.allRequests);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final sent = data['sent'] as List<dynamic>;
        final received = data['received'] as List<dynamic>;
        
        final allRequests = [
          ...sent.map((json) => DateRequestModel.fromJson(json)),
          ...received.map((json) => DateRequestModel.fromJson(json)),
        ];
        
        // Filter for accepted or rejected requests (notifications)
        notifications.assignAll(
          allRequests.where((request) => 
            request.status == 'ACCEPTED' || request.status == 'REJECTED'
          ).toList(),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }
}