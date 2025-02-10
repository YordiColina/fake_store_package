// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartRequest _$CartRequestFromJson(Map<String, dynamic> json) => CartRequest(
      userId: (json['userId'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      products: (json['products'] as List<dynamic>)
          .map((e) => CartProducts.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CartRequestToJson(CartRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'date': instance.date.toIso8601String(),
      'products': instance.products,
    };
