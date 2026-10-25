# 🧱 Flyweight (Patrón estructural)

<!-- example: examples/estructurales/flyweight.dart -->

## El estadio de la ciudad

El estadio de la ciudad tiene cuarenta mil asientos. Cada asiento conoce su
fila, su número y su categoría: preferencia, general o palco. La categoría
define el color y el precio.

Al principio el sistema guardaba una copia completa de la categoría en cada
asiento: cuarenta mil objetos con el mismo color y el mismo precio repetidos.
El mapa del estadio funcionaba, pero consumía una memoria absurda para mostrar
solo tres categorías.

La solución fue separar lo que se repite de lo que cambia. La categoría se
guarda **una sola vez** y se comparte. Cada asiento guarda solo su fila, su
número y una referencia a la categoría compartida. Cuarenta mil asientos, tres
categorías. Eso es **Flyweight**: compartir lo que se repite para que la
memoria no explote.

## La idea en una frase

Comparte el estado que se repite y guarda por separado el estado que cambia en
cada objeto.

## ¿Cuándo usarlo?

- Tienes muchísimos objetos y la memoria es el cuello de botella.
- La mayor parte de su estado es igual entre ellos y no cambia.
- El estado variable se puede calcular o pasar desde fuera.

## ¿Cuándo NO usarlo?

- Hay pocos objetos: el ahorro no compensa la complejidad.
- El estado supuestamente compartido cambia: todos los objetos verían el
  cambio.
- El costo de buscar la instancia compartida es mayor que el de crear el
  objeto.

## Implementación en Dart

```dart
// Flyweight: comparte el estado intrínseco (lo que se repite) entre muchos
// objetos y deja fuera el estado extrínseco (lo que cambia en cada uno).

class SeatType {
  final String section;
  final String color;
  final double price;

  const SeatType(this.section, this.color, this.price);

  void describe(int row, int number) {
    print('Fila $row, asiento $number | $section | $color | '
        '\$${price.toStringAsFixed(2)}');
  }
}

class SeatTypeFactory {
  static final Map<String, SeatType> _cache = <String, SeatType>{};

  static SeatType get(String section, String color, double price) {
    final key = '$section|$color|$price';
    return _cache.putIfAbsent(
      key,
      () => SeatType(section, color, price),
    );
  }

  static int get uniqueCount => _cache.length;
}

class Seat {
  final int row;
  final int number;
  final SeatType type;

  const Seat(this.row, this.number, this.type);

  void describe() => type.describe(row, number);
}

class Stadium {
  final List<Seat> _seats = <Seat>[];

  void addSeat(
      int row, int number, String section, String color, double price) {
    final type = SeatTypeFactory.get(section, color, price);
    _seats.add(Seat(row, number, type));
  }

  void list() {
    for (final seat in _seats) {
      seat.describe();
    }
  }

  int get seatCount => _seats.length;
}

void run() {
  final stadium = Stadium();

  for (var i = 0; i < 3; i++) {
    stadium.addSeat(1, i + 1, 'Preferencia', 'azul', 80);
  }
  for (var i = 0; i < 2; i++) {
    stadium.addSeat(2, i + 1, 'General', 'verde', 40);
  }

  stadium.list();
  print('Asientos: ${stadium.seatCount} | '
      'tipos únicos: ${SeatTypeFactory.uniqueCount}');
}

void main() => run();
```

## 🚀 Ejemplo de uso

```bash
dart run examples/estructurales/flyweight.dart
```

```text
Fila 1, asiento 1 | Preferencia | azul | $80.00
Fila 1, asiento 2 | Preferencia | azul | $80.00
Fila 1, asiento 3 | Preferencia | azul | $80.00
Fila 2, asiento 1 | General | verde | $40.00
Fila 2, asiento 2 | General | verde | $40.00
Asientos: 5 | tipos únicos: 2
```

Cinco asientos y solo dos objetos `SeatType`. En un estadio real la diferencia
es la que separa un mapa que carga rápido de uno que agota la memoria.

## Se parece a...

- **Singleton:** garantiza **una** instancia. Flyweight puede tener varias
  instancias compartidas, identificadas por una clave.
- **Object pool:** reutiliza objetos que se prestan y se devuelven. Flyweight
  comparte estado inmutable de forma permanente.
- **Caché:** también evita recalcular, pero su objetivo principal es la
  velocidad. Flyweight busca ahorrar memoria en objetos numerosos.

## En Flutter

Los widgets `const` se canonicalizan: si escribes el mismo widget constante dos
veces, Flutter reutiliza la misma instancia. Además, `ImageCache` comparte las
imágenes ya decodificadas en lugar de mantener una copia por widget.

## Resumen

- Flyweight separa estado compartido (intrínseco) de estado propio
  (extrínseco).
- Sirve cuando hay muchos objetos y poca variedad.
- La clave está en que lo compartido sea inmutable.
