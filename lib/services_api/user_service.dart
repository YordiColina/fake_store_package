import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user/user.dart';

class UserService {
  final String baseUrl = 'https://fakestoreapi.com/users';
  final http.Client client;

  UserService({required this.client});

  Future<http.Response> getUser(int id) async {
    return await client.get(Uri.parse('$baseUrl/$id'));
  }

  Future<http.Response> createUser(User body) async {
    return await client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body.toJson()),
    );
  }

  Future<http.Response> login(Map<String, dynamic> body) async {
    return await client.post(
      Uri.parse('https://fakestoreapi.com/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }
}
