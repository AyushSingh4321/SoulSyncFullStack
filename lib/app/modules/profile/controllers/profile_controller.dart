import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soulsync_frontend/app/core/constants/api_constants.dart';
import 'package:soulsync_frontend/app/data/services/api_service.dart';
import 'package:soulsync_frontend/app/data/services/storage_service.dart';
import 'package:soulsync_frontend/app/data/models/user_model.dart';
import 'package:soulsync_frontend/app/routes/app_routes.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  final user = Rxn<UserModel>();
  final isLoading = false.obs;

  // Form controllers
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final bioController = TextEditingController();
  final locationController = TextEditingController();
  final interestsController = TextEditingController();
  final heightController = TextEditingController();
  final sportsController = TextEditingController();
  final gamesController = TextEditingController();

  // Dropdown values
  final selectedGender = Rxn<String>();
  final selectedRelationshipType = Rxn<String>();
  final goesGym = Rxn<bool>();
  final shortHair = Rxn<bool>();
  final wearGlasses = Rxn<bool>();
  final drink = Rxn<bool>();
  final smoke = Rxn<bool>();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get(ApiConstants.myProfile);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        user.value = UserModel.fromJson(data);
        _populateControllers();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _populateControllers() {
    final currentUser = user.value;
    if (currentUser == null) return;

    nameController.text = currentUser.name ?? '';
    ageController.text = currentUser.age?.toString() ?? '';
    bioController.text = currentUser.bio ?? '';
    locationController.text = currentUser.location ?? '';
    interestsController.text = currentUser.interests ?? '';
    heightController.text = currentUser.height?.toString() ?? '';
    sportsController.text = currentUser.sports ?? '';
    gamesController.text = currentUser.games ?? '';
    
    selectedGender.value = currentUser.gender;
    selectedRelationshipType.value = currentUser.relationshipType;
    goesGym.value = currentUser.goesGym;
    shortHair.value = currentUser.shortHair;
    wearGlasses.value = currentUser.wearGlasses;
    drink.value = currentUser.drink;
    smoke.value = currentUser.smoke;
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      
      final profileData = {
        'name': nameController.text,
        'age': int.tryParse(ageController.text),
        'gender': selectedGender.value,
        'bio': bioController.text,
        'location': locationController.text,
        'interests': interestsController.text,
        'height': double.tryParse(heightController.text),
        'sports': sportsController.text,
        'games': gamesController.text,
        'relationshipType': selectedRelationshipType.value,
        'goesGym': goesGym.value,
        'shortHair': shortHair.value,
        'wearGlasses': wearGlasses.value,
        'drink': drink.value,
        'smoke': smoke.value,
      };

      final response = await _apiService.post(
        ApiConstants.updateProfile,
        body: profileData,
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Profile updated successfully');
        Get.back();
      } else {
        Get.snackbar('Error', 'Failed to update profile');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToEditProfile() {
    Get.toNamed(AppRoutes.editProfile);
  }

  Future<void> logout() async {
    await _storageService.clearAll();
    Get.offAllNamed(AppRoutes.auth);
  }

  @override
  void onClose() {
    nameController.dispose();
    ageController.dispose();
    bioController.dispose();
    locationController.dispose();
    interestsController.dispose();
    heightController.dispose();
    sportsController.dispose();
    gamesController.dispose();
    super.onClose();
  }
}