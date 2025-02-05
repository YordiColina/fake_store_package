import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart.g.dart';

@JsonSerializable()
@immutable
class Cart {
  @JsonKey(name: "id")
  final int id;

  @JsonKey(name: "userId")
  final int userId;

  @JsonKey(name: "date", fromJson: _fromJsonDate, toJson: _toJsonDate)
  final DateTime date;

  @JsonKey(name: "products")
  final List<CartProducts> products;

  const Cart({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  Map<String, dynamic> toJson() => _$CartToJson(this);

  // Métodos para convertir la fecha
  static DateTime _fromJsonDate(dynamic date) => DateTime.parse(date as String);
  static String _toJsonDate(DateTime date) => date.toIso8601String();
}
@JsonSerializable()
@immutable
class CartProducts {
  @JsonKey(name: "productId")
  final int productId;

  @JsonKey(name: "quantity")
  final int quantity;

  const CartProducts({
    required this.productId,
    required this.quantity,
  });

  factory CartProducts.fromJson(Map<String, dynamic> json) => _$CartProductsFromJson(json);

  Map<String, dynamic> toJson() => _$CartProductsToJson(this);
}