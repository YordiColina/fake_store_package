import 'dart:convert';
import 'package:fake_store_package/models/cart/cart_request.dart';
import 'package:fake_store_package/services_api/cart_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../product_service_test/product_service_test.mocks.dart';


@GenerateMocks([http.Client])
void main() {
  late CartService cartService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    cartService = CartService(client: mockClient);
  });

  test('getCart devuelve un carrito correctamente', () async {
    when(mockClient.get(Uri.parse('https://fakestoreapi.com/carts/user/1')))
        .thenAnswer((_) async => http.Response(jsonEncode([
      {"id": 1, "userId": 1, "date": "2023-10-10", "products": []}
    ]), 200));

    final response = await cartService.getCart(1);
    expect(response.statusCode, 200);
  });

  test('createCart devuelve un código 201 cuando se crea correctamente', () async {
    final cartRequest = CartRequest(userId: 1, date: DateTime.now(), products: []);

    when(mockClient.post(
      Uri.parse('https://fakestoreapi.com/carts'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('{"id": 10}', 201));

    final response = await cartService.createCart(cartRequest);
    expect(response.statusCode, 201);
  });

  test('updateCart devuelve un código 200 cuando se actualiza correctamente', () async {
    final cartRequest = CartRequest(userId: 1, date: DateTime.now(), products: []);

    when(mockClient.put(
      Uri.parse('https://fakestoreapi.com/carts/1'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('{"id": 1}', 200));

    final response = await cartService.updateCart(1, cartRequest);
    expect(response.statusCode, 200);
  });

  test('deleteCart devuelve un código 200 cuando se elimina correctamente', () async {
    when(mockClient.delete(Uri.parse('https://fakestoreapi.com/carts/1')))
        .thenAnswer((_) async => http.Response('{}', 200));

    final response = await cartService.deleteCart(1);
    expect(response.statusCode, 200);
  });

  test('getCart devuelve error 404 si el carrito no existe', () async {
    when(mockClient.get(Uri.parse('https://fakestoreapi.com/carts/user/999')))
        .thenAnswer((_) async => http.Response('Not Found', 404));

    final response = await cartService.getCart(999);
    expect(response.statusCode, 404);
  });
}
