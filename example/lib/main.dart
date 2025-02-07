import 'package:fake_store_package/fake_store_package.dart';
import 'package:fake_store_package/helpers/log_printer/log_printer.dart';
import 'package:flutter/material.dart';


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
  // instancia de FakeStorePackage
  final fakeStore = FakeStorePackage();

  String? _selectedOption; // opción seleccionada del dropdown
  final LoggerService loggerService = LoggerService(); // servicio de log

   final TextEditingController _controllerTitle = TextEditingController(); // controller del campo de texto del titulo del producto
   final TextEditingController _controllerDescription = TextEditingController(); // controller del campo de texto de la descripción del producto
   final TextEditingController _controllerPrice = TextEditingController(); // controller del campo de texto del precio del producto
   final TextEditingController _controllerId = TextEditingController(); // controller del campo de texto del id del producto
   final TextEditingController _controllerCartProductId = TextEditingController(); // controller del campo de texto del id del producto en el carrito
   final TextEditingController _controllerCartProductQuantity = TextEditingController(); // controller del campo de texto de la cantidad del producto en el carrito
   List<String> _options = ['Opción 1', 'Opción 2', 'Opción 3']; // opciones del dropdown

  @override
  void initState() {
    super.initState();
    obtenerProductos(); //invocación de función para obtener productos
    obtenerCategorias(); //invocación de función para obtener categorías
    obtenerCarrito();   //invocación de función para obtener carrito
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Package Example')),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20,top: 20),
        child: Column(
          children: [
            const Text("Informacion del producto"),
            // campos donde reflejamos la información del producto
          TextField(
            controller: _controllerTitle,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: 'Título',
            ),
          ),
            const SizedBox(height: 20),
            TextField(
              controller: _controllerDescription,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Descripción',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controllerPrice,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Precio',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controllerId,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Color',
              ),
            ),
            const SizedBox(height: 20),
         // Dropdown para seleccionar una opción entre las categorias

          DropdownButton<String>(
          hint: const Text('Selecciona una categoria'),
          value: _selectedOption,
          onChanged: (String? newValue) {
            setState(() {
              _selectedOption = newValue;
            });
          },
          items: _options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
            const SizedBox(height: 20),
            const Text("Informacion del carrito de compras"),
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
               // Icono de carrito
                  const Icon(Icons.shopping_cart , size: 50),
                  const SizedBox(height: 20),
                  // Campos de texto para el id y la cantidad del producto en el carrito
                  TextField(
                    controller: _controllerCartProductId,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'id de producto',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _controllerCartProductQuantity,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'cantidad de producto',
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }




 // Función para obtener productos
  Future<void> obtenerProductos  () async {
    final products = await fakeStore.getAllProducts();
    products.fold(
            (error) => loggerService.logError('Error al obtener los productos: $error'),
            (products) {
          loggerService.logInfo('Productos obtenidos:');
          for (var product in products) {
            loggerService.logInfo(
                'Producto: ${product.title}, \$${product.price}');
          }
          // actualizamos los controladores de texto para fijar los valores del producto
          setState(() {
            _controllerTitle.text = products[0].title;
            _controllerDescription.text = products[0].description;
            _controllerPrice.text = products[0].price.toString();
            _controllerId.text = products[0].id.toString();
          });

        } );

  }

 // Función para obtener categorías
  Future<void> obtenerCategorias() async {
    final categoriesResult = await fakeStore.getCategories();
    categoriesResult.fold(
          (error) => loggerService.logError('Error al obtener las categorías: $error'),
          (categories) {
            loggerService.logInfo('Categorías: ${categories.categories.join(', ')}');
            setState(() {
              // actualizamos las opciones del dropdown con las categorias obtenidas
              _options = categories.categories;
            });
          },
    );
  }

 // Función para obtener carrito
  void obtenerCarrito() async {
    final cart = await fakeStore.getCart(2);
    cart.fold(
          (error) => loggerService.logError('Error al obtener el carrito: $error'),
          (cart) {
            loggerService.logInfo('Carrito obtenido:');
// actualizamos los controladores de texto para fijar los valores del carrito
            setState(() {
                _controllerCartProductId.text  = cart[0].products[0].productId.toString();
              _controllerCartProductQuantity.text = cart[0].products[0].quantity.toString();
            });



          },
    );
  }
}
