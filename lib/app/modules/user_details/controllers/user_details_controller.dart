import 'package:get/get.dart';
import 'package:soulsync_frontend/app/data/models/user_model.dart';
import 'package:soulsync_frontend/app/routes/app_routes.dart';

class UserDetailsController extends GetxController {
  late UserModel user;

  @override
  void onInit() {
    super.onInit();
    try {
      final arguments = Get.arguments;
      print('🔍 Arguments type: ${arguments.runtimeType}');
      print('🔍 Arguments value: $arguments');

      if (arguments is UserModel) {
        user = arguments;
      } else if (arguments is Map<String, dynamic>) {
        // If it's a map, create UserModel from it
        user = UserModel.fromJson(arguments);
      } else {
        print('❌ Unexpected argument type: ${arguments.runtimeType}');
        // Create a default user or go back
        Get.back();
        return;
      }

      print('✅ User loaded: ${user.name}');
    } catch (e) {
      print('❌ Error loading user: $e');
      Get.back();
    }
  }

  void navigateToChat() {
    Get.toNamed(
      AppRoutes.chatRoom,
      arguments: {'userId': user.id.toString(), 'userName': user.name},
    );
  }

  void sendDateRequest() {
    Get.toNamed(
      AppRoutes.dateRequests,
      arguments: {'action': 'send', 'receiverId': user.id},
    );
  }
}
