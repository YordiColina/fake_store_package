import 'package:fake_store_package/helpers/log_printer/log_printer.dart';
import 'package:fake_store_package/models/cart/cart_request.dart';
import 'package:fake_store_package/services_api/cart_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'dart:convert';
import 'package:fake_store_package/fake_store_package.dart';
import 'package:http/http.dart' as http;

import 'cart_service_mock.mocks.dart';

@GenerateMocks([CartService])
void main() {
  late FakeStorePackage fakeStorePackage;
  late MockCartService mockCartService;
  final mockLogger = LoggerService();


  setUp(() {
    mockCartService = MockCartService();
    fakeStorePackage = FakeStorePackage(cartService: mockCartService,loggerService: mockLogger);
  });

  final cartRequest = CartRequest(userId: 1, date: DateTime.now(), products: []);
  final cartResponse = jsonEncode({'id': 1, 'userId': 1, 'date': DateTime.now().toIso8601String(), 'products': []});

  group('CartService Tests', () {
    test('createCart returns success response', () async {
      when(mockCartService.createCart(any)).thenAnswer((_) async => http.Response(cartResponse, 201));

      final result = await fakeStorePackage.createCart(cartRequest);

      expect(result, isA<Right>());
    });

    test('updateCart returns success response', () async {
      when(mockCartService.updateCart(any, any)).thenAnswer((_) async => http.Response(cartResponse, 200));

      final result = await fakeStorePackage.updateCart(1, cartRequest);

      expect(result, isA<Right>());
    });


    test('deleteCart returns success response', () async {
      when(mockCartService.deleteCart(any))
          .thenAnswer((_) async => http.Response('', 204));

      final result = await fakeStorePackage.deleteCart(1);

      expect(result, isA<Right<String, Map<String, dynamic>>>());
      expect(result.getOrElse(() => {}), isEmpty);
    });


    test('getCart returns list of carts', () async {
      final cartListResponse = jsonEncode([
        {'id': 1, 'userId': 1, 'date': DateTime.now().toIso8601String(), 'products': []}
      ]);
      when(mockCartService.getCart(any)).thenAnswer((_) async => http.Response(cartListResponse, 200));

      final result = await fakeStorePackage.getCart(1);

      expect(result, isA<Right>());
    });
  });
}
