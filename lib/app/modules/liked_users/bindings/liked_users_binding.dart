import 'package:get/get.dart';
import 'package:soulsync_frontend/app/modules/liked_users/controllers/liked_users_controller.dart';

class LikedUsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LikedUsersController>(() => LikedUsersController());
  }
}