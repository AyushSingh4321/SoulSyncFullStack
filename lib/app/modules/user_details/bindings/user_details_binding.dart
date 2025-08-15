import 'package:get/get.dart';
import 'package:soulsync_frontend/app/modules/user_details/controllers/user_details_controller.dart';

class UserDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserDetailsController>(() => UserDetailsController());
  }
}