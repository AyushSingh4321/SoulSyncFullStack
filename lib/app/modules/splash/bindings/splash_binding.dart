import 'package:get/get.dart';
import 'package:soulsync_frontend/app/modules/splash/controllers/splash_controller.dart';
import 'package:soulsync_frontend/app/data/services/api_service.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<SplashController>(() => SplashController());
  }
}