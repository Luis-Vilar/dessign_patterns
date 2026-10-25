# 🔄 Visitor (Patrón de comportamiento)

<!-- example: examples/comportamiento/visitor.dart -->

## La auditoría del museo

Un museo tiene una colección de obras: cuadros, esculturas y fotografías. Cada
poco tiempo recibe especialistas distintos. Una tasadora calcula el valor de
cada obra; una restauradora evalúa su estado; una fotógrafa prepara el catálogo
visual.

Si cada especialista tuviera que abrir las clases de las obras para agregar su
propio método, la colección se llenaría de código de áreas que no tienen nada
que ver entre sí. Y cada especialista nuevo obligaría a tocar todas las clases.

En cambio, el museo usa la misma puerta para todos: cada obra acepta un
**visitante** y le dice de qué tipo es. La tasadora visita cuadros, esculturas
y fotografías; la restauradora hace lo suyo; la fotógrafa también. Las obras no
cambian. Eso es **Visitor**: agregar operaciones nuevas a una jerarquía sin
modificar sus clases.

## La idea en una frase

La estructura de objetos se queda quieta; las operaciones nuevas llegan como
visitantes externos.

## ¿Cuándo usarlo?

- Tienes una jerarquía estable y muchas operaciones distintas sobre ella.
- Quieres mantener cada operación separada, en su propia clase.
- Agregar un método a cada clase de la jerarquía ensuciaría el diseño.

## ¿Cuándo NO usarlo?

- La jerarquía cambia seguido: cada tipo nuevo obliga a tocar **todos** los
  visitantes.
- Hay pocas operaciones y son estables: métodos normales son más simples.
- Los tipos tienen poca relación entre sí y no comparten una interfaz de
  aceptación.

## Implementación en Dart

```dart
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
```

## 🚀 Ejemplo de uso

```bash
dart run examples/comportamiento/visitor.dart
```

```text
El jardín de las horas | valor: $6000.00 | Requiere limpieza
Figura de bronce | valor: $3600.00 | Estructura estable
Retrato de la plaza | valor: $32000.00 | Copias en buen estado
```

La clave es el **doble despacho**: el cliente llama a `accept`, la obra decide
qué método del visitante invocar, y el visitante recibe el tipo concreto. Así
se evita preguntar `if (work is Painting)` por todos lados.

## Se parece a...

- **Composite:** recorre una estructura de objetos; Visitor define qué
  operación aplicar sobre cada tipo.
- **Strategy:** encapsula un algoritmo para un objeto. Visitor encapsula una
  operación para **muchos tipos** de objetos.
- **Iterator:** se encarga de recorrer; Visitor de operar sobre lo recorrido.

## En Flutter

En el código de una app Flutter no es un patrón frecuente. Aparece más en
herramientas que recorren árboles y aplican operaciones distintas a cada tipo,
como analizadores, inspectores o generadores de código. Si tu jerarquía de
widgets no cambia y necesitas muchas operaciones externas, puede tener sentido;
si cambia seguido, probablemente no.

## Resumen

- Visitor separa las operaciones de la estructura de objetos.
- Agregar una operación nueva no toca las clases visitadas.
- Agregar un tipo nuevo sí obliga a tocar todos los visitantes.
