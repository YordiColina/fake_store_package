import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart/cart_request.dart';

class CartService {
  final String baseUrl = 'https://fakestoreapi.com/carts';
  final http.Client client;

  CartService({required this.client});

  Future<http.Response> getCart(int id) async {
    return await client.get(Uri.parse('$baseUrl/user/$id'));
  }

  Future<http.Response> createCart(CartRequest body) async {
    return await client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body.toJson()),
    );
  }

  Future<http.Response> updateCart(int id, CartRequest body) async {
    return await client.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body.toJson()),
    );
  }

  Future<http.Response> deleteCart(int id) async {
    return await client.delete(Uri.parse('$baseUrl/$id'));
  }
}
