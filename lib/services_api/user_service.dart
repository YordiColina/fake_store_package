import 'package:chopper/chopper.dart';

import '../models/user/user.dart';

part 'user_service.chopper.dart';

@ChopperApi()
abstract class UserService extends ChopperService {
  @Get(path: '/user/{id}')
  Future<Response> getUser(@Path('id') int id);


  @Post(path: '/users')
  Future<Response> createUser(
      @Body() User body,
      );

  @Post(path: '/auth/login')
  Future<Response> login(
      @Body() Map<String, dynamic> body,
      );

  static UserService create() {
    final client = ChopperClient(
      baseUrl: Uri.parse('https://fakestoreapi.com'),
      services: [
        _$UserService(),
      ],
      interceptors: [
        HttpLoggingInterceptor(),
      ],
      converter: const JsonConverter(),
    );
    return _$UserService(client);
  }
}


