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
