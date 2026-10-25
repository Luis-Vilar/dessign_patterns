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
