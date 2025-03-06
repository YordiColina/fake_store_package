import 'package:fake_store_package/models/cart/cart.dart';
import 'package:fake_store_package/models/cart/cart_request.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('CartProducts Model', () {
    test('Debe crear una instancia de CartProducts correctamente', () {
      const cartProduct = CartProducts(productId: 1, quantity: 5);

      expect(cartProduct.productId, 1);
      expect(cartProduct.quantity, 5);
    });

    test('Debe convertir CartProducts de JSON correctamente', () {
      final json = {'productId': 2, 'quantity': 10};
      final cartProduct = CartProducts.fromJson(json);

      expect(cartProduct.productId, 2);
      expect(cartProduct.quantity, 10);
    });

    test('Debe convertir CartProducts a JSON correctamente', () {
      const cartProduct = CartProducts(productId: 3, quantity: 7);
      final json = cartProduct.toJson();

      expect(json, {'productId': 3, 'quantity': 7});
    });
  });

  group('Cart Model', () {
    test('Debe crear una instancia de Cart correctamente', () {
      final date = DateTime(2024, 3, 5);
      const products = [CartProducts(productId: 1, quantity: 5)];

      final cart = Cart(id: 101, userId: 10, date: date, products: products);

      expect(cart.id, 101);
      expect(cart.userId, 10);
      expect(cart.date, date);
      expect(cart.products.length, 1);
      expect(cart.products.first.productId, 1);
    });

    test('Debe convertir Cart de JSON correctamente', () {
      final json = {
        'id': 200,
        'userId': 20,
        'date': '2024-03-06T12:00:00.000Z',
        'products': [
          {'productId': 1, 'quantity': 3},
          {'productId': 2, 'quantity': 6}
        ]
      };

      final cart = Cart.fromJson(json);

      expect(cart.id, 200);
      expect(cart.userId, 20);
      expect(cart.date, DateTime.parse('2024-03-06T12:00:00.000Z'));
      expect(cart.products.length, 2);
      expect(cart.products[0].productId, 1);
      expect(cart.products[0].quantity, 3);
    });

    test('Debe convertir Cart a JSON correctamente', () {
      final date = DateTime(2024, 3, 6);
      const products = [CartProducts(productId: 1, quantity: 4)];

      final cart = Cart(id: 201, userId: 30, date: date, products: products);
      final json = cart.toJson();

      expect(json['id'], 201);
      expect(json['userId'], 30);
      expect(json['date'], date.toIso8601String());
      expect(json['products'], [
        {'productId': 1, 'quantity': 4}
      ]);
    });
  });

  group('CartRequest Model', () {
    test('Debe crear una instancia de CartRequest correctamente', () {
      final date = DateTime(2024, 3, 7);
      const products = [CartProducts(productId: 2, quantity: 8)];

      final cartRequest = CartRequest(userId: 40, date: date, products: products);

      expect(cartRequest.userId, 40);
      expect(cartRequest.date, date);
      expect(cartRequest.products.length, 1);
      expect(cartRequest.products.first.productId, 2);
    });

    test('Debe convertir CartRequest de JSON correctamente', () {
      final json = {
        'userId': 50,
        'date': '2024-03-08T15:00:00.000Z',
        'products': [
          {'productId': 3, 'quantity': 2}
        ]
      };

      final cartRequest = CartRequest.fromJson(json);

      expect(cartRequest.userId, 50);
      expect(cartRequest.date, DateTime.parse('2024-03-08T15:00:00.000Z'));
      expect(cartRequest.products.length, 1);
      expect(cartRequest.products.first.productId, 3);
    });

    test('Debe convertir CartRequest a JSON correctamente', () {
      final date = DateTime(2024, 3, 8);
      const products = [CartProducts(productId: 4, quantity: 9)];

      final cartRequest = CartRequest(userId: 60, date: date, products: products);
      final json = cartRequest.toJson();

      expect(json['userId'], 60);
      expect(json['date'], date.toIso8601String());
      expect(json['products'], [
        {'productId': 4, 'quantity': 9}
      ]);
    });
  });
}
