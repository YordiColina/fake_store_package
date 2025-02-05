import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_request.g.dart';

@JsonSerializable()
@immutable
class CartRequest {

  @JsonKey(name: "userId")
  final int userId;

  @JsonKey(name: "date")
  final DateTime date;

  @JsonKey(name: "products")
  final List<CartProducts> products;

  const CartRequest({
    required this.userId,
    required this.date,
    required this.products,
  });

  factory CartRequest.fromJson(Map<String, dynamic> json) => _$CartRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CartRequestToJson(this);
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