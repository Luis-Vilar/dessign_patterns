// Bridge: separa una abstracción (la publicación) de su implementación (la
// prensa) para que ambas puedan variar sin multiplicar clases.

abstract class PrintingPress {
  String get name;

  String print(String content);
}

class DigitalPress implements PrintingPress {
  @override
  String get name => 'digital';

  @override
  String print(String content) => 'Impresión digital de "$content"';
}

class OffsetPress implements PrintingPress {
  @override
  String get name => 'offset';

  @override
  String print(String content) => 'Impresión offset de "$content"';
}

abstract class Publication {
  final PrintingPress press;

  Publication(this.press);

  String produce();
}

class Book extends Publication {
  final String title;

  Book(super.press, this.title);

  @override
  String produce() {
    return 'Libro "$title" -> ${press.print('texto de $title')}';
  }
}

class Magazine extends Publication {
  final String name;

  Magazine(super.press, this.name);

  @override
  String produce() {
    return 'Revista "$name" -> ${press.print('artículos de $name')}';
  }
}

void run() {
  final book = Book(DigitalPress(), 'El jardín de las horas');
  final magazine = Magazine(OffsetPress(), 'Mundo Curioso');

  print(book.produce());
  print(magazine.produce());
}

void main() => run();
