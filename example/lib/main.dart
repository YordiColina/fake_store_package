import 'package:fake_store_package/fake_store_package.dart';
import 'package:fake_store_package/helpers/log_printer/log_printer.dart';
import 'package:fake_store_package/models/cart/cart_request.dart';
import 'package:fake_store_package/models/user/user.dart';

void main() async {
  // Instancia del servicio de logs para imprimir mensajes en consola de manera ordenada
  final LoggerService loggerService = LoggerService();
  // Instancia del paquete de FakeStore para interactuar con la API de FakeStore
  final fakeStore = FakeStorePackage();

  // Obtener todos los productos
  loggerService.logInfo('Obteniendo todos los productos...');
  try {
    final products = await fakeStore.getAllProducts();
    products.fold(
        (error) => loggerService.logError('Error al obtener los productos: $error'),

        (products) {
          loggerService.logInfo('Productos obtenidos:');
          for (var product in products) {
            loggerService.logInfo(
                'Producto: ${product.title}, \$${product.price}');
          }
        } );
  } catch (e) {
    loggerService.logError('Error al obtener los productos: $e');
  }


  // Obtener detalles de un producto por ID
  loggerService.logInfo('\nObteniendo detalles del producto con ID 1...');
  final productResult = await fakeStore.getProduct(1);
  productResult.fold(
        (error) => loggerService.logError('Error al obtener el producto: $error'),
        (product) => loggerService.logInfo('Producto obtenido: ${product.title}, \$${product.price}'),
  );

  // Obtener categorías de productos
  loggerService.logInfo('\nObteniendo categorías...');
  final categoriesResult = await fakeStore.getCategories();
  categoriesResult.fold(
        (error) => loggerService.logError('Error al obtener las categorías: $error'),
        (categories) => loggerService.logInfo('Categorías: ${categories.categories.join(', ')}'),
  );

  // Crear un usuario
  loggerService.logInfo('\nCreando un usuario...');
  final newUser = User(
    name: Name(firstname: "carlos", lastname: "perez"),
    email: 'carlos@example.com',
    username: 'carlos123',
    password: 'password123',
    address: Address(city: "Bogotá", street: "100", number: 7,
        zipcode: "001", geolocation: Geolocation(lat: "454564", long: "54545")),
    phone: '1234567890',
  );
  final userCreationResult = await fakeStore.createUser(newUser);
  userCreationResult.fold(
        (error) => loggerService.logError('Error al crear el usuario: $error'),
        (response) => loggerService.logInfo('Usuario creado exitosamente: ${response['id']}'),
  );

  // Crear un carrito de compras
  loggerService.logInfo('\nCreando un carrito de compras...');
  final newCart = CartRequest(
    userId: 1,
    date: DateTime.now(),
    products: const [CartProducts(productId: 1, quantity: 2)]
  );
  final cartCreationResult = await fakeStore.createCart(newCart);
  cartCreationResult.fold(
        (error) => loggerService.logError('Error al crear el carrito: $error'),
        (response) => loggerService.logInfo('Carrito creado exitosamente: ${response['id']}'),
  );

  // Obtener un carrito por ID
  loggerService.logInfo('\nObteniendo el carrito con ID 1...');
  final cartResult = await fakeStore.getCart(1);
  cartResult.fold(
        (error) => loggerService.logError('Error al obtener el carrito: $error'),
        (cart) {
          loggerService.logInfo('Carrito obtenido: ID ${cart.id}');
      for (var item in cart.products) {
        loggerService.logInfo('Producto ${item.productId}, Cantidad: ${item.quantity}');
      }
    },
  );

  // Ejemplo de login
  final loginBody = {'username': 'john_doe', 'password': 'password123'};
  final loginResult = await fakeStore.login(loginBody);
  loginResult.fold(
        (apiError) => loggerService.logError('API Error during login: $apiError'),
        (success) => loggerService.logInfo('Login successful! Token: ${success['token']}'),
  );

  // Obtener productos por categoría
  const category = 'electronics';
  final productsResult = await fakeStore.getProductByCategory(category);
  productsResult.fold(
        (apiError) => loggerService.logError('API Error fetching products: $apiError'),
        (products) {
          loggerService.logInfo('Products in category "$category":');
      for (var product in products) {
        loggerService.logInfo(' - ${product.title} (\$${product.price})');
      }
    },
  );

  // Obtener un usuario por ID y mostrar sus detalles
  const userId = 1;
  final userResult = await fakeStore.getUser(userId);
  userResult.fold(
        (apiError) => loggerService.logError('API Error fetching user: $apiError'),
        (user) => loggerService.logInfo('User details: ${user.name}, Email: ${user.email}'),
  );

  // Actualizar carrito de compras
  const cartId = 1;
  final cartRequest = CartRequest(
    userId: 1,
    date: DateTime.now(),
    products: const [
      CartProducts(productId: 1, quantity: 2),
      CartProducts(productId: 2, quantity: 1),
    ],
  );
  final updateCartResult = await fakeStore.updateCart(cartId, cartRequest);
  updateCartResult.fold(
        (apiError) => loggerService.logError('API Error updating cart: $apiError'),
        (success) => loggerService.logInfo('Cart updated successfully: $success'),
  );

}
