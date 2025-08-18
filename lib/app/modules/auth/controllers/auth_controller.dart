import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soulsync_frontend/app/core/constants/api_constants.dart';
import 'package:soulsync_frontend/app/data/services/api_service.dart';
import 'package:soulsync_frontend/app/data/services/storage_service.dart';
import 'package:soulsync_frontend/app/routes/app_routes.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final otpController = TextEditingController();

  // Observable variables
  final isLoading = false.obs;
  final isLogin = true.obs;
  final showOtpField = false.obs;
  final obscurePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    print('🔧 AuthController initialized');
    print('🔧 isLoading initial value: ${isLoading.value}');
    print('🔧 isLogin initial value: ${isLogin.value}');
  }

  void toggleAuthMode() {
    isLogin.value = !isLogin.value;
    showOtpField.value = false;
    _clearControllers();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> sendOtp() async {
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter email');
      return;
    }

    try {
      isLoading.value = true;
      final response = await _apiService.get(
        '${ApiConstants.sendOtp}/${emailController.text}',
      );

      if (response.statusCode == 200) {
        showOtpField.value = true;
        Get.snackbar('Success', 'OTP sent to your email');
      } else {
        Get.snackbar('Error', 'Failed to send OTP');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> validateOtp() async {
    if (otpController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter OTP');
      return;
    }

    try {
      isLoading.value = true;
      final response = await _apiService.post(
        ApiConstants.validateOtp,
        body: {'email': emailController.text, 'otp': otpController.text},
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'OTP verified successfully');
        await _signup();
      } else {
        Get.snackbar('Error', 'Invalid OTP');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    try {
      isLoading.value = true;
      final response = await _apiService.post(
        ApiConstants.login,
        body: {
          'identifier': emailController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final token = response.body;
        await _storageService.setToken(token);

        // Now fetch user profile to get user ID
        await _fetchAndStoreUserProfile();

        Get.offAllNamed(AppRoutes.home);
      } else {
        final error = response.body;
        Get.snackbar('Error', error);
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
      print('Network error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _signup() async {
    try {
      final response = await _apiService.post(
        ApiConstants.signup,
        body: {
          'username': usernameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final token = response.body;
        await _storageService.setToken(token);

        // Fetch user profile to get user ID
        await _fetchAndStoreUserProfile();

        Get.offAllNamed(AppRoutes.home);
      } else {
        final error = response.body;
        Get.snackbar('Error', error);
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    }
  }

  Future<void> _fetchAndStoreUserProfile() async {
    try {
      final profileResponse = await _apiService.get(ApiConstants.myProfile);
      if (profileResponse.statusCode == 200) {
        final profileData = jsonDecode(profileResponse.body);
        final userId = profileData['id'].toString();
        await _storageService.setUserId(userId);
        print('🔐 User profile fetched - User ID: $userId');
      } else {
        print('⚠️ Failed to fetch user profile: ${profileResponse.statusCode}');
      }
    } catch (e) {
      print('⚠️ Error fetching user profile: $e');
    }
  }

  void _clearControllers() {
    emailController.clear();
    passwordController.clear();
    usernameController.clear();
    otpController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
