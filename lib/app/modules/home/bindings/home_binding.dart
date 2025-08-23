import 'package:get/get.dart';
import 'package:soulsync_frontend/app/modules/home/controllers/home_controller.dart';
import 'package:soulsync_frontend/app/modules/chat/controllers/chat_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ChatController>(() => ChatController());
  }
}
