import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:fake_store_package/models/cart/cart_request.dart';
import 'package:fake_store_package/models/user/get_user.dart';
import 'package:fake_store_package/services_api/cart_service.dart';
import 'package:fake_store_package/services_api/product_service.dart';
import 'package:fake_store_package/services_api/user_service.dart';
import 'helpers/api_errors/api_error_handler.dart';
import 'helpers/log_printer/log_printer.dart';
import 'models/cart/cart.dart';
import 'models/categories/categories.dart';
import 'models/products/product.dart';
import 'models/user/user.dart';

class FakeStorePackage {
  final LoggerService _loggerService = LoggerService();
  final ProductService _productService = ProductService.create();
  final CartService _cartService = CartService.create();
  final UserService _userService = UserService.create();

  Future<Either<String, List<Product>>> getAllProducts() async {
    return await ApiErrorHandler.execute(() async {
      final response = await _productService.getAllProducts();
      if (response.isSuccessful) {
        if (response.body is List<dynamic>) {
          final List<Product> products =
          (response.body as List).map((e) => Product.fromJson(e)).toList();
          for (var product in products) {
            _loggerService.logProductDetails(product, response.statusCode);
          }
          return products;
        } else {
          throw FormatException('Unexpected response format: ${response.body}');
        }
      } else {
        throw HttpException(
            'API Error: ${response.statusCode} - ${response.error ?? "Unknown error"}');
      }
    });
  }

  Future<Either<String, Product>> getProduct(int id) async {
    return await ApiErrorHandler.execute(() async {
      final response = await _productService.getProduct(id);
      if (response.isSuccessful) {
        return Product.fromJson(response.body);
      } else {
        throw HttpException(
            'API Error: ${response.statusCode} - ${response.error ?? "Unknown error"}');
      }
    });
  }

  Future<Either<String, Categories>> getCategories() async {
    return await ApiErrorHandler.execute(() async {
      final response = await _productService.getCategories();
      if (response.isSuccessful) {
        final data = response.body as List<dynamic>;
        final Categories categories = Categories.fromJson(data);
        _loggerService.logInfo(
            'Categorías obtenidas correctamente\n ${response.statusCode}\n ${categories.categories}');
        return categories;
      } else {
        throw HttpException(
            'API Error: ${response.statusCode} - ${response.error ?? "Unknown error"}');
      }
    });
  }

  Future<Either<String, List<Product>>> getProductByCategory(String category) async {
    return await ApiErrorHandler.execute(() async {
      final response = await _productService.getProductByCategory(category);
      if (response.isSuccessful) {
        return (response.body as List).map((e) => Product.fromJson(e)).toList();
      } else {
        throw HttpException(
            'API Error: ${response.statusCode} - ${response.error ?? "Unknown error"}');
      }
    });
  }

  Future<Either<String, List<Cart>>> getCart(int id) async {
    return await ApiErrorHandler.execute(() async {
      final response = await _cartService.getCart(id);

      if (response.isSuccessful) {
        final data = response.body;
        if (data is List) {
          final List<Cart> carts = data
              .map((cartData) => Cart.fromJson(cartData as Map<String, dynamic>))
              .toList();
          for (var cart in carts) {
            _loggerService.logInfo(
              'Carrito obtenido correctamente\n ${response.statusCode}\ncarrito nro ${cart.id}\n'
                  'productos en carrito: ${cart.products.length}',
            );
          }
          return carts;
        } else {
          throw Exception('Respuesta inesperada: Se esperaba una lista, pero se recibió otro tipo de dato.');
        }
      } else {
        throw HttpException(
            'API Error: ${response.statusCode} - ${response.error ?? "Unknown error"}');
      }
    });
  }

  Future<Either<String, GetUser>> getUser(int id) async {
    return await ApiErrorHandler.execute(() async {
      final response = await _userService.getUser(id);
      if (response.isSuccessful) {
        return GetUser.fromJson(response.body);
      } else {
        throw HttpException(
            'API Error: ${response.statusCode} - ${response.error ?? "Unknown error"}');
      }
    });
  }

  Future<Either<String, Map<String, dynamic>>> createUser(User body) async {
    return await ApiErrorHandler.execute(() async {
      final response = await _userService.createUser(body);
      if (response.isSuccessful) {
        return response.body as Map<String, dynamic>;
      } else {
        throw HttpException(
            'API Error: ${response.statusCode} - ${response.error ?? "Unknown error"}');
      }
    });
  }

  Future<Either<String, Map<String, dynamic>>> login(Map<String, dynamic> body) async {
    return await ApiErrorHandler.execute(() async {
      final response = await _userService.login(body);
      if (response.isSuccessful) {
        return response.body as Map<String, dynamic>;
      } else {
        throw HttpException(
            'API Error: ${response.statusCode} - ${response.error ?? "Unknown error"}');
      }
    });
  }

  Future<Either<String, Map<String, dynamic>>> createCart(CartRequest body) async {
    return await ApiErrorHandler.execute(() async {
      final response = await _cartService.createCart(body);
      if (response.isSuccessful) {
        return response.body as Map<String, dynamic>;
      } else {
        throw HttpException(
            'API Error: ${response.statusCode} - ${response.error ?? "Unknown error"}');
      }
    });
  }

  Future<Either<String, Map<String, dynamic>>> updateCart(int id, CartRequest body) async {
    return await ApiErrorHandler.execute(() async {
      final response = await _cartService.updateCart(id, body);
      if (response.isSuccessful) {
        return response.body as Map<String, dynamic>;
      } else {
        throw HttpException(
            'API Error: ${response.statusCode} - ${response.error ?? "Unknown error"}');
      }
    });
  }
}
