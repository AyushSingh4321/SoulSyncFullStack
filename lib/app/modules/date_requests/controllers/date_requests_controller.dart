import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soulsync_frontend/app/core/constants/api_constants.dart';
import 'package:soulsync_frontend/app/data/services/api_service.dart';
import 'package:soulsync_frontend/app/data/models/date_request_model.dart';

class DateRequestsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final sentRequests = <DateRequestModel>[].obs;
  final receivedRequests = <DateRequestModel>[].obs;
  final isLoading = false.obs;

  // Form controllers for sending date request
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final venueController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadDateRequests();
    
    // Check if we need to show send date request form
    final arguments = Get.arguments;
    if (arguments != null && arguments['action'] == 'send') {
      _showSendDateRequestDialog(arguments['receiverId']);
    }
  }

  Future<void> loadDateRequests() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get(ApiConstants.allRequests);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final sent = data['sent'] as List<dynamic>;
        final received = data['received'] as List<dynamic>;
        
        sentRequests.assignAll(sent.map((json) => DateRequestModel.fromJson(json)).toList());
        receivedRequests.assignAll(received.map((json) => DateRequestModel.fromJson(json)).toList());
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load date requests: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendDateRequest(int receiverId) async {
    if (dateController.text.isEmpty || 
        timeController.text.isEmpty || 
        venueController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    try {
      final response = await _apiService.post(
        '${ApiConstants.sendDateRequest}/$receiverId',
        body: {
          'date': dateController.text,
          'time': timeController.text,
          'venue': venueController.text,
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Date request sent successfully');
        Get.back();
        loadDateRequests();
        _clearControllers();
      } else {
        Get.snackbar('Error', 'Failed to send date request');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    }
  }

  Future<void> respondToRequest(int requestId, String action) async {
    try {
      final response = await _apiService.post(
        '${ApiConstants.respondToRequest}/$requestId/respond?action=$action',
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Response sent successfully');
        loadDateRequests();
      } else {
        Get.snackbar('Error', 'Failed to respond to request');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    }
  }

  void _showSendDateRequestDialog(int receiverId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Send Date Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Date (YYYY-MM-DD)',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: Get.context!,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  dateController.text = date.toString().split(' ')[0];
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: 'Time (HH:MM)',
                prefixIcon: Icon(Icons.access_time),
              ),
              onTap: () async {
                final time = await showTimePicker(
                  context: Get.context!,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  timeController.text = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: venueController,
              decoration: const InputDecoration(
                labelText: 'Venue',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              _clearControllers();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => sendDateRequest(receiverId),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _clearControllers() {
    dateController.clear();
    timeController.clear();
    venueController.clear();
  }

  @override
  void onClose() {
    dateController.dispose();
    timeController.dispose();
    venueController.dispose();
    super.onClose();
  }
}