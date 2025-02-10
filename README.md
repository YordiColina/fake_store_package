# Fake Store Package

`fake_store_package` es un paquete Flutter diseñado para interactuar de manera eficiente y segura con la Fake Store API. Este paquete simplifica la obtención y gestión de datos como productos, categorías, carritos de compras y usuarios, utilizando Chopper como cliente HTTP para garantizar un manejo robusto de solicitudes y respuestas.

## Características principales

- **Obtener productos:** Lista todos los productos o filtra por categoría.
- **Obtener categorías:** Lista todas las categorías disponibles.
- **Gestionar carritos:** Crear, actualizar y obtener carritos de compras.
- **Gestionar usuarios:** Crear, obtener y autenticar usuarios.
- **Manejo de errores:** Usa Either para manejar errores de manera segura.
- **Seguridad:** Utiliza Chopper para realizar solicitudes HTTP de manera segura y eficiente.

## Instalación

Agrega el paquete a tu archivo `pubspec.yaml`:

```yaml
dependencies:
  fake_store_package:
    git :
      url: 'https://github.com/YordiColina/fake_store_package.git'  //aqui va la url de el package en git hub
      ref: 'master' //aqui va la rama de el package en este caso master
      path: '/..' //aqui va la carpeta donde se encuentra el package solo si cuentas con mas de uno

```

Luego, ejecuta:

```bash
flutter pub get
```

## Uso básico

### 1. Instanciar el paquete
Para comenzar, crea una instancia de `FakeStorePackage`:

```dart
final fakeStore = FakeStorePackage();
```

### 2. Obtener todos los productos
Puedes obtener todos los productos disponibles en la tienda:


final result = await fakeStore.getAllProducts();
result.fold(
  (error) => print('Error: $error'),
  (products) => products.forEach((product) => print(product.title)),
);
```

### 3. Obtener productos por categoría
Filtra productos por una categoría específica:


final result = await fakeStore.getProductsByCategory('electronics');
result.fold(
  (error) => print('Error: $error'),
  (products) => products.forEach((product) => print(product.title)),
);
```

### 4. Crear un carrito de compras
Crea un nuevo carrito de compras:
ingresa un objeto carRequest y un  id de producto y la cantidad que deseas agregar al carrito.

final cartRequest = CartRequest(
  userId: 1,
  date: DateTime.now(),
  products: [
    CartProducts(productId: 1, quantity: 2),
    CartProducts(productId: 2, quantity: 1),
  ],
);

final result = await fakeStore.createCart(cartRequest);
result.fold(
  (error) => print('Error: $error'),
  (cart) => print('Carrito creado: ${cart.id}'),
);
```

### 5. Iniciar sesión
Autentica a un usuario:

```dart
final loginRequest = LoginRequest(
  username: 'johndoe',
  password: 'password123',
);

final result = await fakeStore.login(loginRequest.toJson());
result.fold(
  (error) => print('Error: $error'),
  (loginInfo) => print('Token: ${loginInfo.token}'),
);
```

## Casos de uso

### 1. Integración en una aplicación de comercio electrónico
- **Obtener productos:** Muestra una lista de productos en la página principal.
- **Filtrar por categoría:** Permite a los usuarios filtrar productos por categoría.
- **Gestionar carritos:** Permite a los usuarios agregar productos a su carrito y realizar compras.
- **Autenticación de usuarios:** Permite a los usuarios iniciar sesión y gestionar su perfil.

### 2. Aplicación de gestión de inventario
- **Obtener productos:** Muestra el inventario de productos disponibles.
- **Actualizar carritos:** Actualiza el inventario cuando se realizan ventas.
- **Gestionar usuarios:** Controla el acceso de los empleados a la aplicación.

## ¿Por qué usar Chopper?

### 1. Seguridad
- **Interceptores:** Permite agregar lógica personalizada antes o después de las solicitudes.
- **Validación de certificados:** Asegura que las solicitudes se realicen a servidores confiables.
- **Manejo de errores:** Proporciona un manejo robusto de errores, reduciendo riesgos.

### 2. Eficiencia
- **Serialización automática:** Convierte respuestas JSON en objetos Dart automáticamente.
- **Caché:** Almacena respuestas para mejorar el rendimiento.
- **Concurrencia:** Maneja múltiples solicitudes de manera eficiente.

### 3. Flexibilidad
- **Personalización:** Permite adaptar las solicitudes HTTP a las necesidades específicas.
- **Compatibilidad:** Funciona perfectamente con otras bibliotecas de Flutter como Provider o Bloc.

### ¿Cómo funciona Chopper?
1. Definición de servicios
* Chopper funciona a través de servicios que definen las solicitudes HTTP como métodos de Dart. Cada servicio usa anotaciones para describir los endpoints y métodos HTTP.
- Ejemplo de definición de un servicio:
```dart
@ChopperApi()
abstract class ProductService extends ChopperService {
  @Get(path: '/products')
  Future<Response<List<Product>>> getAllProducts();
  
  static ProductService create([ChopperClient? client]) =>
      _ProductService(client);
}
```

2. # Uso de interceptores
*Chopper permite interceptar solicitudes y respuestas, lo que facilita agregar autenticación o manejar errores.
- Ejemplo de un interceptor de autenticación:
```dart
class AuthInterceptor implements RequestInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) {
    final updatedHeaders = Map<String, String>.from(request.headers)
      ..['Authorization'] = 'Bearer YOUR_TOKEN';
    return request.copyWith(headers: updatedHeaders);
  }
}
```

3. # Serialización automática
* Chopper puede serializar y deserializar JSON automáticamente con json_serializable.
- Ejemplo:
```dart
@JsonSerializable()
class Product {
  final int id;
  final String title;
  final double price;
  
  Product({required this.id, required this.title, required this.price});
  
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
```


### Comparación con `http`

| Característica         | Chopper | http |
|------------------------|---------|------|
| Interceptores         | Sí      | No   |
| Serialización automática | Sí  | No   |
| Manejo de errores     | Robusto | Básico |
| Caché                 | Sí      | No   |
| Concurrencia         | Alta    | Limitada |

## Ejemplo completo

```dart
import 'package:fake_store_package/fake_store_package.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final fakeStore = FakeStorePackage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Fake Store Example')),
        body: FutureBuilder(
          future: fakeStore.getAllProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final products = snapshot.data!;
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    title: Text(product.title),
                    subtitle: Text('\$${product.price}'),
                    leading: Image.network(product.image),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
```
## Licencia
Este proyecto está bajo la licencia MIT. Consulta el archivo LICENSE para más detalles.
