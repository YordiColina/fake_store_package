import 'package:flutter/material.dart';
import 'cart.dart';

@immutable
class CartRequest {
  final int userId;
  final DateTime date;
  final List<CartProducts> products;

  const CartRequest({
    required this.userId,
    required this.date,
    required this.products,
  });

  factory CartRequest.fromJson(Map<String, dynamic> json) {
    return CartRequest(
      userId: json['userId'] as int,
      date: DateTime.parse(json['date'] as String),
      products: (json['products'] as List<dynamic>)
          .map((item) => CartProducts.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'date': date.toIso8601String(),
      'products': products.map((p) => p.toJson()).toList(),
    };
  }
}
