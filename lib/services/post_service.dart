import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class PostService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  static Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar publicaciones');
    }
  }

  static Future<Post> createPost(Post post) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(post.toJson()),
    );
    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear publicación');
    }
  }

  static Future<void> updatePost(Post post) async {
    await http.put(
      Uri.parse('$_baseUrl/${post.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(post.toJson()),
    );
  }

  static Future<void> deletePost(int id) async {
    await http.delete(Uri.parse('$_baseUrl/$id'));
  }
}
