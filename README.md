<!--
este archivo es el readme del package api fake store publicado  en git hub
-->
# fake_store_api
 este package es una aplicación dart destinada al consumo de la api fake store  y a la demostración de manejo de errores
## Descripción
este packege te permite interactuar con la fake store api y obtener mediante las funciones elaboradas en el package
información relacionada a los productos de la api,un producto en especifico , productos por categoria, las categorias existentes y el carrito de compras(añadirlo y editarlo),
asi como la creación de usuario y el login.

## ejemplo de uso
aqui puedes observar un ejemplo de como usar el package para obtener un producto en especifico en conjunto con la impresion de sus valores en consola

// instancia de FakeStorePackage
final fakeStore = FakeStorePackage();

loggerService.logInfo('\nObteniendo detalles del producto con ID 1...');
// Obtener un producto por ID
final productResult = await fakeStore.getProduct(1);
productResult.fold(
(error) => loggerService.logError('Error al obtener el producto: $error'),
(product) => loggerService.logInfo('Producto obtenido: ${product.title}, \$${product.price}'),
);



## Usage
para usar este package solo debes importarlo en tu archivo pubspec.yaml y usar las funciones que se encuentran en el package
en este caso desde git hub puedes importarlo de la siguiente manera
 git :
    url: 'https://github.com/YordiColina/fake_store_package.git'  //aqui va la url de el package en git hub
    ref: 'master' //aqui va la rama de el package en este caso master
    path: '/..' //aqui va la carpeta donde se encuentra el package solo si cuentas con mas de uno

en el example puedes observar un ejemplo de como usar el package para obtener una lista de productos , una lista de categorias y un carrito de compras


to `/example` folder.


const like = 'sample';
```
