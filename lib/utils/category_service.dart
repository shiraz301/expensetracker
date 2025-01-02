import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryService {
  // Machine's IP with API Call
  static const String baseUrl = 'http://192.168.18.11:5000/categories';

  // Fetch categories from the API
  static Future<List<String>> getCategories() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((category) => category['name'] as String).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }
}
