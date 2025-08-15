import 'package:get/get.dart';
import 'package:soulsync_frontend/app/modules/dates/controllers/dates_controller.dart';

class DatesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DatesController>(() => DatesController());
  }
}