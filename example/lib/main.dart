import 'package:fake_store_package/fake_store_package.dart';
import 'package:fake_store_package/helpers/log_printer/log_printer.dart';
import 'package:fake_store_package/models/cart/cart.dart';
import 'package:fake_store_package/models/cart/cart_request.dart';
import 'package:fake_store_package/models/user/user.dart';
import 'package:fake_store_package/models/auth/login_request.dart';
import 'package:fake_store_package/services_api/cart_service.dart';
import 'package:fake_store_package/services_api/product_service.dart';
import 'package:fake_store_package/services_api/user_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Package Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  // Instancia de FakeStorePackage para interactuar con la API de la tienda.
  final fakeStore = FakeStorePackage(
    loggerService: LoggerService(),
    productService: ProductService(client: http.Client()),
    cartService: CartService(client: http.Client()),
    userService: UserService(client: http.Client()),
  );

  String? _selectedOption; // Opción seleccionada en el dropdown de categorías.
  final LoggerService loggerService = LoggerService(); // Servicio para registrar logs.

  // Variables de estado para almacenar la información del producto, carrito, usuario y login.
  String _productTitle = '';
  String _productDescription = '';
  String _productPrice = '';
  String _productId = '';
  String _productCategory = '';
  String _productImage = '';
  String _cartProductId = '';
  String _cartProductQuantity = '';
  String _userInfo = '';
  String _cartInfo = '';
  String _loginInfo = '';
  String _cartDeletedInfo= '';

  /// Objeto de solicitud de carrito que contiene el ID de usuario, la fecha y los productos.
  /// y un objeto de productos de carrito que contiene el ID del producto y la cantidad.
  /// se usa para crear y actualizar un carrito.
  final cartRequest = CartRequest(
    userId: 1,
    date: DateTime.now(),
    products: const [
      CartProducts(productId: 1, quantity: 2),
      CartProducts(productId: 2, quantity: 1),
    ],
  );

/// Objeto de usuario que contiene la información del usuario.
  /// Se usa para crear un usuario.
  final user = User(
    email: 'john.doe@example.com',
    username: 'johndoe',
    password: 'password123',
    name: Name(firstname: 'John', lastname: 'Doe'),
    address: Address(
      city: 'New York',
      street: '123 Main St',
      number: 123,
      zipcode: '10001',
      geolocation: Geolocation(lat: '40.7128', long: '-74.0060'),
    ),
    phone: '123-456-7890',
  );

  /// Objeto de solicitud de inicio de sesión que contiene el nombre de usuario y la contraseña.
  final loginRequest = const LoginRequest(
    username: 'mor_2314',
    password: '83r5^_',
  );

  List<String> _options = ['electronics', 'jewelery', 'men\'s clothing', 'women\'s clothing']; // Categorías disponibles.

  @override
  void initState() {
    super.initState();
    obtenerProductos(); // Obtener la lista de productos al iniciar la pantalla.
    obtenerCategorias(); // Obtener las categorías disponibles al iniciar la pantalla.
    obtenerCarrito(2);   // Obtener el carrito de compras al iniciar la pantalla.
    obtenerProductoPorId(1); // Obtener el producto con ID 1 al iniciar la pantalla.
    crearUsuario(user); // Crear un usuario al iniciar la pantalla.
    crearCarrito(cartRequest); // Crear un carrito al iniciar la pantalla.
    actualizarCarrito(cartRequest,1); // Actualizar un carrito al iniciar la pantalla.
    obtenerUsuario(1); // Obtener el usuario con ID 1 al iniciar la pantalla.
    iniciarSesion(loginRequest); // Iniciar sesión al iniciar la pantalla.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Package Example')),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text("Información del producto"),
              // Textos que muestran la información del producto.
              Text('Título: $_productTitle'),
              const SizedBox(height: 20),
              Text('Descripción: $_productDescription'),
              const SizedBox(height: 20),
              Text('Precio: $_productPrice'),
              const SizedBox(height: 20),
              Text('ID: $_productId'),
              const SizedBox(height: 20),
              Text('Categoría: $_productCategory'),
              const SizedBox(height: 20),
              Image.network(
                _productImage,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child; // La imagen se cargó correctamente
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.broken_image, size: 50, color: Colors.red),
                  );
                },
              ) ,// Muestra la imagen del producto.
              const SizedBox(height: 20),
              // Dropdown para seleccionar una categoría.
              DropdownButton<String>(
                hint: const Text('Selecciona una categoría'),
                value: _selectedOption,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOption = newValue;
                  });
                  obtenerProductosPorCategoria(newValue!); // Obtener productos por categoría seleccionada.
                },
                items: _options.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text("Información del carrito de compras"),
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    // Icono de carrito.
                    const Icon(Icons.shopping_cart, size: 50),
                    const SizedBox(height: 20),
                    // Textos que muestran la información del carrito.
                    Text('ID de producto: $_cartProductId'),
                    const SizedBox(height: 20),
                    Text('Cantidad de producto: $_cartProductQuantity'),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text("Información del usuario"),
              Text(_userInfo), // Muestra la información del usuario creado.
              const SizedBox(height: 20),
              const Text("Información del carrito creado/actualizado"),
              Text(_cartInfo), // Muestra la información del carrito creado o actualizado.
              const SizedBox(height: 20),
              const Text("Información del carrito eliminado"),
              Text(_cartDeletedInfo), // Muestra la información del carrito eliminado.
              const SizedBox(height: 20),
              const Text("Información de inicio de sesión"),
              Text(_loginInfo),// Muestra la información del inicio de sesión.
            ],
          ),
        ),
      ),
    );
  }

  /**
   * Función para obtener todos los productos disponibles en la tienda.
   *
   * Esta función utiliza el método `getAllProducts` de `FakeStorePackage` para obtener
   * una lista de productos. El método devuelve un `Either<Error, List<Product>>`, donde:
   * - `Error` representa un error en la solicitud.
   * - `List<Product>` es una lista de productos obtenidos exitosamente.
   *
   * El método `fold` se utiliza para manejar ambos casos:
   * - Si hay un error, se registra el error usando `LoggerService`.
   * - Si la solicitud es exitosa, se actualiza el estado con la información del primer producto.
   *
   * Entrada: Ninguna.
   * Salida: Ninguna, pero actualiza el estado con la información del primer producto.
   */
  Future<void> obtenerProductos() async {
    final products = await fakeStore.getAllProducts();
    products.fold(
          (error) {
        // Registra el error en los logs.
        loggerService.logError('Error al obtener los productos: $error');
      },
          (products) {
        // Registra la información de los productos en los logs.
        loggerService.logInfo('Productos obtenidos:');
        for (var product in products) {
          loggerService.logInfo('Producto: ${product.title}, \$${product.price}');
        }
        // Actualiza el estado con la información del primer producto.
        setState(() {
          _productTitle = products[0].title;
          _productDescription = products[0].description;
          _productPrice = products[0].price.toString();
          _productId = products[0].id.toString();
        });
      },
    );
  }

  /**
   * Función para obtener todas las categorías disponibles en la tienda.
   *
   * Esta función utiliza el método `getCategories` de `FakeStorePackage` para obtener
   * una lista de categorías. El método devuelve un `Either<Error, CategoriesResponse>`, donde:
   * - `Error` representa un error en la solicitud.
   * - `CategoriesResponse` es un objeto que contiene una lista de categorías.
   *
   * El método `fold` se utiliza para manejar ambos casos:
   * - Si hay un error, se registra el error usando `LoggerService`.
   * - Si la solicitud es exitosa, se actualizan las opciones del dropdown con las categorías obtenidas.
   *
   * Entrada: Ninguna.
   * Salida: Ninguna, pero actualiza las opciones del dropdown con las categorías obtenidas.
   */
  Future<void> obtenerCategorias() async {
    final categoriesResult = await fakeStore.getCategories();
    categoriesResult.fold(
          (error) {
        // Registra el error en los logs.
        loggerService.logError('Error al obtener las categorías: $error');
      },
          (categories) {
        // Registra las categorías obtenidas en los logs.
        loggerService.logInfo('Categorías: ${categories.categories.join(', ')}');
        // Actualiza las opciones del dropdown con las categorías obtenidas.
        setState(() {
          _options = categories.categories;
        });
      },
    );
  }

  /**
   * Función para obtener el carrito de compras de un usuario específico.
   *
   * Esta función utiliza el método `getCart` de `FakeStorePackage` para obtener
   * el carrito de compras de un usuario. El método devuelve un `Either<Error, List<Cart>>`, donde:
   * - `Error` representa un error en la solicitud.
   * - `List<Cart>` es una lista de carritos obtenidos exitosamente.
   *
   * El método `fold` se utiliza para manejar ambos casos:
   * - Si hay un error, se registra el error usando `LoggerService`.
   * - Si la solicitud es exitosa, se actualiza el estado con la información del carrito.
   *
   * Entrada: el id del carrito a obtener como parámetro.
   * Salida: Ninguna, pero actualiza el estado con la información del carrito.
   */

  void obtenerCarrito( int id) async {
    final cart = await fakeStore.getCart(id); // Obtiene el carrito del usuario con ID 2.
    cart.fold(
          (error) {
        // Registra el error en los logs.
        loggerService.logError('Error al obtener el carrito: $error');
      },
          (cart) {
        // Registra la información del carrito en los logs.
        loggerService.logInfo('Carrito obtenido:');
        // Actualiza el estado con la información del carrito.
        setState(() {
          _cartProductId = cart[0].products[0].productId.toString();
          _cartProductQuantity = cart[0].products[0].quantity.toString();
        });
      },
    );
  }

  /**
   * Función para obtener un producto específico por su ID.
   *
   * Esta función utiliza el método `getProduct` de `FakeStorePackage` para obtener
   * un producto específico. El método devuelve un `Either<String, Product>`, donde:
   * - `String` representa un mensaje de error.
   * - `Product` es el producto obtenido exitosamente.
   *
   * El método `fold` se utiliza para manejar ambos casos:
   * - Si hay un error, se registra el error usando `LoggerService`.
   * - Si la solicitud es exitosa, se actualiza el estado con la información del producto.
   *
   * Entrada: `id` (int) - El ID del producto que se desea obtener.
   * Salida: Ninguna, pero actualiza el estado con la información del producto.
   */
  Future<void> obtenerProductoPorId(int id) async {
    final productResult = await fakeStore.getProduct(id);
    productResult.fold(
          (error) {
        // Registra el error en los logs.
        loggerService.logError('Error al obtener el producto: $error');
      },
          (product) {
        // Registra la información del producto en los logs.
        loggerService.logInfo('Producto obtenido: ${product.title}');
        // Actualiza el estado con la información del producto.
        setState(() {
          _productTitle = product.title;
          _productDescription = product.description;
          _productPrice = product.price.toString();
          _productId = product.id.toString();
          _productCategory = product.category;
          _productImage = product.image;
        });
      },
    );
  }

  /**
   * Función para obtener productos por categoría.
   *
   * Esta función utiliza el método `getProductsByCategory` de `FakeStorePackage` para obtener
   * una lista de productos filtrados por categoría. El método devuelve un `Either<String, List<Product>>`, donde:
   * - `String` representa un mensaje de error.
   * - `List<Product>` es una lista de productos obtenidos exitosamente filtrados por categoria.
   *
   * El método `fold` se utiliza para manejar ambos casos:
   * - Si hay un error, se registra el error usando `LoggerService`.
   * - Si la solicitud es exitosa, se actualiza el estado con la información del primer producto de la categoría.
   *
   * Entrada: `category` (String) - La categoría por la cual filtrar los productos.
   * Salida: Ninguna, pero actualiza el estado con la información del primer producto de la categoría.
   */
  Future<void> obtenerProductosPorCategoria(String category) async {
    final productsResult = await fakeStore.getProductsByCategory(category);
    productsResult.fold(
          (error) {
        // Registra el error en los logs.
        loggerService.logError('Error al obtener productos por categoría: $error');
      },
          (products) {
        // Registra la información de los productos en los logs.
        loggerService.logInfo('Productos obtenidos por categoría: $category');
        if (products.isNotEmpty) {
          // Actualiza el estado con la información del primer producto de la categoría.
          setState(() {
            _productTitle = products[0].title;
            _productDescription = products[0].description;
            _productPrice = products[0].price.toString();
            _productId = products[0].id.toString();
            _productCategory = products[0].category;
            _productImage = products[0].image;
          });
        }
      },
    );
  }

  /**
   * Función para crear un usuario.
   *
   * Esta función utiliza el método `createUser` de `FakeStorePackage` para crear
   * un nuevo usuario. El método devuelve un `Either<String, Map<String, dynamic>>`, donde:
   * - `String` representa un mensaje de error.
   * - `Map<String, dynamic>` es la respuesta del servidor con la información del usuario creado.
   *
   * recibe un `User` con la información del usuario a crear.
   * El método `fold` se utiliza para manejar ambos casos:
   * - Si hay un error, se registra el error usando `LoggerService`.
   * - Si la solicitud es exitosa, se actualiza el estado con la información del usuario creado.
   *
   * Entrada: un objeto de tipo User con la infomación del usuario como parámetro.
   * Salida: Ninguna, pero actualiza el estado con la información del usuario creado.
   */
  Future<void> crearUsuario( User user) async {


    final userResult = await fakeStore.createUser(user);
    userResult.fold(
          (error) {
        // Registra el error en los logs.
        loggerService.logError('Error al crear el usuario: $error');
      },
          (userInfo) {
        // Registra la información del usuario en los logs.
        loggerService.logInfo('Usuario creado: ${userInfo.toString()}');
        // Actualiza el estado con la información del usuario creado.
        setState(() {
          _userInfo = 'Usuario creado: ${userInfo['name']}, Email: ${userInfo['email']}';
        });
      },
    );
  }

  /**
   * Función para crear un carrito de compras.
   *
   * Esta función utiliza el método `createCart` de `FakeStorePackage` para crear
   * un nuevo carrito. El método devuelve un `Either<String, Map<String, dynamic>>`, donde:
   * - `String` representa un mensaje de error.
   * - `Map<String, dynamic>` es la respuesta del servidor con la información del carrito creado.
   * recibe un `CartRequest` con la información del carrito a crear.
   *
   * El método `fold` se utiliza para manejar ambos casos:
   * - Si hay un error, se registra el error usando `LoggerService`.
   * - Si la solicitud es exitosa, se actualiza el estado con la información del carrito creado.
   *
   * Entrada: un objeto de tipo CartRequest como parámetro.
   * Salida: Ninguna, pero actualiza el estado con la información del carrito creado.
   */
  Future<void> crearCarrito(CartRequest cartRequest) async {
    final cartResult = await fakeStore.createCart(cartRequest);
    cartResult.fold(
          (error) {
        // Registra el error en los logs.
        loggerService.logError('Error al crear el carrito: $error');
      },
          (cartInfo) {
        // Registra la información del carrito en los logs.
        loggerService.logInfo('Carrito creado: ${cartInfo.toString()}');
        // Actualiza el estado con la información del carrito creado.
        setState(() {
          _cartInfo = 'Carrito creado: ID ${cartInfo['id']}, Fecha: ${cartInfo['date']}';
        });
      },
    );
  }

  /**
   * Función para actualizar un carrito de compras.
   *
   * Esta función utiliza el método `updateCart` de `FakeStorePackage` para actualizar
   * un carrito existente. El método devuelve un `Either<String, Map<String, dynamic>>`, donde:
   * - `String` representa un mensaje de error.
   * - `Map<String, dynamic>` es la respuesta del servidor con la información del carrito actualizado.
   * la función recibe un `CartRequest` con la información del carrito a actualizar.
   *
   * El método `fold` se utiliza para manejar ambos casos:
   * - Si hay un error, se registra el error usando `LoggerService`.
   * - Si la solicitud es exitosa, se actualiza el estado con la información del carrito actualizado.
   *
   * Entrada: un objeto de tipo CartRequest y el id del carrito a actualizar como parámetro .
   * Salida: Ninguna, pero actualiza el estado con la información del carrito actualizado.
   */
  Future<void> actualizarCarrito(CartRequest cartRequest,int id) async {
    final cartResult = await fakeStore.updateCart(id, cartRequest); // Actualizamos el carrito con ID 1.
    cartResult.fold(
          (error) {
        // Registra el error en los logs.
        loggerService.logError('Error al actualizar el carrito: $error');
      },
          (cartInfo) {
        // Registra la información del carrito en los logs.
        loggerService.logInfo('Carrito actualizado: ${cartInfo.toString()}');
        // Actualiza el estado con la información del carrito actualizado.
        setState(() {
          _cartInfo = 'Carrito actualizado: ID ${cartInfo['id']}, Fecha: ${cartInfo['date']}';
        });
      },
    );
  }

  /**
   * Función para eliminar un carrito de compras.
   *
   * Esta función utiliza el método `deleteCart` de `FakeStorePackage` para actualizar
   * un carrito existente. El método devuelve un `Either<String, Map<String, dynamic>>`, donde:
   * - `String` representa un mensaje de error.
   * - `Map<String, dynamic>` es la respuesta del servidor con la información del carrito eliminado.
   * la función recibe un id de tipo int  del carrito a eliminar.
   * originalmente no borra el carrito de la api solo lo marca como eliminado y te devuelve la info del carro eliminado.
   *
   * El método `fold` se utiliza para manejar ambos casos:
   * - Si hay un error, se registra el error usando `LoggerService`.
   * - Si la solicitud es exitosa, se actualiza el estado con la información del carrito eliminado.
   *
   * Entrada: el id del producto a eliminar como parámetro.
   * Salida: Ninguna, pero actualiza el estado con la información del carrito eliminado.
   */
  Future<void> eliminarCarrito(int id) async {
    final cartResult = await fakeStore.deleteCart(id); // eliminamos el carrito con ID 1.
    cartResult.fold(
          (error) {
        // Registra el error en los logs.
        loggerService.logError('Error al eliminar el carrito: $error');
      },
          (cartInfo) {
        // Registra la información del carrito en los logs.
        loggerService.logInfo('Carrito eliminado: ${cartInfo.toString()}');
        // Actualiza el estado con la información del carrito eliminado.
        setState(() {
          _cartDeletedInfo = 'Carrito eliminado: ID ${cartInfo['id']}, Fecha: ${cartInfo['date']}';
        });
      },
    );
  }

  /**
   * Función para obtener un usuario específico por su ID.
   *
   * Esta función utiliza el método `getUser` de `FakeStorePackage` para obtener
   * un usuario específico. El método devuelve un `Either<String, User>`, donde:
   * - `String` representa un mensaje de error.
   * - `User` es el usuario obtenido exitosamente.
   *
   * El método `fold` se utiliza para manejar ambos casos:
   * - Si hay un error, se registra el error usando `LoggerService`.
   * - Si la solicitud es exitosa, se actualiza el estado con la información del usuario.
   *
   * Entrada: `id` (int) - El ID del usuario que se desea obtener.
   * Salida: Ninguna, pero actualiza el estado con la información del usuario.
   */
  Future<void> obtenerUsuario(int id) async {
    final userResult = await fakeStore.getUser(id);
    userResult.fold(
          (error) {
        // Registra el error en los logs.
        loggerService.logError('Error al obtener el usuario: $error');
      },
          (user) {
        // Registra la información del usuario en los logs.
        loggerService.logInfo('Usuario obtenido: ${user.username}');
        // Actualiza el estado con la información del usuario.
        setState(() {
          _userInfo = 'Usuario obtenido: ${user.name.firstname} ${user.name.lastname}, Email: ${user.email}';
        });
      },
    );
  }

  /**
   * Función para iniciar sesión.
   *
   * Esta función utiliza el método `login` de `FakeStorePackage` para iniciar sesión.
   * El método devuelve un `Either<String, Map<String, dynamic>>`, donde:
   * - `String` representa un mensaje de error.
   * - `Map<String, dynamic>` es la respuesta del servidor con la información del inicio de sesión.
   * recibe un `LoginRequest` que contiene el nombre de usuario y la contraseña.
   *
   * El método `fold` se utiliza para manejar ambos casos:
   * - Si hay un error, se registra el error usando `LoggerService`.
   * - Si la solicitud es exitosa, se actualiza el estado con la información del inicio de sesión.
   *
   * Entrada: un objeto de tipo LoginRequest con la información del usuario(user, password) como parámetro.
   * Salida: Ninguna, pero actualiza el estado con la información del inicio de sesión.
   */
  Future<void> iniciarSesion(LoginRequest loginRequest) async {
    final loginResult = await fakeStore.login(loginRequest);
    loginResult.fold(
          (error) {
            print(loginResult);
        // Registra el error en los logs.
        loggerService.logError('Error al iniciar sesión: $error');
      },
          (loginInfo) {
        // Registra la información del inicio de sesión en los logs.
        loggerService.logInfo('Inicio de sesión exitoso: ${loginInfo.toString()}');
        // Actualiza el estado con la información del inicio de sesión.
        setState(() {
          _loginInfo = 'Inicio de sesión exitoso: Token ${loginInfo['token']}';
        });
      },
    );
  }
}