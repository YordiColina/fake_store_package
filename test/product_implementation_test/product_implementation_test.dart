import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:fake_store_package/fake_store_package.dart';
import 'package:fake_store_package/helpers/log_printer/log_printer.dart';
import 'package:fake_store_package/models/products/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'product_service_mock.mocks.dart';

void main() {
  late FakeStorePackage fakeStorePackage;
  final mockLogger = LoggerService();

  late MockProductService mockProductService;


  setUp(() {
    mockProductService = MockProductService();
    fakeStorePackage = FakeStorePackage(productService: mockProductService,loggerService: mockLogger);
  });

  group('getAllProducts', () {
    test('debería retornar una lista de productos cuando la API responde correctamente', () async {
      final jsonResponse = jsonEncode([
        {"id": 1, "title": "Producto 1", "price": 100.0, "description": "Descripción 1"},
        {"id": 2, "title": "Producto 2", "price": 200.0, "description": "Descripción 2"},
      ]);

      // Imprimir antes de hacer el `when`
      print("Configurando mockProductService.getAllProducts()...");

      when(mockProductService.getAllProducts())
          .thenAnswer((_) async {
        print("Se llamó a mockProductService.getAllProducts()");
        return http.Response(jsonResponse, 200);
      });

      print("Llamando a fakeStorePackage.getAllProducts()...");

      final result = await fakeStorePackage.getAllProducts();

      print("Resultado recibido en el test: $result");

      expect(result, isA<Right>());
      result.fold(
            (error) => fail('Se esperaba una lista de productos, pero se recibió: $error'),
            (products) {
          expect(products, isA<List<Product>>());
          expect(products.length, 2);
        },
      );
    });


    test('debería retornar un error cuando la API falla', () async {
      when(mockProductService.getAllProducts())
          .thenAnswer((_) async => http.Response('Error interno', 500));
      final result = await fakeStorePackage.getAllProducts();

      expect(result, isA<Left>());
      result.fold(
            (error) => expect(error, contains('HTTP error: Failed to fetch data from the server')),
            (_) => fail('Se esperaba un error'),
      );
    });
  });

  group('getProduct', () {
    test('debería retornar un producto cuando la API responde correctamente', () async {
      final jsonResponse = jsonEncode({"id": 1, "title": "Producto 1", "price": 100, "description": "Descripción 1"});

      when(mockProductService.getProduct(1))
          .thenAnswer((_) async => http.Response(jsonResponse, 200));

      final result = await fakeStorePackage.getProduct(1);

      expect(result, isA<Right>());
      result.fold(
            (_) => fail('Se esperaba un producto'),
            (product) {
          expect(product.id, 1);
          expect(product.title, 'Producto 1');
        },
      );
    });
    test('debería retornar un error cuando el producto no existe', () async {
      when(mockProductService.getProduct(999))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final result = await fakeStorePackage.getProduct(999);

      expect(result, isA<Left>());
      result.fold(
            (error) => expect(error, contains('HTTP error: Failed to fetch data from the server')),
            (_) => fail('Se esperaba un error'),
      );
    });
  });

  test('debería retornar una lista de categorias cuando la API responde correctamente', () async {
    final jsonResponse = jsonEncode([
      "electronics",
      "jewelery",
      "men's clothing"
    ]);

    // Imprimir antes de hacer el `when`
    print("Configurando mockProductService.getCategories...");

    when(mockProductService.getCategories())
        .thenAnswer((_) async {
      print("Se llamó a mockProductService.getCategories()");
      return http.Response(jsonResponse, 200);
    });

    print("Llamando a fakeStorePackage.getCategories()...");

    final result = await fakeStorePackage.getCategories();

    print("Resultado recibido en el test: $result");

    expect(result, isA<Right>());
    result.fold(
          (error) => fail('Se esperaba una lista de productos, pero se recibió: $error'),
          (categories) {
        expect(categories.categories, isA<List<String>>());
        expect(categories.categories.length, 3);
      },
    );
  });


  test('debería retornar una lista de productos cuando la API responde correctamente', () async {
    final jsonResponse = jsonEncode([
      {"id": 1, "title": "Producto 1", "price": 100.0, "description": "Descripción 1"},
      {"id": 2, "title": "Producto 2", "price": 200.0, "description": "Descripción 2"},
    ]);


    when(mockProductService.getProductByCategory('electronics'))
        .thenAnswer((_) async => http.Response(jsonResponse, 200));

    final result = await fakeStorePackage.getProductsByCategory('electronics');

    expect(result, isA<Right>());
    result.fold(
          (error) => fail('Se esperaba una lista de productos, pero se recibió: $error'),
          (products) {
        expect(products, isA<List<Product>>());
        expect(products.length, 2);
      },
    );
  });

  test('debería retornar un error cuando la API falla', () async {
    when(mockProductService.getProductByCategory('electronics'))
        .thenAnswer((_) async => http.Response('Error interno', 500));

    final result = await fakeStorePackage.getProductsByCategory('electronics');

    expect(result, isA<Left>());
    result.fold(
          (error) => expect(error, contains('HTTP error: Failed to fetch data from the server.')),
          (_) => fail('Se esperaba un error'),
    );
  });

}
