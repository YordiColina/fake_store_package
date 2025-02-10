// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUser _$GetUserFromJson(Map<String, dynamic> json) => GetUser(
      email: json['email'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      name: Name.fromJson(json['name'] as Map<String, dynamic>),
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      phone: json['phone'] as String,
    );

Map<String, dynamic> _$GetUserToJson(GetUser instance) => <String, dynamic>{
      'email': instance.email,
      'username': instance.username,
      'password': instance.password,
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
    };
