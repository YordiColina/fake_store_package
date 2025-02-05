import 'package:chopper/chopper.dart';

import '../models/cart/cart_request.dart';

part 'cart_service.chopper.dart';

@ChopperApi()
abstract class CartService extends ChopperService {
  @Get(path: '/carts/user/{id}')
  Future<Response> getCart(@Path('id') int id);



  @Post(path: '/carts')
  Future<Response> createCart(
  @Body() CartRequest body,
  );

  @Put(path: '/carts/{id}')
  Future<Response> updateCart(@Path('id') int id,
      @Body() CartRequest body,
      );



  static CartService create() {
    final client = ChopperClient(
      baseUrl: Uri.parse('https://fakestoreapi.com'),
      services: [
        _$CartService(),
      ],
      interceptors: [
        HttpLoggingInterceptor(),
      ],
      converter: JsonConverter(),
    );
    return _$CartService(client);
  }
}


