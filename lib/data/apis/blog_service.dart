import 'dart:convert';

import 'package:blog_beispiel/data/auth/auth_repository.dart';
import 'package:blog_beispiel/data/logger/logger.util.dart';
import 'package:blog_beispiel/domain/models/blog.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class BlogService {
  final _uri = GlobalConfiguration().getValue('blogApiUrl');
  final Logger log = getLogger();

  final Map<String, String> _staticHeaders = {
      "Accept": "application/json",
      "Content-Type" : "application/json",
    };

  static BlogService instance = BlogService._();
  BlogService._();

  Future<Map<String, String>> _getHeaders() async {
    String? accessToken = await AuthRepository.instance.getAccessToken();
    if(accessToken != null){
      return {
        ... _staticHeaders,
        "Authorization": "Bearer $accessToken",
      };

    } else{
      log.e("Der AccessToken konnte nicht vom AuthRepository geladen werden!");
      return _staticHeaders;
    }
  }


  Future<List<Blog>> fetchAllBlogs() async {
    Map<String, String> headers = await _getHeaders();

    final response = await http.get(
      Uri.parse(_uri),
      headers: headers
    );

    if(response.statusCode == 200){
      // 1. Das gesamte JSON-Objekt als Map dekodieren
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // 2. Zugriff auf den Key "documents", der die eigentliche Liste enthält
      final List<dynamic> jsonList = jsonResponse['data'];

      // 3. Mapping vom Json in ein Blog Object
      return jsonList.map((json) => Blog.fromJson(json)).toList();
    } else{
      throw Exception("Failed to load Blogs");
    }
  }

  Future<Blog> fetchBlog(String id) async {
    Map<String, String> headers = await _getHeaders();

    final response = await http.get(
      Uri.parse("$_uri/$id"),
      headers: headers
    );

    if(response.statusCode == 200){
      // 1. Das gesamte JSON-Objekt als Map dekodieren
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // 2. Mapping vom Json in ein Blog Object
      return Blog.fromJson(jsonResponse);
    } else{
      throw Exception("Failed to load Blog with Id: $id");
    }
  }

  Future<Blog> postBlog(Blog blog) async{
    Map<String, String> headers = await _getHeaders();

    final response = await http.post(
      Uri.parse(_uri),
      headers: headers,
      body: jsonEncode(blog.toJson())
    );

    if(response.statusCode == 201){
      // 1. Das gesamte JSON-Objekt als Map dekodieren
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // 2. Mapping vom Json in ein Blog Object
      return Blog.fromJson(jsonResponse);
    } else{
      throw Exception("Failed to post new Blog with title: ${blog.title}");
    }
  }

  Future<Blog> patchBlog(String id, String? title, String? content) async{
    if(title == null && content == null){
      throw Exception("Failed to patch Blog, because all modifiable values are null");
    }

    Map<String, String> headers = await _getHeaders();

    final response = await http.patch(
      Uri.parse("$_uri/$id"),
      headers: headers,
      body: jsonEncode({
        if(title != null)   "title": title,
        if(content != null) "content": content,
        // if(headerImagerUrl != null) "headerImageUrl": headerImagerUrl,
      })
    );

    if(response.statusCode == 200){
      // 1. Das gesamte JSON-Objekt als Map dekodieren
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // 2. Mapping vom Json in ein Blog Object
      return Blog.fromJson(jsonResponse);
    } else{
      throw Exception("Failed to patch Blog.");
    }
  }

  Future<void> deleteBlog(String id) async {
    Map<String, String> headers = await _getHeaders();

    final response = await http.delete(
      Uri.parse("$_uri/$id"),
      headers: headers
    );

    if(response.statusCode == 204){
      return;
    } else{
      throw Exception("Failed to delete Blog with Id: $id");
    }
  }

}