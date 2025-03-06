import 'package:flutter/material.dart';

@immutable
class Product {
  final int id;
  final String title;
  final double price;
  final String category;
  final String description;
  final String image;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? "Sin título",
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String? ?? "Desconocido",
      description: json['description'] as String? ?? "Sin descripción",
      image: json['image'] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'category': category,
      'description': description,
      'image': image,
    };
  }
}
