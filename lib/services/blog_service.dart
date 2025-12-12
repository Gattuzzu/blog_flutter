import 'dart:convert';

import 'package:blog_beispiel/models/blog.dart';
import 'package:http/http.dart' as http;

class BlogService {
  final uri = "https://cloud.appwrite.io/v1/databases/blog-db/collections/blogs/documents";
  final query = "?queries[]";
  final uriParameter = "={method:limit, values:1000}";
  final xAppwriteProject = "6568509f75ac404ff6ae";
  final xAppwriteKey = "ac0f362d0cf82fe3d138195e142c0a87a88cee4e2c48821192fb307e1a1c74ee694246f90082b4441aa98a2edaddead28ed6d18cf08c4de0df90dcaeeb53d14f14fb9eeb2edec6708c9553434f1d8df8f8acbfbefd35cccb70f2ab0f9a334dfd979b6052f6e8b8610d57465cbe8d71a7f65e8d48aede789eef6b976b1fe9b2e2";

  late Map<String, String> headers; // late ist ein Schlüsselwort, dass diese Variable erst im Konstruktor initialisiert wird.
  static BlogService instance = BlogService._privateConstructor();
  BlogService._privateConstructor(){
    headers = {
      "X-Appwrite-Project": xAppwriteProject,
      "X-Appwrite-Key": xAppwriteKey
    };
  }


  Future<List<Blog>> fetchAllBlogs() async {
    final response = await http.get(
      Uri.parse(uri),
      headers: headers
    );

    if(response.statusCode == 200){
      // 1. Das gesamte JSON-Objekt als Map dekodieren
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // 2. Zugriff auf den Key "documents", der die eigentliche Liste enthält
      final List<dynamic> jsonList = jsonResponse['documents'];

      // 3. Mapping vom Json in ein Blog Object
      return jsonList.map((json) => Blog.fromJson(json)).toList();
    } else{
      throw Exception("Failed to load Blogs");
    }
  }

  Future<Blog> fetchBlog(String id) async {
    final response = await http.get(
      Uri.parse("$uri/$id"),
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
    final response = await http.post(
      Uri.parse(uri),
      headers: {
        ...headers, 
        "Content-Type" : "application/json",
      },
      body: jsonEncode({
        "documentId": "unique()",
        "data": blog.toJson()
      })
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

    final response = await http.patch(
      Uri.parse("$uri/$id"),
      headers: {
        ...headers, 
        "Content-Type" : "application/json",
      },
      body: jsonEncode({
        "data": {
          if(title != null)   "title": title,
          if(content != null) "content": content,
        },
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
    final response = await http.delete(
      Uri.parse("$uri/$id"),
      headers: headers
    );

    if(response.statusCode == 204){
      return;
    } else{
      throw Exception("Failed to delete Blog with Id: $id");
    }
  }

}