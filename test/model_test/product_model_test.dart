import 'package:fake_store_package/models/products/product.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('Product Model', () {
    test('Debe crear una instancia de Product correctamente', () {
      const product = Product(
        id: 1,
        title: 'Producto de prueba',
        price: 99.99,
        category: 'Categoría de prueba',
        description: 'Descripción de prueba',
        image: 'https://example.com/image.jpg',
      );

      expect(product.id, 1);
      expect(product.title, 'Producto de prueba');
      expect(product.price, 99.99);
      expect(product.category, 'Categoría de prueba');
      expect(product.description, 'Descripción de prueba');
      expect(product.image, 'https://example.com/image.jpg');
    });

    test('Debe convertir un JSON válido en una instancia de Product', () {
      final json = {
        'id': 2,
        'title': 'Otro producto',
        'price': 49.99,
        'category': 'Otra categoría',
        'description': 'Otra descripción',
        'image': 'https://example.com/another-image.jpg',
      };

      final product = Product.fromJson(json);

      expect(product.id, 2);
      expect(product.title, 'Otro producto');
      expect(product.price, 49.99);
      expect(product.category, 'Otra categoría');
      expect(product.description, 'Otra descripción');
      expect(product.image, 'https://example.com/another-image.jpg');
    });

    test('Debe manejar un JSON con valores nulos', () {
      final json = {
        'id': null,
        'title': null,
        'price': null,
        'category': null,
        'description': null,
        'image': null,
      };

      final product = Product.fromJson(json);

      expect(product.id, 0);
      expect(product.title, 'Sin título');
      expect(product.price, 0.0);
      expect(product.category, 'Desconocido');
      expect(product.description, 'Sin descripción');
      expect(product.image, '');
    });

    test('Debe convertir una instancia de Product a JSON correctamente', () {
      const product = Product(
        id: 3,
        title: 'Producto JSON',
        price: 199.99,
        category: 'Categoría JSON',
        description: 'Descripción JSON',
        image: 'https://example.com/json-image.jpg',
      );

      final json = product.toJson();

      expect(json['id'], 3);
      expect(json['title'], 'Producto JSON');
      expect(json['price'], 199.99);
      expect(json['category'], 'Categoría JSON');
      expect(json['description'], 'Descripción JSON');
      expect(json['image'], 'https://example.com/json-image.jpg');
    });
  });
}
