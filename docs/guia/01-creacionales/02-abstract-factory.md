# 🏭 Abstract Factory (Patrón creacional)

<!-- example: examples/creacionales/abstract_factory.dart -->

## La tienda de kits de cumpleaños

Rocío tiene una tienda de artículos para fiestas. Al principio vendía piezas
sueltas: manteles, platos, vasos y globos. El problema apareció cuando una
clienta compró un mantel de selva, platos espaciales y globos de princesas.
La fiesta quedó preciosa… para nadie.

Rocío cambió el negocio: ahora vende **kits cerrados**. El kit "selva" trae
mantel, platos y globos con el mismo estilo. El kit "espacial" trae otra
familia completa. La clienta elige un kit y se lleva algo que combina; ya no
puede mezclar piezas por accidente.

En el software pasa lo mismo. A veces no basta con crear **un** objeto: hay
que crear **una familia** de objetos que funcionen juntos. Y quien los usa no
debería tener que comprobar que todos sean del mismo estilo.

Eso es una **Abstract Factory**: una fábrica que produce familias completas.
Cada fábrica concreta garantiza que sus productos encajan entre sí.

## La idea en una frase

Una fábrica por familia: si eliges el kit selva, el mantel, los platos y los
globos salen de la selva y combinan.

## ¿Cuándo usarlo?

- Varios productos deben usarse juntos y mezclarlos sería un error.
- El cliente debe cambiar de familia completa sin conocer las clases concretas.
- Quieres garantizar la coherencia de un conjunto, no solo de una pieza.

## ¿Cuándo NO usarlo?

- Solo hay un producto por vez: el Factory Method es suficiente y más simple.
- La familia cambia a menudo. Agregar un producto nuevo obliga a tocar **todas**
  las fábricas; si eso pasa seguido, el patrón se vuelve una carga.
- Los productos no están realmente relacionados: no hay nada que garantizar.

## Implementación en Dart

```dart
// Abstract Factory: una fábrica por familia. Los productos de una misma
// familia están diseñados para usarse juntos.

abstract class Tablecloth {
  String get description;
}

abstract class Plates {
  String get description;
}

abstract class Balloons {
  String get description;
}

class JungleTablecloth implements Tablecloth {
  @override
  String get description => 'Mantel verde con hojas';
}

class JunglePlates implements Plates {
  @override
  String get description => 'Platos con animales de la selva';
}

class JungleBalloons implements Balloons {
  @override
  String get description => 'Globos de colores selváticos';
}

class SpaceTablecloth implements Tablecloth {
  @override
  String get description => 'Mantel azul con estrellas';
}

class SpacePlates implements Plates {
  @override
  String get description => 'Platos con planetas';
}

class SpaceBalloons implements Balloons {
  @override
  String get description => 'Globos plateados';
}

abstract class PartyKitFactory {
  String get theme;

  Tablecloth createTablecloth();

  Plates createPlates();

  Balloons createBalloons();
}

class JungleKitFactory implements PartyKitFactory {
  @override
  String get theme => 'Selva';

  @override
  Tablecloth createTablecloth() => JungleTablecloth();

  @override
  Plates createPlates() => JunglePlates();

  @override
  Balloons createBalloons() => JungleBalloons();
}

class SpaceKitFactory implements PartyKitFactory {
  @override
  String get theme => 'Espacio';

  @override
  Tablecloth createTablecloth() => SpaceTablecloth();

  @override
  Plates createPlates() => SpacePlates();

  @override
  Balloons createBalloons() => SpaceBalloons();
}

void run() {
  final factories = <PartyKitFactory>[
    JungleKitFactory(),
    SpaceKitFactory(),
  ];

  for (final factory in factories) {
    print('--- Kit ${factory.theme} ---');
    print(factory.createTablecloth().description);
    print(factory.createPlates().description);
    print(factory.createBalloons().description);
    print('');
  }
}

void main() => run();
```

## 🚀 Ejemplo de uso

```bash
dart run examples/creacionales/abstract_factory.dart
```

```text
--- Kit Selva ---
Mantel verde con hojas
Platos con animales de la selva
Globos de colores selváticos

--- Kit Espacio ---
Mantel azul con estrellas
Platos con planetas
Globos plateados
```

Si mañana aparece un kit "princesas", se crea `PrincessKitFactory` con sus tres
productos. El bucle que arma la fiesta no cambia una línea.

## Se parece a...

- **Factory Method:** crea **un** producto y deja que las subclases decidan
  cuál. Abstract Factory crea **una familia** y garantiza que combine.
- **Builder:** construye un objeto complejo paso a paso. Aquí no hay pasos:
  hay un conjunto de productos que se piden de golpe.
- **Facade:** simplifica el acceso a un sistema existente; no crea familias de
  objetos.

## En Flutter

Elegir Material o Cupertino **no** es una Abstract Factory: son conjuntos de
widgets, no fábricas que crean productos. El patrón aparece en capas propias,
por ejemplo cuando necesitas crear una familia coherente de componentes de una
marca y quieres impedir que se mezclen estilos.

## Resumen

- Una fábrica concreta produce una familia completa de productos.
- El cliente elige la familia una vez y no mezcla estilos.
- Su punto débil: agregar un producto nuevo obliga a tocar todas las fábricas.
