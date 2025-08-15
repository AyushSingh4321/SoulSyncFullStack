import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soulsync_frontend/app/modules/profile/controllers/profile_controller.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          Obx(() => TextButton(
            onPressed: controller.isLoading.value ? null : controller.updateProfile,
            child: controller.isLoading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          )),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Basic Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Basic Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller.nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller.ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        prefixIcon: Icon(Icons.cake),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(() => DropdownButtonFormField<String>(
                      value: controller.selectedGender.value,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      items: ['Male', 'Female', 'Other']
                          .map((gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              ))
                          .toList(),
                      onChanged: (value) => controller.selectedGender.value = value,
                    )),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller.locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller.heightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Height (cm)',
                        prefixIcon: Icon(Icons.height),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // About Me
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About Me',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller.bioController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Bio',
                        prefixIcon: Icon(Icons.description),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller.interestsController,
                      decoration: const InputDecoration(
                        labelText: 'Interests (comma separated)',
                        prefixIcon: Icon(Icons.interests),
                        hintText: 'e.g., Reading, Traveling, Music',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Lifestyle
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lifestyle',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller.sportsController,
                      decoration: const InputDecoration(
                        labelText: 'Sports',
                        prefixIcon: Icon(Icons.sports),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller.gamesController,
                      decoration: const InputDecoration(
                        labelText: 'Games',
                        prefixIcon: Icon(Icons.games),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(() => DropdownButtonFormField<String>(
                      value: controller.selectedRelationshipType.value,
                      decoration: const InputDecoration(
                        labelText: 'Relationship Type',
                        prefixIcon: Icon(Icons.favorite),
                      ),
                      items: ['Casual', 'Commitment']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) => controller.selectedRelationshipType.value = value,
                    )),
                    const SizedBox(height: 16),
                    
                    // Boolean preferences
                    Obx(() => SwitchListTile(
                      title: const Text('Goes to Gym'),
                      value: controller.goesGym.value ?? false,
                      onChanged: (value) => controller.goesGym.value = value,
                    )),
                    Obx(() => SwitchListTile(
                      title: const Text('Has Short Hair'),
                      value: controller.shortHair.value ?? false,
                      onChanged: (value) => controller.shortHair.value = value,
                    )),
                    Obx(() => SwitchListTile(
                      title: const Text('Wears Glasses'),
                      value: controller.wearGlasses.value ?? false,
                      onChanged: (value) => controller.wearGlasses.value = value,
                    )),
                    Obx(() => SwitchListTile(
                      title: const Text('Drinks'),
                      value: controller.drink.value ?? false,
                      onChanged: (value) => controller.drink.value = value,
                    )),
                    Obx(() => SwitchListTile(
                      title: const Text('Smokes'),
                      value: controller.smoke.value ?? false,
                      onChanged: (value) => controller.smoke.value = value,
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}