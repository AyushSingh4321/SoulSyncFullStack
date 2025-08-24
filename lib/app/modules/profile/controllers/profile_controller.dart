import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soulsync_frontend/app/core/constants/api_constants.dart';
import 'package:soulsync_frontend/app/data/services/api_service.dart';
import 'package:soulsync_frontend/app/data/services/cloudinary_service.dart';
import 'package:soulsync_frontend/app/data/models/user_model.dart';
import 'package:soulsync_frontend/app/routes/app_routes.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  final user = Rxn<UserModel>();
  final isLoading = false.obs;
  final selectedImageFile = Rxn<File>();
  final isUploadingImage = false.obs;
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
  bool get isFormValid => _validateForm();
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

  bool _validateForm() {
    // Check required fields
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Name is required');
      return false;
    }

    if (ageController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Age is required');
      return false;
    }

    if (selectedGender.value == null) {
      Get.snackbar('Validation Error', 'Gender is required');
      return false;
    }

    if (locationController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Location is required');
      return false;
    }

    if (heightController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Height is required');
      return false;
    }

    if (bioController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Bio is required');
      return false;
    }

    if (interestsController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Interests are required');
      return false;
    }

    if (selectedRelationshipType.value == null) {
      Get.snackbar('Validation Error', 'Relationship type is required');
      return false;
    }

    // Validate profile image is required
    if (selectedImageFile.value == null &&
        (user.value?.profileImageUrl == null ||
            user.value!.profileImageUrl!.isEmpty)) {
      Get.snackbar('Validation Error', 'Profile image is required');
      return false;
    }
    // Validate age is a valid number
    final age = int.tryParse(ageController.text.trim());
    if (age == null || age < 18 || age > 100) {
      Get.snackbar(
        'Validation Error',
        'Please enter a valid age between 18 and 100',
      );
      return false;
    }

    // Validate height is a valid number
    final height = double.tryParse(heightController.text.trim());
    if (height == null || height < 100 || height > 250) {
      Get.snackbar(
        'Validation Error',
        'Please enter a valid height between 100 and 250 cm',
      );
      return false;
    }

    return true;
  }

  Future<void> updateProfile() async {
    try {
      // Validate form before proceeding
      if (!_validateForm()) {
        return;
      }

      isLoading.value = true;

      String? imageUrl;

      // Upload image to Cloudinary if a new image is selected
      if (selectedImageFile.value != null) {
        isUploadingImage.value = true;
        imageUrl = await _cloudinaryService.uploadImageToCloudinary(
          selectedImageFile.value!,
        );
        if (imageUrl == null) {
          Get.snackbar('Error', 'Failed to upload image');
          return;
        }
        isUploadingImage.value = false;
      }

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

      // Add profileImageUrl only if we have a new image or existing image
      if (imageUrl != null) {
        profileData['profileImageUrl'] = imageUrl;
      } else if (user.value?.profileImageUrl != null) {
        profileData['profileImageUrl'] = user.value!.profileImageUrl;
      }

      final response = await _apiService.post(
        ApiConstants.updateProfile,
        body: profileData,
      );

      if (response.statusCode == 200) {
        // Update local user data
        await loadProfile();
        Get.back(); // Back to profile page

        // Show snackbar after navigation is complete
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
            'Success',
            'Profile updated successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        });
      } else {
        Get.snackbar('Error', 'Failed to update profile');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    } finally {
      isLoading.value = false;
      isUploadingImage.value = false;
    }
  }

  void navigateToEditProfile() {
    Get.toNamed(AppRoutes.editProfile);
  }

  Future<void> pickImageFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 800,
      );

      if (image != null) {
        selectedImageFile.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to take photo: $e');
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 800,
      );

      if (image != null) {
        selectedImageFile.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  void showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Profile Photo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImagePickerOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () {
                    Get.back();
                    pickImageFromCamera();
                  },
                ),
                _buildImagePickerOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () {
                    Get.back();
                    pickImageFromGallery();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
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
