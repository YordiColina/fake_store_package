import 'package:flutter/material.dart';

@immutable
class Categories {
  final List<String> categories;

  const Categories({required this.categories});

  factory Categories.fromJson(List<dynamic> json) {
    return Categories(categories: json.cast<String>());
  }

  Map<String, dynamic> toJson() {
    return {'categories': categories};
  }
}
