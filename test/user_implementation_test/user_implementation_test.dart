import 'package:fake_store_package/helpers/log_printer/log_printer.dart';
import 'package:fake_store_package/models/auth/login_request.dart';
import 'package:fake_store_package/models/user/get_user.dart';
import 'package:fake_store_package/models/user/user.dart';
import 'package:fake_store_package/services_api/user_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fake_store_package/fake_store_package.dart';
import 'user_service_mock.mocks.dart';


@GenerateMocks([UserService])
void main() {
  late FakeStorePackage fakeStorePackage;
  late MockUserService mockUserService;
  final mockLogger = LoggerService();

  setUp(() {
    mockUserService = MockUserService();
    fakeStorePackage = FakeStorePackage(userService: mockUserService, loggerService: mockLogger);
  });

  const int userId = 1;
  const int failUserId = 999;
  final mockUserJson = {
    "email": "test@example.com",
    "username": "testUser",
    "password": "securePassword",
    "name": {"firstname": "John", "lastname": "Doe"},
    "address": {
      "city": "TestCity",
      "street": "TestStreet",
      "number": 123,
      "zipcode": "12345",
      "geolocation": {"lat": "40.7128", "long": "-74.0060"}
    },
    "phone": "123456789"
  };

  final mockUser = User.fromJson(mockUserJson);

  group('UserService Tests', () {
    test('getUser returns a user on success', () async {
      when(mockUserService.getUser(userId))
          .thenAnswer((_) async => http.Response(jsonEncode(mockUserJson), 200));

      final result = await fakeStorePackage.getUser(userId);

      expect(result, isA<Right>());
      expect(result.getOrElse(() => throw Exception()), isA<GetUser>());
      expect(result.getOrElse(() => throw Exception()).username, "testUser");
    });

    test('getUser returns error on failure', () async {
      when(mockUserService.getUser(failUserId))
          .thenAnswer((_) async => http.Response("User not found", 404));

      final result = await fakeStorePackage.getUser(failUserId);

      expect(result, isA<Left>());
      expect(result.fold((error) => error, (r) => ''), contains("HTTP error: Failed to fetch data from the server."));
    });

    test('createUser returns success response', () async {
      when(mockUserService.createUser(any))
          .thenAnswer((_) async => http.Response(jsonEncode({"success": true}), 201));

      final result = await fakeStorePackage.createUser(mockUser);

      expect(result, isA<Right>());
      expect(result.getOrElse(() => {}), containsPair("success", true));
    });

    test('createUser returns error on failure', () async {
      when(mockUserService.createUser(any))
          .thenAnswer((_) async => http.Response("Error creating user", 400));

      final result = await fakeStorePackage.createUser(mockUser);

      expect(result, isA<Left>());
      expect(result.fold((error) => error, (r) => ''), contains("HTTP error: Failed to fetch data from the server"));
    });

    test('login returns success response', () async {
      const loginRequest = LoginRequest(username: "testUser", password: "securePassword");

      when(mockUserService.login(any))
          .thenAnswer((_) async => http.Response(jsonEncode({"token": "abcd1234"}), 200));

      final result = await fakeStorePackage.login(loginRequest);

      expect(result, isA<Right>());
      expect(result.getOrElse(() => {}), containsPair("token", "abcd1234"));
    });

    test('login returns error on failure', () async {
      final loginRequest = LoginRequest(username: "testUser", password: "securePassword");

      when(mockUserService.login(any))
          .thenAnswer((_) async => http.Response("Invalid credentials", 401));

      final result = await fakeStorePackage.login(loginRequest);

      expect(result, isA<Left>());
      expect(result.fold((error) => error, (r) => ''), contains("HTTP error: Failed to fetch data from the server"));
    });
  });
}
