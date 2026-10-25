// Decorator: agrega comportamiento a un objeto envolviéndolo con otro objeto
// que implementa la misma interfaz.

abstract class Gift {
  String describe();

  double price();
}

class BookGift implements Gift {
  final String title;

  const BookGift(this.title);

  @override
  String describe() => 'Libro "$title"';

  @override
  double price() => 20.0;
}

abstract class GiftDecorator implements Gift {
  final Gift gift;

  const GiftDecorator(this.gift);

  @override
  String describe() => gift.describe();

  @override
  double price() => gift.price();
}

class WrappingPaper extends GiftDecorator {
  const WrappingPaper(super.gift);

  @override
  String describe() => '${gift.describe()} con papel de regalo';

  @override
  double price() => gift.price() + 2.5;
}

class Ribbon extends GiftDecorator {
  const Ribbon(super.gift);

  @override
  String describe() => '${gift.describe()} con moño';

  @override
  double price() => gift.price() + 1.5;
}

class Card extends GiftDecorator {
  const Card(super.gift);

  @override
  String describe() => '${gift.describe()} con tarjeta';

  @override
  double price() => gift.price() + 3.0;
}

void run() {
  const base = BookGift('El jardín de las horas');
  print('${base.describe()} -> \$${base.price().toStringAsFixed(2)}');

  const wrapped = WrappingPaper(base);
  print('${wrapped.describe()} -> \$${wrapped.price().toStringAsFixed(2)}');

  const full = Card(Ribbon(wrapped));
  print('${full.describe()} -> \$${full.price().toStringAsFixed(2)}');
}

void main() => run();
