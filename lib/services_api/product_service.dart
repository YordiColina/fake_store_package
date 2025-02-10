import 'package:chopper/chopper.dart';


part 'product_service.chopper.dart';

@ChopperApi()
abstract class ProductService extends ChopperService {
  @Get(path: '/products')
  Future<Response> getAllProducts();

  @Get(path: '/products/{id}')
  Future<Response> getProduct(@Path('id') int id);

  @Get(path: '/products/category/{category}')
  Future<Response> getProductByCategory(@Path('category') String category);

  @Get(path: '/products/categories')
  Future<Response> getCategories();

  static ProductService create() {
    final client = ChopperClient(
      baseUrl: Uri.parse('https://fakestoreapi.com'),
      services: [
        _$ProductService(),
      ],
      interceptors: [
        HttpLoggingInterceptor(),
      ],
      converter: JsonConverter(),
    );
    return _$ProductService(client);
  }
}


