import 'package:fake_store_package/models/user/user.dart';

class GetUser {
  final String email;
  final String username;
  final String password;
  final Name name;
  final Address address;
  final String phone;

  GetUser({
    required this.email,
    required this.username,
    required this.password,
    required this.name,
    required this.address,
    required this.phone,
  });

  factory GetUser.fromJson(Map<String, dynamic> json) {
    return GetUser(
      email: json['email'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      name: Name.fromJson(json['name'] as Map<String, dynamic>),
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'password': password,
      'name': name.toJson(),
      'address': address.toJson(),
      'phone': phone,
    };
  }
}
