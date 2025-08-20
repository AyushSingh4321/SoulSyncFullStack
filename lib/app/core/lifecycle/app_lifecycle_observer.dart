import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soulsync_frontend/app/data/services/websocket_service.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final webSocketService = Get.find<WebSocketService>();

    switch (state) {
      case AppLifecycleState.paused:
        print('🔴 App paused - setting user offline');
        webSocketService.disconnect();
        break;
      case AppLifecycleState.detached:
        print('🔴 App detached - setting user offline');
        webSocketService.disconnect();
        break;
      case AppLifecycleState.resumed:
        print('🟢 App resumed - setting user online');
        webSocketService.connect();
        break;
      case AppLifecycleState.inactive:
        print('🟡 App inactive - setting user offline');
        webSocketService.disconnect();
        break;
      default:
        break;
    }
  }
}
