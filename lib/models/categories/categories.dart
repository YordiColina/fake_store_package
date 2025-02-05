import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'categories.g.dart';

@JsonSerializable()
@immutable
class Categories {
  final List<String> categories;

  const Categories({required this.categories});

  factory Categories.fromJson(List<dynamic> json) =>
      Categories(categories: json.cast<String>());

  Map<String, dynamic> toJson() =>
      {'categories': categories};
}
