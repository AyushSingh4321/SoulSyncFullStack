import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soulsync_frontend/app/core/constants/api_constants.dart';
import 'package:soulsync_frontend/app/data/services/api_service.dart';
import 'package:soulsync_frontend/app/data/services/storage_service.dart';
import 'package:soulsync_frontend/app/data/models/date_request_model.dart';

class DateRequestsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

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
    _checkAndFetchUserProfile(); // Ensure user profile is fetched
    loadDateRequests();

    // Check if we need to show send date request form
    final arguments = Get.arguments;
    if (arguments != null && arguments['action'] == 'send') {
      // Delay showing the dialog until after the build is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSendDateRequestDialog(arguments['receiverId']);
      });
    }
  }

  Future<void> _checkAndFetchUserProfile() async {
    final currentUserId = _storageService.userId;

    if (currentUserId == null || currentUserId.isEmpty) {
      await _fetchAndStoreUserProfile();
    }
  }

  Future<void> _fetchAndStoreUserProfile() async {
    try {
      final profileResponse = await _apiService.get(ApiConstants.myProfile);
      if (profileResponse.statusCode == 200) {
        final profileData = jsonDecode(profileResponse.body);
        final userId = profileData['id'].toString();
        await _storageService.setUserId(userId);
      }
    } catch (e) {
      print('⚠️ Error fetching user profile: $e');
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

        sentRequests.assignAll(
          sent.map((json) => DateRequestModel.fromJson(json)).toList(),
        );
        receivedRequests.assignAll(
          received.map((json) => DateRequestModel.fromJson(json)).toList(),
        );
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

  // Get the other person's name (not the current user)
  String getOtherPersonName(DateRequestModel request) {
    final currentUserId = int.tryParse(_storageService.userId ?? '0') ?? 0;

    if (request.senderId == currentUserId) {
      // Current user is the sender, show receiver's name
      return request.receiverName ?? 'Unknown';
    } else {
      // Current user is the receiver, show sender's name
      return request.senderName ?? 'Unknown';
    }
  }

  // Check if current user is the one who can respond/edit
  // Logic: Only show buttons to the person who needs to respond to the current state
  bool canCurrentUserRespond(DateRequestModel request) {
    final currentUserId = int.tryParse(_storageService.userId ?? '0') ?? 0;

    // If request is not pending, no one can respond
    if (request.status != 'PENDING') {
      return false;
    }

    // Logic: The person who DIDN'T take the last action should be able to respond
    bool canRespond;
    if (request.sentByReceiver == true) {
      // Receiver took the last action (edit), so sender should respond
      canRespond = request.senderId == currentUserId;
    } else {
      // Sender took the last action (original send or edit), so receiver should respond
      canRespond = request.receiverId == currentUserId;
    }

    return canRespond;
  }

  // Check if current user is the sender
  bool isCurrentUserSender(DateRequestModel request) {
    final currentUserId = int.tryParse(_storageService.userId ?? '0') ?? 0;
    return request.senderId == currentUserId;
  }

  // Accept a date request
  Future<void> acceptRequest(int requestId) async {
    try {
      isLoading.value = true;
      final response = await _apiService.post(
        '${ApiConstants.baseUrl}/dateRequest/$requestId/respond?action=accept',
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Date request accepted!');
        loadDateRequests(); // Reload to show updated status
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Failed to accept request',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Reject a date request
  Future<void> rejectRequest(int requestId) async {
    try {
      isLoading.value = true;
      final response = await _apiService.post(
        '${ApiConstants.baseUrl}/dateRequest/$requestId/respond?action=reject',
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Date request rejected');
        loadDateRequests(); // Reload to show updated status
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Failed to reject request',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Edit/Negotiate a date request
  Future<void> editRequest(
    int requestId,
    String date,
    String time,
    String venue,
  ) async {
    try {
      isLoading.value = true;
      final requestBody = {'date': date, 'time': time, 'venue': venue};

      final response = await _apiService.put(
        '${ApiConstants.baseUrl}/dateRequest/$requestId/edit',
        body: requestBody,
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Date request updated successfully!');
        loadDateRequests(); // Reload to show updated request
        Get.back(); // Close the edit dialog
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar('Error', errorData['message'] ?? 'Failed to edit request');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Show edit request dialog
  void showEditRequestDialog(DateRequestModel request) {
    // Pre-fill the form with current values
    dateController.text = request.date;
    timeController.text = request.time;
    venueController.text = request.venue;

    // Get the other person's name
    final otherPersonName = getOtherPersonName(request);

    Get.dialog(
      AlertDialog(
        title: Text('Edit Date Request with $otherPersonName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Date (YYYY-MM-DD)',
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: 'Time (HH:MM)',
                prefixIcon: Icon(Icons.access_time),
              ),
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
            onPressed:
                () => editRequest(
                  request.id!,
                  dateController.text,
                  timeController.text,
                  venueController.text,
                ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
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
                  timeController.text =
                      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
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
