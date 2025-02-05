import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@immutable
@JsonSerializable()
class LoginRequest {

  final String username;
  final String password;

  const LoginRequest({
    required this.username,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

}
