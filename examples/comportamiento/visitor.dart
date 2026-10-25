// Visitor: agrega operaciones nuevas a una jerarquía de objetos sin modificar
// las clases de esa jerarquía.

abstract class Artwork {
  String get title;

  R accept<R>(ArtVisitor<R> visitor);
}

class Painting implements Artwork {
  @override
  final String title;

  final int year;
  final double baseValue;

  const Painting(this.title, this.year, this.baseValue);

  @override
  R accept<R>(ArtVisitor<R> visitor) => visitor.visitPainting(this);
}

class Sculpture implements Artwork {
  @override
  final String title;

  final String material;
  final double weight;
  final double baseValue;

  const Sculpture(this.title, this.material, this.weight, this.baseValue);

  @override
  R accept<R>(ArtVisitor<R> visitor) => visitor.visitSculpture(this);
}

class Photograph implements Artwork {
  @override
  final String title;

  final int copies;
  final double baseValue;

  const Photograph(this.title, this.copies, this.baseValue);

  @override
  R accept<R>(ArtVisitor<R> visitor) => visitor.visitPhotograph(this);
}

abstract class ArtVisitor<R> {
  R visitPainting(Painting painting);

  R visitSculpture(Sculpture sculpture);

  R visitPhotograph(Photograph photograph);
}

class AppraisalVisitor implements ArtVisitor<double> {
  const AppraisalVisitor();

  @override
  double visitPainting(Painting painting) {
    return painting.year < 1950 ? painting.baseValue * 1.2 : painting.baseValue;
  }

  @override
  double visitSculpture(Sculpture sculpture) {
    return sculpture.baseValue + sculpture.weight * 50;
  }

  @override
  double visitPhotograph(Photograph photograph) {
    return photograph.baseValue * photograph.copies;
  }
}

class ConditionVisitor implements ArtVisitor<String> {
  const ConditionVisitor();

  @override
  String visitPainting(Painting painting) => 'Requiere limpieza';

  @override
  String visitSculpture(Sculpture sculpture) => 'Estructura estable';

  @override
  String visitPhotograph(Photograph photograph) => 'Copias en buen estado';
}

void run() {
  final works = <Artwork>[
    const Painting('El jardín de las horas', 1920, 5000),
    const Sculpture('Figura de bronce', 'bronce', 12, 3000),
    const Photograph('Retrato de la plaza', 40, 800),
  ];

  const appraisal = AppraisalVisitor();
  const condition = ConditionVisitor();

  for (final work in works) {
    final value = work.accept(appraisal);
    print('${work.title} | valor: \$${value.toStringAsFixed(2)} | '
        '${work.accept(condition)}');
  }
}

void main() => run();
