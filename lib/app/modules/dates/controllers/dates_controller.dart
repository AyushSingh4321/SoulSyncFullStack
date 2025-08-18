import 'dart:convert';
import 'package:get/get.dart';
import 'package:soulsync_frontend/app/core/constants/api_constants.dart';
import 'package:soulsync_frontend/app/data/services/api_service.dart';
import 'package:soulsync_frontend/app/data/services/storage_service.dart';
import 'package:soulsync_frontend/app/data/models/date_request_model.dart';

class DatesController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  final acceptedDates = <DateRequestModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAcceptedDates();
  }

  // Get the other person's name (not the current user)
  String getOtherPersonName(DateRequestModel date) {
    final currentUserId = int.tryParse(_storageService.userId ?? '0') ?? 0;

    if (date.senderId == currentUserId) {
      // Current user is the sender, show receiver's name
      return date.receiverName ?? 'Unknown';
    } else {
      // Current user is the receiver, show sender's name
      return date.senderName ?? 'Unknown';
    }
  }

  Future<void> loadAcceptedDates() async {
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

        acceptedDates.assignAll(
          allRequests.where((request) => request.status == 'ACCEPTED').toList(),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dates: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
