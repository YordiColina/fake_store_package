import 'package:flutter/material.dart';

@immutable
class Cart {
  final int id;
  final int userId;
  final DateTime date;
  final List<CartProducts> products;

  const Cart({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'] as int,
      userId: json['userId'] as int,
      date: DateTime.parse(json['date'] as String),
      products: (json['products'] as List<dynamic>)
          .map((item) => CartProducts.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'products': products.map((p) => p.toJson()).toList(),
    };
  }
}

@immutable
class CartProducts {
  final int productId;
  final int quantity;

  const CartProducts({
    required this.productId,
    required this.quantity,
  });

  factory CartProducts.fromJson(Map<String, dynamic> json) {
    return CartProducts(
      productId: json['productId'] as int,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }
}
