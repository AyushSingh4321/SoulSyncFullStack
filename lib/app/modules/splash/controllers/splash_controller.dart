import 'package:get/get.dart';
import 'package:soulsync_frontend/app/routes/app_routes.dart';
import 'package:soulsync_frontend/app/data/services/storage_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print('🚀 SplashController initialized');
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    print('⏳ Starting 2-second splash delay...');
    await Future.delayed(const Duration(seconds: 2));
    print('⏳ Splash delay complete, checking token...');

    try {
      print('🔍 Trying to find StorageService...');
      final StorageService storageService = Get.find<StorageService>();
      print('✅ StorageService found successfully');

      final token = storageService.token;
      print('🎫 Token check: ${token != null ? 'Token exists' : 'No token'}');

      if (token != null && token.isNotEmpty) {
        print('🏠 Token found, navigating to home');
        Get.offAllNamed(AppRoutes.home);
      } else {
        print('🔐 No token, navigating to auth');
        Get.offAllNamed(AppRoutes.auth);
      }
    } catch (e) {
      print('❌ Error in navigation: $e');
      print('🔐 Navigating to auth due to error');
      Get.offAllNamed(AppRoutes.auth);
    }
  }
}
