import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:fake_store_package/models/auth/login_request.dart';
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

/// Clase principal para interactuar con la API de Fake Store.
///
/// Esta clase proporciona métodos para:
/// - Obtener productos, categorías, carritos y usuarios.
/// - Crear usuarios, iniciar sesión y gestionar carritos.
///
/// Utiliza los siguientes servicios:
/// - `ProductService`: Para interactuar con los endpoints relacionados con productos.
/// - `CartService`: Para interactuar con los endpoints relacionados con carritos.
/// - `UserService`: Para interactuar con los endpoints relacionados con usuarios.
/// - `LoggerService`: Para registrar información y errores durante las operaciones.
class FakeStorePackage {
  final LoggerService loggerService;
  final ProductService? _productService;
  final CartService? _cartService;
  final UserService? _userService;

  FakeStorePackage({
    required this.loggerService,
    ProductService? productService,
    CartService? cartService,
    UserService? userService,
  })  : _productService = productService,
        _cartService = cartService,
        _userService = userService;


  /// Obtiene todos los productos disponibles en la API.
  ///
  /// **Entradas**: Ninguna.
  ///
  /// **Proceso**:
  /// 1. Realiza una solicitud a la API para obtener todos los productos.
  /// 2. Si la respuesta es exitosa, convierte los datos JSON en una lista de objetos `Product`.
  /// 3. Registra los detalles de cada producto utilizando `_loggerService`.
  /// 4. Devuelve la lista de productos.
  ///
  /// **Retorna**:
  /// - `Either<String, List<Product>>`: Una lista de productos si la solicitud es exitosa,
  ///   o un mensaje de error si falla.
  Future<Either<String, List<Product>>> getAllProducts() async {
    return await ApiErrorHandler.execute(() async {
      final response = await _productService?.getAllProducts();

      if (response != null && response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        final List<Product> products = jsonData.map((e) => Product.fromJson(e)).toList();

        for (var product in products) {
          loggerService.logProductDetails(product, response.statusCode);
        }

        return products;
      } else {
        throw HttpException(
            ' ${response?.statusCode} - ${response?.reasonPhrase ?? "Unknown error"}');
      }
    });
  }

  /// Obtiene un producto específico por su ID.
  ///
  /// **Entradas**:
  /// - `id`: El ID del producto a obtener.
  ///
  /// **Proceso**:
  /// 1. Realiza una solicitud a la API para obtener un producto específico por su ID.
  /// 2. Si la respuesta es exitosa, convierte los datos JSON en un objeto `Product`.
  /// 3. Devuelve el producto.
  ///
  /// **Retorna**:
  /// - `Either<String, Product>`: El producto si la solicitud es exitosa,
  ///   o un mensaje de error si falla.
  Future<Either<String, Product>> getProduct(int id) async {
    return await ApiErrorHandler.execute(() async {
      final response = await _productService?.getProduct(id);
      if (response != null && response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return Product.fromJson(jsonData);
      } else {
        throw HttpException(
            'API Error: ${response?.statusCode} - ${response?.reasonPhrase ?? "Unknown error"}');
      }
    });
  }

  /// Obtiene todas las categorías de productos disponibles en la API.
  ///
  /// **Entradas**: Ninguna.
  ///
  /// **Proceso**:
  /// 1. Realiza una solicitud a la API para obtener todas las categorías.
  /// 2. Si la respuesta es exitosa, convierte los datos JSON en un objeto `Categories`.
  /// 3. Registra la información de las categorías utilizando `_loggerService`.
  /// 4. Devuelve el objeto `Categories`.
  ///
  /// **Retorna**:
  /// - `Either<String, Categories>`: Un objeto `Categories` si la solicitud es exitosa,
  ///   o un mensaje de error si falla.
  Future<Either<String, Categories>> getCategories() async {
    return await ApiErrorHandler.execute(() async {
      final response = await _productService?.getCategories();

      if (response != null && response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = jsonDecode(response.body);

        // Verificar si jsonData es realmente una lista de strings
        if (jsonData is List && jsonData.every((element) => element is String)) {
          final Categories categories = Categories.fromJson(jsonData);

          loggerService.logInfo(
              'Categorías obtenidas correctamente\n ${response.statusCode}\n ${categories.categories}'
          );

          return categories;
        } else {
          throw FormatException('Formato incorrecto: se esperaba una lista de strings');
        }
      } else {
        throw HttpException(
            'API Error: ${response?.statusCode} - ${response?.reasonPhrase ?? "Unknown error"}'
        );
      }
    });
  }


  /// Obtiene todos los productos de una categoría específica.
  ///
  /// **Entradas**:
  /// - `category`: La categoría de los productos a obtener.
  ///
  /// **Proceso**:
  /// 1. Realiza una solicitud a la API para obtener todos los productos de una categoría específica.
  /// 2. Si la respuesta es exitosa, convierte los datos JSON en una lista de objetos `Product`.
  /// 3. Devuelve la lista de productos.
  ///
  /// **Retorna**:
  /// - `Either<String, List<Product>>`: Una lista de productos si la solicitud es exitosa,
  ///   o un mensaje de error si falla.
  Future<Either<String, List<Product>>> getProductsByCategory(String category) async {
    return await ApiErrorHandler.execute(() async {
      final response = await _productService?.getProductByCategory(category);

      loggerService.logInfo('Respuesta de la API: ${response?.body}'); // Debugging

      if (response != null && response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((e) => Product.fromJson(e)).toList();
      } else {
        throw HttpException(
            'API Error: ${response?.statusCode} - ${response?.reasonPhrase ?? "Unknown error"}');
      }
    });
  }


  /// Obtiene el carrito de compras de un usuario específico por su ID.
  ///
  /// **Entradas**:
  /// - `id`: El ID del usuario cuyo carrito se desea obtener.
  ///
  /// **Proceso**:
  /// 1. Realiza una solicitud a la API para obtener el carrito de un usuario específico.
  /// 2. Si la respuesta es exitosa, convierte los datos JSON en una lista de objetos `Cart`.
  /// 3. Registra la información del carrito utilizando `_loggerService`.
  /// 4. Devuelve la lista de carritos.
  ///
  /// **Retorna**:
  /// - `Either<String, List<Cart>>`: Una lista de carritos si la solicitud es exitosa,
  ///   o un mensaje de error si falla.
  Future<Either<String, List<Cart>>> getCart(int id) async {
    return await ApiErrorHandler.execute(() async {
      final response = await _cartService?.getCart(id);

      if ( response != null && response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        final List<Cart> carts = jsonData
            .map((cartData) => Cart.fromJson(cartData as Map<String, dynamic>))
            .toList();

        for (var cart in carts) {
          loggerService.logInfo(
            'Carrito obtenido correctamente\n ${response.statusCode}\nCarrito nro ${cart.id}\n'
                'Productos en carrito: ${cart.products.length}',
          );
        }
        return carts;
      } else {
        throw HttpException(
            'API Error: ${response?.statusCode} - ${response?.reasonPhrase ?? "Unknown error"}');
      }
    });
  }

  /// Obtiene la información de un usuario específico por su ID.
  ///
  /// **Entradas**:
  /// - `id`: El ID del usuario a obtener.
  ///
  /// **Proceso**:
  /// 1. Realiza una solicitud a la API para obtener la información de un usuario específico.
  /// 2. Si la respuesta es exitosa, convierte los datos JSON en un objeto `GetUser`.
  /// 3. Devuelve el objeto `GetUser`.
  ///
  /// **Retorna**:
  /// - `Either<String, GetUser>`: Un objeto `GetUser` si la solicitud es exitosa,
  ///   o un mensaje de error si falla.
  Future<Either<String, GetUser>> getUser(int id) async {
    return await ApiErrorHandler.execute(() async {
      final response = await _userService?.getUser(id);

      if (response != null && response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return GetUser.fromJson(jsonData);
      } else {
        throw HttpException(
            'API Error: ${response?.statusCode} - ${response?.reasonPhrase ?? "Unknown error"}');
      }
    });
  }

  /// Crea un nuevo usuario en la API.
  ///
  /// **Entradas**:
  /// - `body`: Un objeto `User` que contiene la información del usuario a crear.
  ///
  /// **Proceso**:
  /// 1. Realiza una solicitud a la API para crear un nuevo usuario.
  /// 2. Si la respuesta es exitosa, devuelve la respuesta de la API como un mapa.
  ///
  /// **Retorna**:
  /// - `Either<String, Map<String, dynamic>>`: Un mapa con la respuesta de la API si la solicitud es exitosa,
  ///   o un mensaje de error si falla.
  Future<Either<String, Map<String, dynamic>>> createUser(User body) async {
    return await ApiErrorHandler.execute(() async {
      final response = await _userService?.createUser(body);

      if (response != null && response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw HttpException(
            'API Error: ${response?.statusCode} - ${response?.reasonPhrase ?? "Unknown error"}');
      }
    });
  }

  /// Inicia sesión en la API con las credenciales proporcionadas.
  ///
  /// **Entradas**:
  /// - `body`: Un mapa que contiene las credenciales del usuario (usuario y contraseña).
  ///
  /// **Proceso**:
  /// 1. Realiza una solicitud a la API para iniciar sesión.
  /// 2. Si la respuesta es exitosa, devuelve la respuesta de la API como un mapa.
  ///
  /// **Retorna**:
  /// - `Either<String, Map<String, dynamic>>`: Un mapa con la respuesta de la API si la solicitud es exitosa,
  ///   o un mensaje de error si falla.
  Future<Either<String, Map<String, dynamic>>> login(LoginRequest body) async {
    return await ApiErrorHandler.execute(() async {
      final response = await _userService?.login(body.toJson());

      if (response != null && response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw HttpException(
            'API Error: ${response?.statusCode} - ${response?.reasonPhrase ?? "Unknown error"}');
      }
    });
  }

  /// Crea un nuevo carrito de compras en la API.
  ///
  /// **Entradas**:
  /// - `body`: Un objeto `CartRequest` que contiene la información del carrito a crear.
  ///
  /// **Proceso**:
  /// 1. Realiza una solicitud a la API para crear un nuevo carrito.
  /// 2. Si la respuesta es exitosa, devuelve la respuesta de la API como un mapa.
  ///
  /// **Retorna**:
  /// - `Either<String, Map<String, dynamic>>`: Un mapa con la respuesta de la API si la solicitud es exitosa,
  ///   o un mensaje de error si falla.
  Future<Either<String, Map<String, dynamic>>> createCart(CartRequest body) async {
    return await ApiErrorHandler.execute(() async {
      final response = await _cartService?.createCart(body);

      if (response != null && response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw HttpException(
            'API Error: ${response?.statusCode} - ${response?.reasonPhrase ?? "Unknown error"}');
      }
    });
  }

  /// Actualiza un carrito de compras existente en la API.
  ///
  /// **Entradas**:
  /// - `id`: El ID del carrito a actualizar.
  /// - `body`: Un objeto `CartRequest` que contiene la información actualizada del carrito.
  ///
  /// **Proceso**:
  /// 1. Realiza una solicitud a la API para actualizar un carrito existente.
  /// 2. Si la respuesta es exitosa, devuelve la respuesta de la API como un mapa.
  ///
  /// **Retorna**:
  /// - `Either<String, Map<String, dynamic>>`: Un mapa con la respuesta de la API si la solicitud es exitosa,
  ///   o un mensaje de error si falla.
  Future<Either<String, Map<String, dynamic>>> updateCart(int id, CartRequest body) async {
    return await ApiErrorHandler.execute(() async {
      final response = await _cartService?.updateCart(id, body);

      if (response != null && response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw HttpException(
            'API Error: ${response?.statusCode} - ${response?.reasonPhrase ?? "Unknown error"}');
      }
    });
  }

  /// Eliminas un carrito de compras existente en la API.
  ///
  /// **Entradas**:
  /// - `id`: El ID del carrito a eliminar.
  /// - `
  ///
  /// **Proceso**:
  /// 1. Realiza una solicitud a la API para eliminar un carrito existente.
  /// 2. Si la respuesta es exitosa, devuelve la respuesta de la API como un mapa con la información del carrito eliminado.
  ///
  /// **Retorna**:
  /// - `Either<String, Map<String, dynamic>>`: Un mapa con la respuesta de la API si la solicitud es exitosa,
  ///   o un mensaje de error si falla.
  Future<Either<String, Map<String, dynamic>>> deleteCart(int id) async {
    return await ApiErrorHandler.execute(() async {
      final response = await _cartService?.deleteCart(id);

      if (response != null && response.statusCode >= 200 && response.statusCode < 300) {
        // Si el cuerpo está vacío, devolvemos un mapa vacío en lugar de intentar jsonDecode.
        return response.body.isNotEmpty ? jsonDecode(response.body) as Map<String, dynamic> : {};
      } else {
        throw HttpException(
            'API Error: ${response?.statusCode} - ${response?.reasonPhrase ?? "Unknown error"}');
      }
    });
  }

}