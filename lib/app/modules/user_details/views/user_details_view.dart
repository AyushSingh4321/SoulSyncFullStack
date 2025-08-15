import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:soulsync_frontend/app/modules/user_details/controllers/user_details_controller.dart';

class UserDetailsView extends GetView<UserDetailsController> {
  const UserDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: controller.user.profileImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: controller.user.profileImageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.person,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and age
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${controller.user.name ?? 'Unknown'}, ${controller.user.age ?? 'N/A'}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (controller.user.score != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${controller.user.score}% Match',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Location
                  if (controller.user.location != null)
                    _buildInfoRow(Icons.location_on, controller.user.location!),
                  
                  // Height
                  if (controller.user.height != null)
                    _buildInfoRow(Icons.height, '${controller.user.height} cm'),
                  
                  // Relationship type
                  if (controller.user.relationshipType != null)
                    _buildInfoRow(Icons.favorite, controller.user.relationshipType!),
                  
                  const SizedBox(height: 24),
                  
                  // Bio
                  if (controller.user.bio != null) ...[
                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.user.bio!,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Interests
                  if (controller.user.interests != null) ...[
                    const Text(
                      'Interests',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.user.interests!
                          .split(',')
                          .map((interest) => Chip(
                                label: Text(interest.trim()),
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Lifestyle
                  const Text(
                    'Lifestyle',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  if (controller.user.sports != null)
                    _buildInfoRow(Icons.sports, 'Sports: ${controller.user.sports}'),
                  
                  if (controller.user.games != null)
                    _buildInfoRow(Icons.games, 'Games: ${controller.user.games}'),
                  
                  if (controller.user.goesGym != null)
                    _buildInfoRow(
                      Icons.fitness_center,
                      controller.user.goesGym! ? 'Goes to gym' : 'Doesn\'t go to gym',
                    ),
                  
                  if (controller.user.drink != null)
                    _buildInfoRow(
                      Icons.local_bar,
                      controller.user.drink! ? 'Drinks' : 'Doesn\'t drink',
                    ),
                  
                  if (controller.user.smoke != null)
                    _buildInfoRow(
                      Icons.smoking_rooms,
                      controller.user.smoke! ? 'Smokes' : 'Doesn\'t smoke',
                    ),
                  
                  const SizedBox(height: 100), // Space for floating buttons
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton.extended(
            heroTag: 'chat',
            onPressed: controller.navigateToChat,
            icon: const Icon(Icons.chat),
            label: const Text('Chat'),
            backgroundColor: Colors.blue,
          ),
          FloatingActionButton.extended(
            heroTag: 'date',
            onPressed: controller.sendDateRequest,
            icon: const Icon(Icons.calendar_today),
            label: const Text('Date'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}