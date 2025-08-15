import 'package:get/get.dart';
import 'package:soulsync_frontend/app/data/models/user_model.dart';
import 'package:soulsync_frontend/app/routes/app_routes.dart';

class UserDetailsController extends GetxController {
  late UserModel user;

  @override
  void onInit() {
    super.onInit();
    user = Get.arguments as UserModel;
  }

  void navigateToChat() {
    Get.toNamed(AppRoutes.chatRoom, arguments: {
      'userId': user.id.toString(),
      'userName': user.name,
    });
  }

  void sendDateRequest() {
    Get.toNamed(AppRoutes.dateRequests, arguments: {
      'action': 'send',
      'receiverId': user.id,
    });
  }
}