import 'package:get/get.dart';
import 'package:soulsync_frontend/app/modules/date_requests/controllers/date_requests_controller.dart';

class DateRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DateRequestsController>(() => DateRequestsController());
  }
}