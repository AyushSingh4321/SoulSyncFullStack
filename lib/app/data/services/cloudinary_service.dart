import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  // Replace with your Cloudinary details
  final String cloudName = dotenv.env['CLOUD_NAME'] ?? '';
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  final String apiSecret = dotenv.env['API_SECRET'] ?? '';

  Future<String?> uploadImageToCloudinary(File imageFile) async {
    try {
      // API endpoint
      final url = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

      // Generate an unsigned preset in your Cloudinary account or handle authentication in your backend
      const String unsignedPreset = "assignment2";

      // Multipart request
      var request = http.MultipartRequest("POST", url);

      // Attach the image file
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      // Add additional fields
      request.fields['upload_preset'] = unsignedPreset;

      // Send the request
      var response = await request.send();

      // Handle the response
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final data = json.decode(responseData.body);

        // Return the secure URL
        return data['secure_url'];
      } else {
        print("Failed to upload image: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}