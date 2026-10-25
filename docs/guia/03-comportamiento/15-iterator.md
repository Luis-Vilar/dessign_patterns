# 🔄 Iterator (Patrón de comportamiento)

<!-- example: examples/comportamiento/iterator.dart -->

## La rockola de Ramón

Ramón tiene una rockola en su bar. Los clientes eligen canciones y la máquina
las va poniendo una por una. Para el cliente, el trámite es simple: aprieta
"seguir" y suena la siguiente. No necesita saber si las canciones están en un
disco, en una memoria o en una lista desordenada por dentro.

La rockola expone un recorrido, no su almacenamiento. Además, si mañana cambia
el mecanismo interno, los clientes siguen usando el mismo botón. Eso es un
**Iterator**: un objeto que permite recorrer una colección sin revelar cómo
está construida por dentro.

## La idea en una frase

Un cursor que entrega el siguiente elemento sin mostrar la estructura que hay
detrás.

## ¿Cuándo usarlo?

- Quieres recorrer una colección sin exponer su representación interna.
- Necesitas varias formas de recorrido sobre la misma colección.
- Quieres una forma uniforme de recorrer estructuras distintas.

## ¿Cuándo NO usarlo?

- Una lista simple y un `for` alcanzan: el iterador solo agrega ceremonia.
- Necesitas acceso aleatorio por índice y la colección ya lo ofrece.
- El recorrido es tan específico que el iterador termina siendo una copia de la
  estructura.

## Implementación en Dart

```dart
// Iterator: recorre una colección sin exponer cómo está guardada por dentro.

class Product {
  final String name;
  final double price;

  const Product(this.name, this.price);
}

// Nombres propios para no confundirlos con Iterator/Iterable de Dart.
abstract class CatalogIterator<T> {
  bool get hasNext;

  T next();
}

abstract class CatalogCollection<T> {
  CatalogIterator<T> createIterator();
}

class ProductCatalog implements CatalogCollection<Product> {
  final List<Product> _products;

  ProductCatalog(this._products);

  @override
  CatalogIterator<Product> createIterator() => _ProductIterator(_products);
}

class _ProductIterator implements CatalogIterator<Product> {
  final List<Product> _items;
  int _index = 0;

  _ProductIterator(this._items);

  @override
  bool get hasNext => _index < _items.length;

  @override
  Product next() {
    if (!hasNext) {
      throw StateError('No hay más elementos');
    }
    final item = _items[_index];
    _index++;
    return item;
  }
}

void run() {
  final catalog = ProductCatalog(<Product>[
    const Product('Teclado', 25),
    const Product('Mouse', 15),
    const Product('Monitor', 180),
  ]);

  final iterator = catalog.createIterator();
  while (iterator.hasNext) {
    final product = iterator.next();
    print('${product.name}: \$${product.price.toStringAsFixed(2)}');
  }
}

void main() => run();
```

## 🚀 Ejemplo de uso

```bash
dart run examples/comportamiento/iterator.dart
```

```text
Teclado: $25.00
Mouse: $15.00
Monitor: $180.00
```

El cliente nunca tocó `_products`. Solo pidió el siguiente hasta que no hubo
más. Si mañana el catálogo se guarda en un árbol o en una base de datos, el
bucle no cambia porque solo conoce `CatalogIterator`.

## Se parece a...

- **Composite:** recorre un árbol completo; Iterator puede recorrer cualquier
  colección, incluida una plana.
- **Visitor:** también recorre elementos, pero su objetivo es aplicar
  operaciones distintas a cada tipo.
- **Factory Method:** puede crear el iterador adecuado para cada colección.

## En Flutter

Dart ya trae `Iterable` e `Iterator` en el lenguaje, pero su interfaz nativa
usa `moveNext()` y `current`, no `hasNext` y `next()`. Por eso las interfaces
de este ejemplo se llaman `CatalogIterator` y `CatalogCollection`: enseñan el
patrón sin chocar con los nombres del lenguaje. `for (final item in coleccion)`
usa la interfaz nativa; Flutter aprovecha lo mismo en widgets como
`ListView.builder`, que pide los elementos por índice a medida que los
necesita.

## Resumen

- Iterator separa el recorrido de la estructura de datos.
- El cliente solo ve `hasNext` y `next`.
- Permite cambiar la colección sin romper a quien la recorre.
