import 'package:http/http.dart' as http;

class ProductService {
  final String baseUrl = 'https://fakestoreapi.com/products';
  final http.Client client;

  ProductService({required this.client});

  Future<http.Response> getAllProducts() async {
    return await client.get(Uri.parse(baseUrl));
  }

  Future<http.Response> getProduct(int id) async {
    return await client.get(Uri.parse('$baseUrl/$id'));
  }

  Future<http.Response> getProductByCategory(String category) async {
    return await client.get(Uri.parse('$baseUrl/category/$category'));
  }

  Future<http.Response> getCategories() async {
    return await client.get(Uri.parse('$baseUrl/categories'));
  }
}
