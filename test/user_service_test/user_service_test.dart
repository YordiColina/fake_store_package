import 'dart:convert';
import 'package:fake_store_package/models/user/user.dart';
import 'package:fake_store_package/services_api/user_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_service_test.mocks.dart';



@GenerateMocks([http.Client])
void main() {
  late UserService userService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    userService = UserService(client: mockClient);
  });

  test('getUser devuelve un usuario correctamente', () async {
    when(mockClient.get(Uri.parse('https://fakestoreapi.com/users/1')))
        .thenAnswer((_) async => http.Response(
            jsonEncode({
              "id": 1,
              "email": "johndoe@example.com",
              "username": "johndoe"
            }),
            200));

    final response = await userService.getUser(1);
    expect(response.statusCode, 200);
  });

  test('createUser devuelve un código 201 cuando se crea correctamente',
      () async {
    final user = User(
        email: "johndoe@example.com",
        username: "johndoe",
        password: '',
        name: Name(firstname: "", lastname: ""),
        address: Address(city:"", street: "", number: 1, zipcode: "", geolocation: Geolocation(lat: "", long: "")),
        phone: '');

    when(mockClient.post(
      Uri.parse('https://fakestoreapi.com/users'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('{"id": 1}', 201));

    final response = await userService.createUser(user);
    expect(response.statusCode, 201);
  });

  test('login devuelve un token cuando las credenciales son correctas',
      () async {
    final loginData = {"username": "johndoe", "password": "1234"};

    when(mockClient.post(
      Uri.parse('https://fakestoreapi.com/auth/login'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('{"token": "fake-token"}', 200));

    final response = await userService.login(loginData);
    expect(response.statusCode, 200);
  });

  test('getUser devuelve error 404 si el usuario no existe', () async {
    when(mockClient.get(Uri.parse('https://fakestoreapi.com/users/999')))
        .thenAnswer((_) async => http.Response('Not Found', 404));

    final response = await userService.getUser(999);
    expect(response.statusCode, 404);
  });
}
