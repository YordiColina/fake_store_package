import 'package:fake_store_package/services_api/product_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;


@GenerateMocks([http.Client])
import 'product_service_test.mocks.dart';

void main() {
  late ProductService productService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    productService = ProductService(client: mockClient);
  });

  group('ProductService Tests', () {
    test('getAllProducts devuelve código 200', () async {
      when(mockClient.get(Uri.parse('https://fakestoreapi.com/products')))
          .thenAnswer((_) async => http.Response('[]', 200));

      final response = await productService.getAllProducts();
      expect(response.statusCode, 200);
    });

    test('getProduct devuelve código 200', () async {
      when(mockClient.get(Uri.parse('https://fakestoreapi.com/products/1')))
          .thenAnswer((_) async => http.Response('{"id":1, "title":"Producto"}', 200));

      final response = await productService.getProduct(1);
      expect(response.statusCode, 200);
    });

    test('getProductByCategory devuelve código 200', () async {
      when(mockClient.get(Uri.parse('https://fakestoreapi.com/products/category/electronics')))
          .thenAnswer((_) async => http.Response('[]', 200));

      final response = await productService.getProductByCategory('electronics');
      expect(response.statusCode, 200);
    });

    test('getCategories devuelve código 200', () async {
      when(mockClient.get(Uri.parse('https://fakestoreapi.com/products/categories')))
          .thenAnswer((_) async => http.Response('["electronics", "jewelery"]', 200));

      final response = await productService.getCategories();
      expect(response.statusCode, 200);
    });

    test('getProduct devuelve error 404 si el producto no existe', () async {
      when(mockClient.get(Uri.parse('https://fakestoreapi.com/products/999')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final response = await productService.getProduct(999);
      expect(response.statusCode, 404);
    });
  });
}
