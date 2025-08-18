import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soulsync_frontend/app/modules/date_requests/controllers/date_requests_controller.dart';

class DateRequestsView extends GetView<DateRequestsController> {
  const DateRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Date Requests'),
          bottom: const TabBar(
            tabs: [Tab(text: 'To Respond'), Tab(text: 'All Requests')],
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            children: [_buildReceivedRequests(), _buildSentRequests()],
          );
        }),
      ),
    );
  }

  Widget _buildReceivedRequests() {
    // Get all requests (both sent and received) but show ones where current user can respond
    final allRequests = [
      ...controller.receivedRequests,
      ...controller.sentRequests,
    ];
    final requestsToRespond =
        allRequests
            .where(
              (request) =>
                  request.status == 'PENDING' &&
                  controller.canCurrentUserRespond(request),
            )
            .toList();

    if (requestsToRespond.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No pending requests to respond to',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requestsToRespond.length,
      itemBuilder: (context, index) {
        final request = requestsToRespond[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'From: ${controller.getOtherPersonName(request)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(request.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        request.status ?? 'PENDING',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Show who last edited the request
                if (request.sentByReceiver != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          request.sentByReceiver!
                              ? Colors.blue[100]
                              : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          request.sentByReceiver! ? Icons.edit : Icons.send,
                          size: 14,
                          color:
                              request.sentByReceiver!
                                  ? Colors.blue
                                  : Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          request.sentByReceiver!
                              ? 'You edited this request'
                              : 'Original request from ${controller.getOtherPersonName(request)}',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                request.sentByReceiver!
                                    ? Colors.blue
                                    : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                _buildRequestDetail(Icons.calendar_today, 'Date', request.date),
                _buildRequestDetail(Icons.access_time, 'Time', request.time),
                _buildRequestDetail(Icons.location_on, 'Venue', request.venue),

                // Action buttons for pending requests
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => controller.rejectRequest(request.id!),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Reject'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            () => controller.showEditRequestDialog(request),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => controller.acceptRequest(request.id!),
                        child: const Text('Accept'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSentRequests() {
    // Get all requests (both sent and received) from current user's perspective
    final allRequests = [
      ...controller.receivedRequests,
      ...controller.sentRequests,
    ];

    if (allRequests.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No date requests yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allRequests.length,
      itemBuilder: (context, index) {
        final request = allRequests[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'To: ${controller.getOtherPersonName(request)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(request.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        request.status ?? 'PENDING',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Show who last edited the request
                if (request.sentByReceiver != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          request.sentByReceiver!
                              ? Colors.blue[100]
                              : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          request.sentByReceiver! ? Icons.edit : Icons.send,
                          size: 14,
                          color:
                              request.sentByReceiver!
                                  ? Colors.blue
                                  : Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          request.sentByReceiver!
                              ? 'Last edited by ${controller.getOtherPersonName(request)}'
                              : controller.isCurrentUserSender(request)
                              ? 'You sent this request'
                              : '${controller.getOtherPersonName(request)} sent this request',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                request.sentByReceiver!
                                    ? Colors.blue
                                    : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                _buildRequestDetail(Icons.calendar_today, 'Date', request.date),
                _buildRequestDetail(Icons.access_time, 'Time', request.time),
                _buildRequestDetail(Icons.location_on, 'Venue', request.venue),

                // Show appropriate status message
                if (request.status == 'PENDING') ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          controller.canCurrentUserRespond(request)
                              ? Colors.orange[50]
                              : Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          controller.canCurrentUserRespond(request)
                              ? Icons.notifications_active
                              : Icons.schedule,
                          color:
                              controller.canCurrentUserRespond(request)
                                  ? Colors.orange[600]
                                  : Colors.blue[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.canCurrentUserRespond(request)
                                ? 'You need to respond to this request'
                                : 'Waiting for ${controller.getOtherPersonName(request)} to respond',
                            style: TextStyle(
                              color:
                                  controller.canCurrentUserRespond(request)
                                      ? Colors.orange[600]
                                      : Colors.blue[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRequestDetail(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'ACCEPTED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      case 'PENDING':
      default:
        return Colors.orange;
    }
  }
}
