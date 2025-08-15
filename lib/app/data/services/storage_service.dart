import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Token management
  String? get token => _prefs.getString('token');
  Future<bool> setToken(String token) => _prefs.setString('token', token);
  Future<bool> removeToken() => _prefs.remove('token');

  // User data
  String? get userId => _prefs.getString('userId');
  Future<bool> setUserId(String userId) => _prefs.setString('userId', userId);
  Future<bool> removeUserId() => _prefs.remove('userId');

  // App settings
  bool get isFirstTime => _prefs.getBool('isFirstTime') ?? true;
  Future<bool> setFirstTime(bool value) => _prefs.setBool('isFirstTime', value);

  // Clear all data
  Future<bool> clearAll() => _prefs.clear();
}