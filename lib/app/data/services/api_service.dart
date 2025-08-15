import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:soulsync_frontend/app/data/services/storage_service.dart';

class ApiService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    final token = _storageService.token;
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  Future<http.Response> get(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      );
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> post(String url, {Map<String, dynamic>? body}) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      );
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> put(String url, {Map<String, dynamic>? body}) async {
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      );
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> delete(String url) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: _headers,
      );
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}