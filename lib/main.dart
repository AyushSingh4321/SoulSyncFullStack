import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soulsync_frontend/app/routes/app_pages.dart';
import 'package:soulsync_frontend/app/routes/app_routes.dart';
import 'package:soulsync_frontend/app/core/theme/app_theme.dart';
import 'package:soulsync_frontend/app/data/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await initServices();
  
  runApp(const SoulSyncApp());
}

Future<void> initServices() async {
  await Get.putAsync(() => StorageService().init());
}

class SoulSyncApp extends StatelessWidget {
  const SoulSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SoulSync',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}