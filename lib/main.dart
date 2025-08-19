import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soulsync_frontend/app/data/services/api_service.dart';
import 'package:soulsync_frontend/app/routes/app_pages.dart';
import 'package:soulsync_frontend/app/routes/app_routes.dart';
import 'package:soulsync_frontend/app/core/theme/app_theme.dart';
import 'package:soulsync_frontend/app/data/services/storage_service.dart';
import 'package:soulsync_frontend/app/data/services/websocket_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize StorageService
  await Get.putAsync(() => StorageService().init());

  // Access and print userId after initialization
  final storageService = Get.find<StorageService>();
  print('Accessing userId: ${storageService.userId}');

  // Initialize services with error handling
  try {
    await initServices();
    print('✅ Services initialized successfully');
  } catch (e) {
    print('❌ Service initialization failed: $e');
    // Continue anyway to see what happens
  }

  runApp(SoulSyncApp());
}

Future<void> initServices() async {
  try {
    print('Starting service initialization...');
    await Get.putAsync(() => StorageService().init());
    print('StorageService initialized successfully');
    Get.put(ApiService());
    print('ApiService initialized successfully');
    Get.put(WebSocketService());
    await Get.find<WebSocketService>().connect();
    print('WebSocketService initialized and connected successfully');
    print('All services initialized');
  } catch (e) {
    print('Error initializing services: $e');
    rethrow;
  }
}

class SoulSyncApp extends StatelessWidget {
  const SoulSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('Building SoulSyncApp with initialRoute: ${AppRoutes.splash}');
    return GetMaterialApp(
      title: 'SoulSync',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      routingCallback: (routing) {
        print('Navigation: ${routing?.current} -> ${routing?.previous}');
      },
    );
  }
}
